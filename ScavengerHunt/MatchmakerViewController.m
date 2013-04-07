//
//  MatchmakerViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "MatchmakerViewController.h"

@interface MatchmakerViewController ()

@end

@implementation MatchmakerViewController

@synthesize delegate;

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
    CGRect frame = CGRectMake(0.0f, 10.0f, 100.0f, 50.0f);
    [self.view setFrame:frame];
	// Do any additional setup after loading the view.
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f)];
    
    [startButton setBackgroundColor:[UIColor lightGrayColor]];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:startButton];
}

- (void)startPressed
{
    [delegate start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
