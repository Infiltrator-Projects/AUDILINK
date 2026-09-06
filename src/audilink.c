// SPDX-License-Identifier: GPL-3.0-or-later
#include "audilink/audilink.h"

#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif

#if defined(__APPLE__) && TARGET_OS_IOS
#ifndef LINK_SOURCE_REVISION
#define LINK_SOURCE_REVISION "c7df254bf23e3abfbeb87192359c4a35585dd704"
#define AUDILINK_DEFINED_LINK_SOURCE_REVISION 1
#endif
#include "link/platform/apple/LinkPortableCore.c"
#ifdef AUDILINK_DEFINED_LINK_SOURCE_REVISION
#undef AUDILINK_DEFINED_LINK_SOURCE_REVISION
#undef LINK_SOURCE_REVISION
#endif
#endif

const char *audilink_product_name(void){return "AUDILINK";}
const char *audilink_brand_name(void){return "Audi";}
const char *audilink_version(void){return AUDILINK_VERSION;}
