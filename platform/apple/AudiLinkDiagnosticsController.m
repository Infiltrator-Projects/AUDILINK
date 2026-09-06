// SPDX-License-Identifier: GPL-3.0-or-later
#import "AudiLinkDiagnosticsController.h"
@implementation AudiLinkDiagnosticsController

- (instancetype)init
{
    LinkDiagnosticFlowConfig config = LINK_DIAGNOSTIC_FLOW_CONFIG_INIT;
    config.preserve_pid_discovery_response_headers = true;
    config.preserve_live_response_headers = true;
    self = [super
        initWithProductSlug:@"audilink"
        flowConfig:config
        liveStatusText:@"Live diagnostics active"
        simulatedLiveStatusText:@"Simulated diagnostics active"
        standardVINStatusText:@"Reading standard VIN"
        simulatedAdapterIdentifier:@"ELM327 v2.3 AUDILINK SIM"
        simulatedVIN:@"WAUZZZ8K9DA123456"];
    return self;
}

- (void)productDiagnosticsDidUpdate
{
    [self.delegate diagnosticsControllerDidUpdate:self];
}

@end
