//
//  RootViewController.h
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import <UIKit/UIKit.h>
#import "MatchmakerViewController.h"
#import "GameViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RootViewController : UIViewController <MatchmakerDelegate, GameViewDelegate, FBFriendPickerDelegate, FBViewControllerDelegate>

@end
