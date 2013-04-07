//
//  ClueViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "ClueViewController.h"

@interface ClueViewController ()

@end

@implementation ClueViewController

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
	// Do any additional setup after loading the view.
    UIButton *picButton = [[UIButton alloc] initWithFrame:CGRectMake(50.0f, 200.0f, 200.0f, 50.0f)];
    
    [picButton setTitle:@"Picture" forState:UIControlStateNormal];
    [picButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [picButton addTarget:self action:@selector(picPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:picButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)picPressed
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    
    imagePicker.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:      
     UIImagePickerControllerSourceTypeCamera];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

@end
