#import "LTSettingsViewController.h"

@interface LTSettingsViewController ()
@property (weak) IBOutlet UITextView *textView;
@end

@implementation LTSettingsViewController

#pragma mark - NSObject(UINibLoadingAdditions)

- (void)awakeFromNib;
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}


#pragma mark - UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];

    // TODO: Any additional setup after loading the view
}


#pragma mark - API

- (IBAction)done:(id)sender;
{
    [self.delegate settingsViewControllerDidFinish:self];
}

@end
