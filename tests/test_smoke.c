// SPDX-License-Identifier: GPL-3.0-or-later
#include "audilink/audilink.h"
#include <stdio.h>
#include <string.h>
int main(void){
 if(strcmp(audilink_product_name(),"AUDILINK")!=0) return 1;
 if(strcmp(audilink_brand_name(),"Audi")!=0) return 2;
 if(strcmp(audilink_version(),"0.2.5")!=0) return 3;
 puts("AUDILINK GUI product smoke test passed");
 return 0;
}
