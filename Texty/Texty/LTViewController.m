#import "LTViewController.h"

@interface LTViewController () <UITextViewDelegate>

@end

@implementation LTViewController

#pragma mark - UIViewController

- (void)loadView;
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];

    static const CGFloat givenMaximumFontSize = 50.0;

    UITextView *textView = [[UITextView alloc] initWithFrame:view.bounds textContainer:nil];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:givenMaximumFontSize];
    textView.returnKeyType = UIReturnKeyDone;
    textView.text = NSLocalizedString(@"Hello, World!", @"Traditional greeting");
    textView.textAlignment = NSTextAlignmentCenter;
    [view addSubview:textView];

    self.view = view;
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound)
        return YES;

    [textView resignFirstResponder];
    return NO;
}

@end
