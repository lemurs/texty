#import "LTViewController.h"
#import "LTTextViewDelegate.h"

@interface LTViewController () <UITextViewDelegate>
@property (strong) LTTextViewDelegate *textViewDelegate;
@end

@implementation LTViewController

#pragma mark - UIViewController

- (void)loadView;
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];

    static const CGFloat givenMaximumFontSize = 50.0;

    self.textViewDelegate = [[LTTextViewDelegate alloc] init];

    UITextView *textView = [[UITextView alloc] initWithFrame:view.bounds textContainer:nil];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    textView.delegate = self.textViewDelegate;
    textView.font = [UIFont systemFontOfSize:givenMaximumFontSize];
    textView.returnKeyType = UIReturnKeyDone;
    textView.text = NSLocalizedString(@"Hello, Lemurs!", @"Traditional greeting");
    textView.textAlignment = NSTextAlignmentCenter;
    [view addSubview:textView];

    self.view = view;
}

@end
