//
//  FBAppDelegate.h
//  Untitled
//
//  Created by Jérôme Lebel on 29/01/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface FBAppDelegate : NSObject <UIApplicationDelegate>
{
    IBOutlet UIWindow                   *window;
    IBOutlet UINavigationController     *navigationController;
    NSString                            *savedLocation;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) NSString *savedLocation;

@end

