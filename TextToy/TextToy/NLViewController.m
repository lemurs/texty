#import "NLViewController.h"

static const CGFloat fudge = 5.0;

@interface NLViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation NLViewController

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];

    NSArray *defaultColors = @[
        [UIColor colorWithRed:38.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f],
        [UIColor colorWithRed:114.0f/255.0f green:167.0f/255.0f blue:225.0f/255.0f alpha:1.0f],
        [UIColor colorWithRed:139.0f/255.0f green:185.0f/255.0f blue:237.0f/255.0f alpha:1.0f],
        [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f],
        [UIColor colorWithRed:131.0f/255.0f green:179.0f/255.0f blue:233.0f/255.0f alpha:1.0f],
        [UIColor colorWithRed:114.0f/255.0f green:167.0f/255.0f blue:225.0f/255.0f alpha:1.0f],
        [UIColor colorWithRed:38.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f],
        [UIColor colorWithRed:38.0f/255.0f green:98.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [self.class.colors addObjectsFromArray:defaultColors];

    self.textView.layoutManager.usesFontLeading = NO;
    [self.textView.delegate textViewDidChange:self.textView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.class.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)] ? : [[UITableViewCell alloc] init];

    if (indexPath.row < self.class.colors.count)
        cell.backgroundColor = self.class.colors[indexPath.row];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    CGFloat fontSize = [self.class fontSizeWithTextView:textView];
    textView.font = [textView.font fontWithSize:fontSize];

    CGRect textFrame = UIEdgeInsetsInsetRect(textView.bounds, textView.textContainerInset);
    textFrame.size.width -= 2 * fudge;
    textFrame.origin.x += fudge;

    UIImage *image = [self.class imageWithAttributedText:textView.attributedText textFrame:textFrame colors:self.class.colors];
    self.imageView.image = image;

    NSLog(@"Font is now %@", textView.font);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound)
        return YES;

    [textView resignFirstResponder];

    return NO;
}


#pragma mark - API

+ (NSMutableArray *)colors;
{
    static NSMutableArray *colors;
    return colors ? : (colors = [NSMutableArray array]);
}

+ (CGFloat)fontSizeWithTextView:(UITextView *)textView;
{
    CGSize textSize = UIEdgeInsetsInsetRect(textView.bounds, textView.textContainerInset).size;
    textSize.width -= 2 * fudge;

    __block CGFloat fontSize = givenMaximumFontSize;
    __block CGRect textFrame;

    NSArray *everyWord = [textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [everyWord enumerateObjectsUsingBlock:^(NSString *eachWord, NSUInteger stringIndex, BOOL *stop) {
        while (CGRectGetWidth(textFrame = CGRectIntegral([eachWord boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, textSize.height)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [textView.font fontWithSize:fontSize]} context:self.stringDrawingContext])) > textSize.width) {
            fontSize--;
        }
    }];

    while (CGRectGetHeight(textFrame = CGRectIntegral([textView.text boundingRectWithSize:CGSizeMake(textSize.width, CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [textView.font fontWithSize:fontSize]} context:self.stringDrawingContext])) > textSize.height) {
        fontSize--;
    }

    return fontSize;
}

+ (UIImage *)imageWithAttributedText:(NSAttributedString *)attributedText textFrame:(CGRect)textFrame colors:(NSArray *)colors;
{
    if (textFrame.size.width * textFrame.size.height < 1.0f)
        return nil;

    textFrame.origin = CGPointZero;

    UIGraphicsBeginImageContextWithOptions(textFrame.size, NO, 0.0f);

    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();

    [[UIColor clearColor] setFill];
    CGContextFillRect(graphicsContext, textFrame);

    CGContextSaveGState(graphicsContext);
    CGContextTranslateCTM(graphicsContext, 0, CGRectGetHeight(textFrame));
    CGContextScaleCTM(graphicsContext, 1.0, -1.0);

    // Draw the background stroked text
    CGContextSetTextDrawingMode(graphicsContext, kCGTextStroke);
    CGContextSetLineWidth(graphicsContext, 5.0f);
    [[UIColor blackColor] setStroke];
    [attributedText drawWithRect:textFrame options:NSStringDrawingUsesLineFragmentOrigin context:self.stringDrawingContext];
    CGImageRef backgroundImage = CGBitmapContextCreateImage(graphicsContext);
    CGContextClearRect(graphicsContext, textFrame);

    [[UIColor clearColor] setFill];
    CGContextFillRect(graphicsContext, textFrame);

    // Draw the text as an alpha mask
    CGContextSetTextDrawingMode(graphicsContext, kCGTextFill);
    CGContextSetLineWidth(graphicsContext, 0.0f);
    [[UIColor blackColor] setFill];
    [attributedText drawWithRect:textFrame options:NSStringDrawingUsesLineFragmentOrigin context:self.stringDrawingContext];

    // Recover image and clean up
    CGContextRestoreGState(graphicsContext);
    CGImageRef alphaMask = CGBitmapContextCreateImage(graphicsContext);
    CGContextClearRect(graphicsContext, textFrame);

    // Draw the colors into the mask
    CGContextSaveGState(graphicsContext);
    CGContextClipToMask(graphicsContext, textFrame, alphaMask);
    [colors.lastObject setFill];
    CGContextFillRect(graphicsContext, textFrame);

    __block CGRect frame = textFrame;
    frame.size.height = floor(frame.size.height / (CGFloat)colors.count);
    [colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger index, BOOL *stop) {
        [color setFill];
        frame.origin.y = index * frame.size.height;
        CGContextFillRect(graphicsContext, frame);
    }];

    UIImage *foregroundImage = UIGraphicsGetImageFromCurrentImageContext();

    CGContextRestoreGState(graphicsContext);
    CGImageRelease(alphaMask);

    // Composite final image
    [[UIColor clearColor] setFill];
    CGContextFillRect(graphicsContext, textFrame);
    CGContextDrawImage(graphicsContext, textFrame, backgroundImage);
    [foregroundImage drawInRect:textFrame];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSStringDrawingContext *)stringDrawingContext;
{
    static NSStringDrawingContext *stringDrawingContext;
    return stringDrawingContext ? : (stringDrawingContext = [[NSStringDrawingContext alloc] init]);
}

- (IBAction)toggleImageView:(UIButton *)button;
{
    button.selected = !button.selected;
    self.imageView.hidden = button.selected;
}

@end

const CGFloat givenMaximumFontSize = 150.0;
