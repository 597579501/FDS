
#import <UIKit/UIKit.h>

extern NSString * const kMSNavigationBar_ScrollToTopNotification;

/**
 * This is an extension to the UINavigationBar which replaces some objective-C methods
 * of the UINavigationBar in order to support a navigation bar graphic.
 *
 * The use of the navigation bar is controlled through setting a special tag, so it is
 * not possible to combine use of this mix-in with use of the tag property.
 */

@interface UINavigationBar(MSExtension)

- (void)setIsMSNavigationBar;
//- (void)drawRect_MSNavigationBar:(CGRect)aRect;

@end
