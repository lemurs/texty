
@class LTSettingsViewController;

@protocol LTSettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(LTSettingsViewController *)controller;
@end

@interface LTSettingsViewController : UIViewController

@property (weak) id <LTSettingsViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
