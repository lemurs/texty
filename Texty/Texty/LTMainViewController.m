#import "LTMainViewController.h"

@interface LTMainViewController () <LTSettingsViewControllerDelegate, UIPopoverControllerDelegate>
@property (weak) IBOutlet UITextView *textView;
@end

@implementation LTMainViewController

#pragma mark - UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];

    // TODO: Any additional setup after loading the view
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([[segue identifier] isEqualToString:LTMainViewControllerShowAlternateSegueName]) {
        [[segue destinationViewController] setDelegate:self];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.settingsPopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}


#pragma mark - LTSettingsViewControllerDelegate

- (void)settingsViewControllerDidFinish:(LTSettingsViewController *)settingsController;
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.settingsPopoverController dismissPopoverAnimated:YES];
}


#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController;
{
    self.settingsPopoverController = nil;
}


#pragma mark - API

- (IBAction)togglePopover:(id)sender;
{
    if (self.settingsPopoverController) {
        [self.settingsPopoverController dismissPopoverAnimated:YES];
        self.settingsPopoverController = nil;
    } else {
        [self performSegueWithIdentifier:LTMainViewControllerShowAlternateSegueName sender:sender];
    }
}

@end

NSString * const LTMainViewControllerShowAlternateSegueName = @"showAlternate";
