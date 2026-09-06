// SPDX-License-Identifier: GPL-3.0-or-later
#import <Foundation/Foundation.h>
#import "../../src/link/platform/apple/LinkDiagnosticsController.h"

NS_ASSUME_NONNULL_BEGIN
@class AudiLinkDiagnosticsController;
@protocol AudiLinkDiagnosticsControllerDelegate <NSObject>
- (void)diagnosticsControllerDidUpdate:(AudiLinkDiagnosticsController *)controller;
@end

@interface AudiLinkDiagnosticsController : LinkProductDiagnosticsController
- (instancetype)init;
@property(nonatomic, weak, nullable) id<AudiLinkDiagnosticsControllerDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
