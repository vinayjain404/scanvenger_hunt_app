//
//  RootViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "RootViewController.h"
#import "UIColor+Hunt.h"
#import "StartGameViewController.h"
#import "UIImage+Resize.h"
#import "Base64.h"

#define SERVER @"http://ec2-23-21-38-14.compute-1.amazonaws.com:9000"

@interface RootViewController ()
{
    FBFriendPickerViewController *friendPickerController;
    
    NSUInteger gameIndex;
    NSMutableArray* games;
    UIScrollView *scrollView;
    UIButton *newGame;
}
@end

@implementation RootViewController

@synthesize userID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        gameIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setBackgroundColor:[UIColor mainBackgroundColor]];
    games = [[NSMutableArray alloc] init];
    [[[self navigationController] navigationBar] setHidden:NO];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newGame)];
    [self.navigationItem setTitle:@"Ditto"];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    [self.view addSubview:scrollView];
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
                            self.userID = user[@"id"];
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
    NSString *url = [NSString stringWithFormat:@"%@/list_games/%@/", SERVER, self.userID];
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* err) {
        if (([data length] > 0) && (!err))
        {
            NSError* error;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *gamesArray = response[@"games"];
            
            if (gamesArray && ([gamesArray count] == 0)) {
                [self performSelectorOnMainThread:@selector(showTitle) withObject:nil waitUntilDone:NO];
            } else {
                for (NSDictionary* game in gamesArray) {
                    NSLog(@"%@", game);
                    [self performSelectorOnMainThread:@selector(addGame:) withObject:game waitUntilDone:YES];
                }
            }
        }
    }];
}

- (void)showTitle {
    newGame = [[UIButton alloc] initWithFrame:CGRectMake(30.0f, 50.0f, 250.0f, 220.0f)];
    [newGame setImage:[UIImage imageNamed:@"welcome"] forState:UIControlStateNormal];
    [newGame addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:newGame];
}

- (void)addGame: (NSDictionary*) game {
    NSString *opponentID = ([self.userID isEqualToString:game[@"player1_id"]]) ? game[@"player2_id"] : game[@"player1_id"];
    [self addGame:game[@"id"] withImageURL:game[@"img_url"] withOpponent:opponentID];
}

- (void)addGame: (NSString*) gameId withImageURL: (NSString*) url withOpponent: (NSString*) opponentID {
    GameViewController *gameViewController = [[GameViewController alloc] initWithIndex: gameIndex++];
    [gameViewController setImageURL:url];
    [gameViewController setGameID:gameId];
    [gameViewController setOpponentID:opponentID];
    [gameViewController setDelegate:self];
    [games addObject:gameViewController];

    [scrollView addSubview:gameViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newGame
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

-(void)submitPhoto: (UIImage*) image forGame: (NSString*) gameID {
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/upload_turn/", SERVER]]];
    [req setHTTPMethod:@"POST"];
    CGFloat w, h, ratio;
    w = image.size.width;
    h = image.size.height;
    ratio = w/h;
    if (ratio > 1.0f) {
        w = 400.0f;
        h = 400.0f / ratio;
    } else {
        w = 400.0f / ratio;
        h = 400.0f;
    }
    UIImage *resizedImage = [image scaleToSize:CGSizeMake(w, h)];
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, .8);
    NSString *base64Image = [imageData base64EncodedString];
    //NSLog(@"%@", base64Image);
    NSString *postData = [NSString stringWithFormat:@"{\"game_id\":\"%@\",\"player_id\":\"%@\",\"upload_image\":\"%@\"}", gameID, self.userID, base64Image];
    [req setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [req setHTTPBody: [postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* err) {
        if (([data length] > 0) && (!err))
        {
            NSString *logStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", logStr);
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
        }
    }];
}

-(void)matchPhoto: (UIImage*) image forGame: (NSString*) gameID {
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/match_turn/", SERVER]]];
    [req setHTTPMethod:@"POST"];
    CGFloat w, h, ratio;
    w = image.size.width;
    h = image.size.height;
    ratio = w/h;
    if (ratio > 1.0f) {
        w = 400.0f;
        h = 400.0f / ratio;
    } else {
        w = 400.0f / ratio;
        h = 400.0f;
    }
    UIImage *resizedImage = [image scaleToSize:CGSizeMake(w, h)];
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, .8);
    NSString *base64Image = [imageData base64EncodedString];
    //NSLog(@"%@", base64Image);
    NSString *postData = [NSString stringWithFormat:@"{\"game_id\":\"%@\",\"player_id\":\"%@\",\"match_image\":\"%@\"}", gameID, self.userID, base64Image];
    [req setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [req setHTTPBody: [postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* err) {
        if (([data length] > 0) && (!err))
        {
            NSString *logStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", logStr);
        }
    }];
}

- (void)reload {
    for (GameViewController *o in games) {
        [o.view removeFromSuperview];
    }
    [games removeAllObjects];
    [self loadGames];    
}

#pragma mark FB UI handlers

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    if (friendPickerController.selection.count == 1) {
        StartGameViewController *startGameViewController = [[StartGameViewController alloc] initWithNibName:@"StartGameViewController" bundle:nil];
        [startGameViewController setOpponentID: friendPickerController.selection[0][@"id"]];
        [self.navigationController pushViewController:startGameViewController animated:YES];
        /*
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
        }];*/
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
