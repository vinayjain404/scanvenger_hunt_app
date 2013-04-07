//
//  RootViewController.h
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RootViewController : UIViewController <GameViewDelegate, FBFriendPickerDelegate, FBViewControllerDelegate>

-(void)submitPhoto: (UIImage*) image forGame: (NSString*) gameID;
-(void)matchPhoto: (UIImage*) image forGame: (NSString*) gameID;

@property (nonatomic, copy) NSString* userID;

@end
