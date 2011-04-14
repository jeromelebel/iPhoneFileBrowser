//
//  FolderController.h
//  Untitled
//
//  Created by Jérôme Lebel on 05/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FolderController : UIViewController <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    FolderController                *parentController;
    FolderController                *nextController;
    NSDictionary                    *fileInfo;
    NSMutableArray                  *contents;
}

@property (nonatomic, retain) NSDictionary *fileInfo;
- (void)restoreLevel:(NSArray*)fileNames withIndex:(NSUInteger)index;

@end
