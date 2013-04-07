//
//  RootViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "RootViewController.h"
#import "UIColor+Hunt.h"

#define SERVER @"http://ec2-23-21-38-14.compute-1.amazonaws.com:9000"

@interface RootViewController ()
{
    MatchmakerViewController *matchmakerViewController;
    FBFriendPickerViewController *friendPickerController;
    
    NSUInteger gameIndex;
    NSMutableArray* games;
    NSString *userID;
    UIScrollView *scrollView;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        gameIndex = 1;
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
    
    [self.view addSubview:scrollView];
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
                    // TODO: Show login error.
                }
                    break;
                case FBSessionStateOpen:
                {
                    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error) {
                        
                        if (!error) {
                            userID = user[@"id"];
                            // Load games
                            [self loadGames];
                        }
                    }];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

- (void)loadGames
{
    NSString *url = [NSString stringWithFormat:@"%@/list_games/%@/", SERVER, userID];
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* err) {
        if (([data length] > 0) && (!err))
        {
            NSError* error;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *gamesArray = response[@"games"];
            for (NSDictionary* game in gamesArray) {
                NSLog(@"%@", game);
                [self performSelectorOnMainThread:@selector(addGame:) withObject:game waitUntilDone:NO];
            }
        }
    }];
}

- (void)addGame: (NSDictionary*) game {
    NSString *opponentID = ([userID isEqualToString:game[@"player1_id"]]) ? game[@"player2_id"] : game[@"player1_id"];
    [self addGame:game[@"id"] withImageURL:game[@"img_url"] withOpponent:opponentID];
}

- (void)addGame: (NSString*) gameId withImageURL: (NSString*) url withOpponent: (NSString*) opponentID {
    GameViewController *gameViewController = [[GameViewController alloc] initWithIndex: gameIndex++];
    [gameViewController setImageURL:url];
    [gameViewController setOpponentID:opponentID];
    [gameViewController setDelegate:self];
    [games addObject:gameViewController];
    [scrollView addSubview:gameViewController.view];
    [self.view setNeedsLayout];
}

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
        [friendPickerController setItemPicturesEnabled: YES];
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
    if (friendPickerController.selection.count == 1) {
        NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/create_game/", SERVER]]];
        [req setHTTPMethod:@"POST"];
        NSString *postData = [NSString stringWithFormat:@"player1_id=%@&player2_id=%@", userID, friendPickerController.selection[0][@"id"]];
        [req setHTTPBody: [postData  dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* err) {
            if (([data length] > 0) && (!err))
            {
                NSString *logStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", logStr);
                //           [self performSelectorOnMainThread:@selector(setImages:) withObject:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] waitUntilDone:YES];
                // Add game and start it using gameId
            }
        }];
    }
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
