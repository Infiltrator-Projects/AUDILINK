// SPDX-License-Identifier: GPL-3.0-or-later
#include "audilink/diagnostics.h"

#include <stdio.h>
#include <string.h>

#define CHECK(x) do { if (!(x)) { fprintf(stderr, "FAIL: %s\n", #x); return 1; } } while (0)

int main(void)
{
    AudilinkAdapterCapabilities caps;
    const uint8_t read_did[] = {0x22U, 0xf1U, 0x90U};
    const uint8_t security[] = {0x27U, 0x01U};
    link_safety_result safety;
    uint8_t doip[64U];
    size_t doip_length = 0U;
    uint16_t source = 0U, target = 0U;
    const uint8_t *payload = NULL;
    size_t payload_length = 0U;
    AudilinkParameterStore parameters;
    AudilinkScheduler scheduler;
    LinkSchedulerDispatch dispatch;
    AudilinkTelemetryStore telemetry;

    CHECK(audilink_adapter_capabilities(LINK_ADAPTER_KIND_ELM327, &caps));
    CHECK((caps.flags & LINK_ADAPTER_CAP_ELM_COMMAND_SURFACE) != 0U);
    CHECK(audilink_elm327_protocol_definition_count() >= 10U);
    CHECK(audilink_diagnostic_execution_mode_for_adapter(LINK_ADAPTER_KIND_ELM327) == LINK_DIAGNOSTIC_EXECUTION_ELM_COMMAND_SURFACE);
    CHECK(audilink_diagnostic_execution_mode_for_adapter(LINK_ADAPTER_KIND_TACTRIX_OPENPORT2) == LINK_DIAGNOSTIC_EXECUTION_ELM_COMMAND_SURFACE);
    CHECK(audilink_diagnostic_execution_mode_for_adapter(LINK_ADAPTER_KIND_STM32_LINK) == LINK_DIAGNOSTIC_EXECUTION_NATIVE_ISOTP);
    CHECK(audilink_isotp_can_data_length_is_valid(false, 8U));
    CHECK(audilink_isotp_can_data_length_is_valid(true, 64U));
    CHECK(audilink_uds_standard_service_count() == LINK_UDS_STANDARD_SERVICE_COUNT);
    CHECK(audilink_uds_standard_service_find(LINK_UDS_SERVICE_READ_DATA_BY_IDENTIFIER) != NULL);

    safety = audilink_safety_classify(read_did, sizeof(read_did));
    CHECK(safety.decision == LINK_SAFETY_ALLOW_READ_ONLY);
    safety = audilink_safety_classify(security, sizeof(security));
    CHECK(safety.decision == LINK_SAFETY_BLOCK);

    CHECK(audilink_doip_build_diagnostic_message(0x02U, 0x0e80U, 0x1000U, read_did, sizeof(read_did), doip, sizeof(doip), &doip_length) == LINK_DOIP_RESULT_OK);
    CHECK(audilink_doip_decode_diagnostic_message(doip, doip_length, &source, &target, &payload, &payload_length) == LINK_DOIP_RESULT_OK);
    CHECK(source == 0x0e80U && target == 0x1000U);
    CHECK(payload_length == sizeof(read_did));
    CHECK(memcmp(payload, read_did, sizeof(read_did)) == 0);

    CHECK(audilink_parameter_obd2_definition_count() > 0U);
    audilink_parameter_store_init(&parameters);
    CHECK(audilink_parameter_store_definition_count(&parameters) == 0U);

    audilink_scheduler_init(&scheduler);
    CHECK(audilink_scheduler_next(&scheduler, 0U, &dispatch) == LINK_SCHEDULER_NEXT_EMPTY);

    audilink_telemetry_store_init(&telemetry);
    CHECK(audilink_telemetry_store_history_count(&telemetry) == 0U);

    puts("AUDILINK generic LINK diagnostics baseline passed");
    return 0;
}
