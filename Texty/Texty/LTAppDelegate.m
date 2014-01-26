#import "LTAppDelegate.h"
#import "LTViewController.h"

@implementation LTAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[LTViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];

    return YES;
}
							
@end
