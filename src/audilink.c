// SPDX-License-Identifier: GPL-3.0-or-later
#include "audilink/audilink.h"

#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif

#if defined(__APPLE__) && TARGET_OS_IOS
#include "link/platform/apple/LinkPortableCore.c"
#endif

const char *audilink_product_name(void){return "AUDILink";}
const char *audilink_brand_name(void){return "Audi";}
const char *audilink_version(void){return AUDILINK_VERSION;}
