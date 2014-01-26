#import "LTViewController.h"

@interface LTViewController ()

@end

@implementation LTViewController

#pragma mark - UIViewController

- (void)loadView;
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

@end
