#import "LTTextViewDelegate.h"

@implementation LTTextViewDelegate

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    textView.font = [UIFont systemFontOfSize:[self.class fontSizeWithTextView:textView]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound)
        return YES;

    [textView resignFirstResponder];

    return NO;
}

#pragma mark - API

+ (CGFloat)fontSizeWithTextView:(UITextView *)textView;
{
    CGFloat fontSize = givenMaximumFontSize;
    while (CGRectGetHeight([textView.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(textView.bounds), CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:self.stringDrawingContext]) > CGRectGetHeight(textView.bounds))
        fontSize--;

    return floor(fontSize);
}

+ (NSStringDrawingContext *)stringDrawingContext;
{
    static NSStringDrawingContext *stringDrawingContext;
    return stringDrawingContext ? : (stringDrawingContext = [[NSStringDrawingContext alloc] init]);
}

@end

const CGFloat givenMaximumFontSize = 150.0;
