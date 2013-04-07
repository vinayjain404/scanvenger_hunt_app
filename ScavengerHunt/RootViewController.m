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
}

- (void)show: (GameViewController*) gameViewController
{
    [gameViewController.view removeFromSuperview];
    [scrollView addSubview:gameViewController.view];
}


@end
