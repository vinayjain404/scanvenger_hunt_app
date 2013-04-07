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
@end

@interface GameViewController : UIViewController <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,assign) id<GameViewDelegate> delegate;
@property(nonatomic,copy) NSString* imageURL;
@property(nonatomic,copy) NSString* player1ProfileID;
@property(nonatomic,copy) NSString* player2ProfileID;

- (id)initWithIndex:(NSUInteger)index;

@end
