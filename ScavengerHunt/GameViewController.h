//
//  GameViewController.h
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import <UIKit/UIKit.h>
@class GameViewController;

@protocol GameViewDelegate <NSObject>

@optional
- (void)show: (GameViewController*) gameViewController;
- (void)hide: (GameViewController*) gameViewController;
- (void)showCamera;
@end

@interface GameViewController : UIViewController <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,assign) id<GameViewDelegate> delegate;
@property(nonatomic,copy) NSString* imageURL;
@property(nonatomic,copy) NSString* opponentID;
@property(nonatomic,copy) NSString* gameID;

- (id)initWithIndex:(NSUInteger)index;

@end
