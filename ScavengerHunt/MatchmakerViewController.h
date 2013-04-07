//
//  MatchmakerViewController.h
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import <UIKit/UIKit.h>

@protocol MatchmakerDelegate <NSObject>

@optional
- (void)start;
@end

@interface MatchmakerViewController : UIViewController

@property(nonatomic,assign) id<MatchmakerDelegate> delegate;

@end
