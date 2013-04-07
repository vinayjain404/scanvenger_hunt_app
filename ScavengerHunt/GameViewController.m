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

#define ANIMATION_TIME .35f

@interface GameViewController ()
{
    UIButton *backButton;
    UIButton *cameraButton;
    NSUInteger _index;
    UIImageView *imageView;
    UIImageView *nextImageView;
    UIImageView *opponentImageView;
    UIImageView *myImageView;
    UIImageView *previewImageView;
    
    ConfirmationViewController *confirmationViewController;
}
@end

@implementation GameViewController

@synthesize delegate, imageURL;

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
    [self.view setBackgroundColor:[UIColor mainBackgroundColor]];
    
    opponentImageView = [[UIImageView alloc] init];
    //[opponenPhotoView setImageWithURL:];
    [opponentImageView setContentMode:UIViewContentModeScaleAspectFit];
    [opponentImageView setBackgroundColor:[UIColor grayColor]];
    
    imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [imageView setImageWithURL:[NSURL URLWithString:self.imageURL]];
    
    nextImageView = [[UIImageView alloc] init];
    [nextImageView setContentMode:UIViewContentModeScaleAspectFit];
    //[nextImageView setImageWithURL:];
    [nextImageView setBackgroundColor:[UIColor grayColor]];
    
    myImageView = [[UIImageView alloc] init];
    [myImageView setContentMode:UIViewContentModeScaleAspectFit];
    //[myImageView setImageWithURL:];
    [myImageView setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:opponentImageView];
    [self.view addSubview:imageView];
    [self.view addSubview:nextImageView];
    [self.view addSubview:myImageView];
    [self minimize: NO];
	// Do any additional setup after loading the view.
}

- (void)minimize: (BOOL) animated
{
    CGRect frame = CGRectMake(0.0f, 10.0f + 60.0f * _index, 200.0f, 50.0f);
    
    void (^initBlock)() = ^(){
        [self.view setFrame:frame];
        [opponentImageView setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [imageView setFrame:CGRectMake(40.0f, 0.0f, 50.0f, 50.0f)];
        [nextImageView setFrame:CGRectMake(100.0f, 0.0f, 50.0f, 50.0f)];
        [myImageView setFrame:CGRectMake(160.0f, 0.0f, 30.0f, 30.0f)];
        [nextImageView setAlpha:1.0f];
        [myImageView setAlpha:1.0f];
        [previewImageView setAlpha: 0.0f];
    };
    
    if (animated) {
        [UIView animateWithDuration:ANIMATION_TIME animations:initBlock completion:^(BOOL finished) {
            [previewImageView setHidden:YES];
            [backButton setHidden:YES];
            [cameraButton setHidden:YES];
        }];
    } else {
        initBlock();
        [self.view setFrame:frame];
    }
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)maximize
{
    [delegate show: self];
    [backButton setHidden:NO];
    [cameraButton setHidden:NO];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
        [opponentImageView setFrame:CGRectMake(290.0f, 0.0f, 30.0f, 30.0f)];
        [imageView setFrame:[[UIScreen mainScreen] bounds]];
        [nextImageView setAlpha:0.0f];
        [myImageView setAlpha:0.0f];
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
        cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(50.0f, 420.0f, 100.0f, 40.0f)];
        [cameraButton setBackgroundColor:[UIColor blackColor]];
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
    /*
    if (!confirmationViewController) {
        confirmationViewController = [[ConfirmationViewController alloc] initWithFrame: self.view.frame];
    }
    [self.view addSubview:confirmationViewController.view];
    */
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
    
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
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
        [previewImageView setContentMode:UIViewContentModeScaleAspectFit];
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
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self previewImage: [info objectForKey:UIImagePickerControllerOriginalImage]];
}

@end
