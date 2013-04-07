//
//  RootViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "RootViewController.h"
#import "UIColor+Hunt.h"

#define SERVER @"http://ec2-23-21-38-14.compute-1.amazonaws.com:9000/"

@interface RootViewController ()
{
    MatchmakerViewController *matchmakerViewController;
    FBFriendPickerViewController *friendPickerController;
    
    NSMutableArray* games;
    NSString *accessType;
    NSString *accessToken;
    UIScrollView *scrollView;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setBackgroundColor:[UIColor mainBackgroundColor]];
    games = [[NSMutableArray alloc] init];
    
    matchmakerViewController = [[MatchmakerViewController alloc] init];
    [matchmakerViewController setDelegate:self];
    
    GameViewController *gameViewController = [[GameViewController alloc] init];
    [gameViewController setDelegate:self];
    [games addObject:gameViewController];
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:gameViewController.view];
    [scrollView addSubview:[matchmakerViewController view]];
    [scrollView setContentSize:CGSizeMake(320.0f, 1000.0f)];
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
            switch (state) {
                case FBSessionStateClosedLoginFailed:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:error.localizedDescription
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                    break;
                case FBSessionStateOpen:
                    // Get game list
                    break;
                default:
                    break;
            }
        }];
    }
}

/*
- (void)loadGames
{
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSString stringWithFormat:@"%@/list_games/%@", SERVER, facebookId]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* err) {
        if (([data length] > 0) && (!err))
        {
            NSError* error;
            NSString *logStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", logStr);
            [self performSelectorOnMainThread:@selector(setImages:) withObject:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] waitUntilDone:YES];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}
 */


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)start
{
    if (!friendPickerController) {
        friendPickerController = [[FBFriendPickerViewController alloc] init];
        [friendPickerController setTitle:@"Challenge a Friend"];
        [friendPickerController setAllowsMultipleSelection: NO];
        [friendPickerController setDelegate: self];
    }
    
    [friendPickerController loadData];
    [friendPickerController clearSelection];
    
    // iOS 5.0+ apps should use [UIViewController presentViewController:animated:completion:]
    // rather than this deprecated method, but we want our samples to run on iOS 4.x as well.
    [self presentViewController:friendPickerController animated:YES completion:NO];
    // Find users
}

- (void)show: (GameViewController*) gameViewController
{
    [gameViewController.view removeFromSuperview];
    [scrollView addSubview:gameViewController.view];
}

#pragma mark FB UI handlers

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
/*     NSMutableString *text = [[NSMutableString alloc] init];
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
   for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
    }
    [self fillTextBoxAndDismiss:text.length > 0 ? text : @"<None>"];
 */
    [friendPickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [friendPickerController dismissViewControllerAnimated:YES completion:nil];
//    [self fillTextBoxAndDismiss:@"<Cancelled>"];
    
}
/*
- (void)fillTextBoxAndDismiss:(NSString *)text {
    self.selectedFriendsView.text = text;
    
    [self dismissModalViewControllerAnimated:YES];
}
*/

@end
