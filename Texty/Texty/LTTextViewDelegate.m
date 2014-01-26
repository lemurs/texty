#import "LTTextViewDelegate.h"

@implementation LTTextViewDelegate

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    textView.font = [textView.font fontWithSize:[self.class fontSizeWithTextView:textView]];
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
    CGSize textSize = UIEdgeInsetsInsetRect(textView.bounds, textView.textContainerInset).size;
    __block CGFloat fontSize = givenMaximumFontSize;

    NSArray *everyWord = [textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   [everyWord enumerateObjectsUsingBlock:^(NSString *eachWord, NSUInteger stringIndex, BOOL *stop) {
        while ([eachWord sizeWithAttributes:@{NSFontAttributeName: [textView.font fontWithSize:fontSize]}].width > textSize.width)
            fontSize--;
    }];

    while ([textView.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}].height > textSize.height)
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
