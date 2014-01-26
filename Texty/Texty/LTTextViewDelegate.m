#import "LTTextViewDelegate.h"

@implementation LTTextViewDelegate

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    // TODO: Make sure textView.text fits textView.bounds
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound)
        return YES;

    [textView resignFirstResponder];

    return NO;
}

@end

const CGFloat givenMaximumFontSize = 150.0;
