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

    self.textViewDelegate = [[LTTextViewDelegate alloc] init];

    UITextView *textView = [[UITextView alloc] initWithFrame:view.bounds textContainer:nil];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    textView.delegate = self.textViewDelegate;
    textView.returnKeyType = UIReturnKeyDone;
    textView.text = NSLocalizedString(@"Hello, Lemurs!", @"Traditional greeting");
    textView.textAlignment = NSTextAlignmentCenter;

    textView.font = [textView.font fontWithSize:[self.textViewDelegate.class fontSizeWithTextView:textView]];

    [view addSubview:textView];

    self.view = view;
}

@end
