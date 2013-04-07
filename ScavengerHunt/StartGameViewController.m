//
//  StartGameViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/7/13.
//
//

#import "StartGameViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"

#define SERVER @"http://ec2-23-21-38-14.compute-1.amazonaws.com:9000"

@interface StartGameViewController ()
{
    FBProfilePictureView* opponentImageView;
}
@end

@implementation StartGameViewController

@synthesize personName;

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
    // Do any additional setup after loading the view from its nib.
    
    opponentImageView = [[FBProfilePictureView alloc] initWithProfileID:self.opponentID pictureCropping:FBProfilePictureCroppingSquare];
    [opponentImageView setContentMode:UIViewContentModeScaleAspectFill];
    [opponentImageView setFrame:CGRectMake(50.0f, 100.0f, 50.0f, 50.0f)];
    [self.view addSubview:opponentImageView];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takePicture {
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
    
}

- (void)choosePhoto {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [[[appDelegate navController] navigationBar] setHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [[[appDelegate navController] navigationBar] setHidden:NO];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/create_game/", SERVER]]];
    [req setHTTPMethod:@"POST"];
    NSString *postData = [NSString stringWithFormat:@"player1_id=%@&player2_id=%@", [[appDelegate rootViewController] userID], self.opponentID];
    [req setHTTPBody: [postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* err) {
        if ((!err) && data && ([data length] > 0))
        {
            NSError* error;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
            [[appDelegate rootViewController] submitPhoto:
             [info objectForKey:UIImagePickerControllerOriginalImage] forGame: response[@"data"][@"game_id"]];
            [self performSelectorOnMainThread:@selector(hideView) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)hideView {    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [[[appDelegate rootViewController] navigationController] popToRootViewControllerAnimated:YES];
}

@end
