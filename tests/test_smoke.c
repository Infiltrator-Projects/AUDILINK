// SPDX-License-Identifier: GPL-3.0-or-later
#include "audilink/audilink.h"
#include <stdio.h>
#include <string.h>

#ifndef AUDILINK_EXPECTED_VERSION
#error "AUDILINK_EXPECTED_VERSION must be supplied by the build"
#endif

int main(void){
 if(strcmp(audilink_product_name(),"AUDILINK")!=0) return 1;
 if(strcmp(audilink_brand_name(),"Audi")!=0) return 2;
 if(strcmp(audilink_version(),AUDILINK_EXPECTED_VERSION)!=0) return 3;
 puts("AUDILINK GUI product smoke test passed");
 return 0;
}
