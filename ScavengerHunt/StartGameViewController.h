//
//  StartGameViewController.h
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/7/13.
//
//

#import <UIKit/UIKit.h>

@interface StartGameViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(IBAction) takePicture;
-(IBAction) choosePhoto;

@property (nonatomic, weak) IBOutlet UILabel *personName;
@property (nonatomic, copy) NSString *opponentID;

@end
