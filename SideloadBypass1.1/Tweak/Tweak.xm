#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

%hook SCUser

- (BOOL)isSubscriptionGranted {
    NSLog(@"[Bypass v1.1] Checking subscription");
    // Edge-case: if the app changes its internal flag, read a user-defaults override first
    id forced = [[NSUserDefaults standardUserDefaults] objectForKey:@"forcePremium"];
    if ([forced isKindOfClass:[NSNumber class]]) {
        return [forced boolValue];
    }
    // Default bypass
    return YES;
}

- (void)setIsSubscriptionGranted:(BOOL)value {
    NSLog(@"[Bypass v1.1] Attempt to set subscription: %d", value);
    // Always force it back to YES
    %orig(YES);
}

%end
