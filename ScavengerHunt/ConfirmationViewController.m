//
//  ConfirmationViewController.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "ConfirmationViewController.h"

@interface ConfirmationViewController ()
{
    CGRect _frame;
}
@end

@implementation ConfirmationViewController


- (id)initWithFrame:(CGRect) frame {
    self = [super init];
    if (self) {
        _frame = frame;
    }
    return self;
}

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
    [self.view setBackgroundColor:[UIColor redColor]];
    [self.view setFrame: _frame];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
