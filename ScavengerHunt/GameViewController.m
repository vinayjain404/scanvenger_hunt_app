//
//  GameViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "GameViewController.h"

#define ANIMATION_TIME .35f

@interface GameViewController ()
{
    UIButton *backButton;
    UIButton *cameraButton;
}
@end

@implementation GameViewController

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
    [self minimize: NO];
    [self.view setBackgroundColor:[UIColor redColor]];
	// Do any additional setup after loading the view.
}

- (void)minimize: (BOOL) animated
{
    if (animated) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            [self.view setFrame:CGRectMake(50.0f, 50.0f, 50.0f, 50.0f)];
        }];
    } else {
        [self.view setFrame:CGRectMake(50.0f, 50.0f, 50.0f, 50.0f)];
    }
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)maximize
{
    [delegate show: self];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
    } completion:^(BOOL finished) {
        [self showNavigation];
    }];
}

- (void)showNavigation
{
    if (!backButton) {
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 40.0f)];
        [backButton setTitle: @"Back" forState: UIControlStateNormal];
        [backButton addTarget: self action: @selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!cameraButton) {
        cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(50.0f, 300.0f, 100.0f, 40.0f)];
        [cameraButton setTitle: @"Camera" forState: UIControlStateNormal];
        [cameraButton addTarget: self action: @selector(cameraPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cameraButton setAlpha: 0.0f];
    [backButton setAlpha: 0.0f];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [cameraButton setAlpha: 1.0f];
        [backButton setAlpha: 1.0f];
    }];
    
    [self.view addSubview:backButton];
    [self.view addSubview:cameraButton];
}

- (void)hideNavigation
{
    [backButton removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cameraPressed
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)backPressed
{
    [self minimize: YES];
    [self hideNavigation];
}

- (void)tapped: (UIGestureRecognizer *)gestureRecognizer
{
    [self.view removeGestureRecognizer:gestureRecognizer];
    [self maximize];
}

@end
