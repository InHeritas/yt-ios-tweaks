#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface _ASDisplayView : UIView
@property (nonatomic, copy) NSString *accessibilityIdentifier;
- (void)didMoveToWindow;
@end

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
