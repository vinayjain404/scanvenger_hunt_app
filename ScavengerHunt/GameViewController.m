//
//  GameViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "GameViewController.h"
#import "UIColor+Hunt.h"
#import "ConfirmationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "RootViewController.h"

#define ANIMATION_TIME .35f

@interface GameViewController ()
{
    UIButton *cameraButton;
    NSUInteger _index;
    UIImageView *imageView;
    UIImageView *nextImageView;
    FBProfilePictureView *opponentImageView;
    UIImageView *previewImageView;
    UIView *innerCell;
    
    ConfirmationViewController *confirmationViewController;
}
@end

@implementation GameViewController

@synthesize delegate, imageURL, opponentID, gameID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        _index = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor cellColor]];
    
    opponentImageView = [[FBProfilePictureView alloc] initWithProfileID:self.opponentID pictureCropping:FBProfilePictureCroppingSquare];
    //[opponenPhotoView setImageWithURL:];
    [opponentImageView setContentMode:UIViewContentModeScaleAspectFill];
    [opponentImageView setBackgroundColor:[UIColor grayColor]];
    [[opponentImageView layer] setBorderColor: [UIColor whiteColor].CGColor];
    [[opponentImageView layer] setBorderWidth: 20.0f];
    
    imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView setBackgroundColor:[UIColor blackColor]];
    //[imageView setImageWithURL:[NSURL URLWithString:self.imageURL]];
    [imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]]];
    [[imageView layer] setBorderColor: [UIColor whiteColor].CGColor];
    [[imageView layer] setBorderWidth: 5.0f];
    
    nextImageView = [[UIImageView alloc] init];
    [nextImageView setContentMode:UIViewContentModeScaleAspectFill];
    [nextImageView setImage:[UIImage imageNamed:@"camera"]];
    [nextImageView setBackgroundColor:[UIColor lightGrayColor]];
    [nextImageView setClipsToBounds:YES];
    [[nextImageView layer] setBorderColor: [UIColor whiteColor].CGColor];
    [[nextImageView layer] setBorderWidth: 5.0f];
    
    [self.view addSubview:imageView];
    [self.view addSubview:opponentImageView];
    [self.view addSubview:nextImageView];
    [self.view.layer setShadowOffset:CGSizeMake(0.0f, 6.0f)];
    [self.view.layer setShadowColor:[UIColor grayColor].CGColor];
    [self.view.layer setShadowRadius:1.0f];
    [self minimize: NO];
	// Do any additional setup after loading the view.
}

- (void)minimize: (BOOL) animated
{
    CGRect frame = CGRectMake(10.0f, 14.0f + 165.0f * _index, 300.0f, 150.0f);
    
    void (^initBlock)() = ^(){
        [self.view setFrame:frame];
        [opponentImageView setFrame:CGRectMake(15.0f, 34.0f, 90.0f, 90.0f)];
        [imageView setFrame:CGRectMake(105.0f, 34.0f, 90.0f, 90.0f)];
        [nextImageView setFrame:CGRectMake(195.0f, 34.0f, 90.0f, 90.0f)];
        [nextImageView setAlpha:1.0f];
        [previewImageView setAlpha: 0.0f];
    };
    
    if (animated) {
        [UIView animateWithDuration:ANIMATION_TIME animations:initBlock completion:^(BOOL finished) {
            [previewImageView setHidden:YES];
            [cameraButton setHidden:YES];
        }];
    } else {
        initBlock();
        [self.view setFrame:frame];
    }
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)minimizeAnimated {
    [self minimize: YES];
}

- (void)maximize
{
    [delegate show: self];
    [cameraButton setHidden:NO];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
        [opponentImageView setFrame:CGRectMake(260.0f, 0.0f, 60.0f, 60.0f)];
        [imageView setFrame:[[UIScreen mainScreen] bounds]];
        [nextImageView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self showNavigation];
    }];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(minimizeAnimated)];
    [[[appDelegate rootViewController] navigationItem] setLeftBarButtonItem:backBarButton];
    
}

- (void)showNavigation
{
    if (!cameraButton) {
        cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 440.0f, 83.0f, 64.0f)];
        [cameraButton setImage:[UIImage imageNamed:@"btn_mid_camera"] forState:UIControlStateNormal];
        [cameraButton addTarget: self action: @selector(cameraPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cameraButton setAlpha: 0.0f];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [cameraButton setAlpha: 1.0f];
    }];
    
    [self.view addSubview:cameraButton];
}

- (void)hideNavigation
{
    [cameraButton removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cameraPressed
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [[[appDelegate navController] navigationBar] setHidden:YES];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes =
        [UIImagePickerController availableMediaTypesForSourceType:
         UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [[appDelegate rootViewController] presentViewController:imagePicker animated:YES completion:nil];
    
    [imagePicker setDelegate:self];
//    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)backPressed
{
    [self minimize: YES];
    [self hideNavigation];
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view removeGestureRecognizer:gestureRecognizer];
    [self maximize];
}

- (void)previewImage:(UIImage*)image {
    if (!previewImageView) {
        previewImageView = [[UIImageView alloc] initWithImage:image];
        [previewImageView setContentMode:UIViewContentModeScaleAspectFill];
        [previewImageView setClipsToBounds:YES];
        [previewImageView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:previewImageView];
    } else {
        [previewImageView setImage:image];
    }
    [previewImageView setFrame:CGRectMake(200.0f, 500.0f, 0.0f, 0.0f)];
    [previewImageView setAlpha: 0.0f];
    [previewImageView setHidden:NO];
    [UIView animateWithDuration:.5f animations:^{
        [previewImageView setAlpha: 1.0f];
        [previewImageView setFrame:CGRectMake(0.0f, 200.0f, 320.0f, 200.0f)];
        [imageView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
    }];
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [[appDelegate rootViewController] matchPhoto:image forGame: self.gameID];
    //UIProgressView *progress = [[UIProgressView alloc] initWithFrame: cameraButton.frame];
    //[self.view addSubview:progress];
    [self hideNavigation];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [[[appDelegate navController] navigationBar] setHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self previewImage: [info objectForKey:UIImagePickerControllerOriginalImage]];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [[[appDelegate navController] navigationBar] setHidden:NO];
}

@end
