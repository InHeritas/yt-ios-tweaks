#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface _ASDisplayView : UIView
@property (nonatomic, copy) NSString *accessibilityIdentifier;
- (void)didMoveToWindow;
@end

@interface YTIPivotBarRenderer : NSObject
- (NSMutableArray *)itemsArray;  // Array containing tab bar items
@end

@interface YTIPivotBarSupportedRenderers : NSObject
- (id)pivotBarIconOnlyItemRenderer;
- (id)pivotBarItemRenderer;
@end

@interface YTPivotBarIconOnlyItemRenderer : NSObject
- (NSString *)pivotIdentifier;
@end

@interface YTPivotBarView : UIView
- (void)setRenderer:(YTIPivotBarRenderer *)renderer;
@end

//-------------------------------------------------------------------------------
// Tweak 1: Hide Comment Preview
// Removes the comment preview section shown below videos
//-------------------------------------------------------------------------------
%hook _ASDisplayView
- (void)didMoveToWindow {
    %orig;
    
    NSString *viewID = self.accessibilityIdentifier;
    BOOL isCommentPreview = [viewID isEqualToString:@"id.ui.comments_entry_point_teaser"];
    
    if (isCommentPreview) {
        self.hidden = YES;
        self.alpha = 0.0;
        self.userInteractionEnabled = NO;
        
        CGRect frameRect = self.frame;
        frameRect.size.height = 0;
        self.frame = frameRect;
        
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
        
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
    }
}
%end

//-------------------------------------------------------------------------------
// Tweak 2: Remove Upload Button
// Removes only the upload button (+) from YouTube's bottom tab bar
//-------------------------------------------------------------------------------
%hook YTPivotBarView
- (void)setRenderer:(YTIPivotBarRenderer *)renderer {
    NSMutableArray <YTIPivotBarSupportedRenderers *> *items = [renderer itemsArray];
    
    NSUInteger uploadIndex = [items indexOfObjectPassingTest:^BOOL(YTIPivotBarSupportedRenderers *renderer, NSUInteger idx, BOOL *stop) {
        return [[[renderer pivotBarIconOnlyItemRenderer] pivotIdentifier] isEqualToString:@"FEuploads"];
    }];
    
    if (uploadIndex != NSNotFound) {
        [items removeObjectAtIndex:uploadIndex];
    }
    
    %orig;
}
%end
