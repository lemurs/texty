#import "LTTextViewDelegate.h"

@implementation LTTextViewDelegate

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound)
        return YES;

    [textView resignFirstResponder];

    return NO;
}

@end
