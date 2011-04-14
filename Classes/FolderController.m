//
//  FolderController.m
//  Untitled
//
//  Created by Jérôme Lebel on 05/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FolderController.h"
#import "UntitledAppDelegate.h"

@implementation FolderController

+ (id)alloc
{
    return [super alloc];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [super allocWithZone:zone];
}

static NSInteger compare(NSString *string1, NSString *string2, void *unused)
{
    return [string1 compare:string2 options:NSCaseInsensitiveSearch];
}

static NSMutableDictionary *getFileInfo(NSString *path, NSString *fileName)
{
    NSMutableDictionary *result;
    NSString *fullFilePath;
    BOOL directory;
    
    result = [[NSMutableDictionary alloc] init];
    fullFilePath = [path stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] fileExistsAtPath:fullFilePath isDirectory:&directory];
    [result setObject:fileName forKey:@"FileName"];
    if (directory) {
        [result setObject:[NSString stringWithFormat:@"%@ (%d)", fileName, [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullFilePath error:NULL] count]] forKey:@"DisplayName"];
        [result setObject:@"directory" forKey:@"FileType"];
    } else {
        [result setObject:fileName forKey:@"DisplayName"];
        [result setObject:@"file" forKey:@"FileType"];
    }
    [result setObject:fullFilePath forKey:@"FullPath"];
    return [result autorelease];
}

- (id)initWithParentController:(FolderController *)parent fileInfo:(NSDictionary *)info;
{
    self = [self init];
    if (self != NULL) {
        UITableView* tableView;
        
        parentController = parent;
        self.fileInfo = info;
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        self.view = tableView;
        [tableView release];
    }
    return self;
}

- (void)awakeFromNib
{
    self.fileInfo = getFileInfo(@"", @"/");
}

- (void)dealloc
{
    [fileInfo release];
    [contents release];
    [super dealloc];
}

- (NSString *)path
{
    NSString* result;
    
    if (parentController) {
        result = [[parentController path] stringByAppendingPathComponent:[fileInfo objectForKey:@"FileName"]];
    } else {
        result = [fileInfo objectForKey:@"FileName"];
    }
    return result;
}

- (NSDictionary *)fileInfo
{
    return fileInfo;
}

- (void)setFileInfo:(NSDictionary *)name
{
    if (![fileInfo isEqual:name]) {
        [fileInfo release];
        [contents release];
        fileInfo = [name mutableCopy];
        
        NSUInteger ii, count;
        NSString *path;
        
        path = [self path];
        contents = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL] mutableCopy];
        [contents sortUsingFunction:compare context:NULL];
        count = [contents count];
        for (ii = 0; ii < count; ii++) {
            [contents replaceObjectAtIndex:ii withObject:getFileInfo(path, [contents objectAtIndex:ii])];
        }
        self.title = [fileInfo objectForKey:@"FileName"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[(UITableView*)self.view reloadData];	// populate our table's data
	
	NSIndexPath *tableSelection = [(UITableView*)self.view indexPathForSelectedRow];
	[(UITableView*)self.view deselectRowAtIndexPath:tableSelection animated:NO];
    
    UntitledAppDelegate *appDelegate = (UntitledAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.savedLocation = [fileInfo objectForKey:@"FullPath"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if (cell == nil) {
        CGRect rect;
        
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = 0;
        rect.size.height = 0;
		cell = [[[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:@"UITableViewCell"] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
	cell.text = [[contents objectAtIndex:indexPath.row] objectForKey:@"DisplayName"];
	return cell;
}

- (FolderController *)nextControllerWithFileInfo:(NSDictionary *)info
{
    if (nextController == nil) {
        nextController = [[FolderController alloc] initWithParentController:self fileInfo:info];
    } else {
        nextController.fileInfo = info;
    }
    return nextController;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[contents objectAtIndex:indexPath.row] objectForKey:@"FileType"] isEqualToString:@"directory"]) {
        [[self navigationController] pushViewController:[self nextControllerWithFileInfo:[contents objectAtIndex:indexPath.row]] animated:YES];
    }
}

- (void)restoreLevel:(NSArray*)fileNames withIndex:(NSUInteger)index
{
    NSString *fileName;
    NSDictionary* info = NULL;
    
    fileName = [fileNames objectAtIndex:index];
    for (info in contents) {
        if ([[info objectForKey:@"FileName"] isEqualToString:fileName]) {
            break;
        }
    }
    
    if (info) {
        FolderController *next;
        
        next = [self nextControllerWithFileInfo:info];
		[[self navigationController] pushViewController:next animated:NO];
        index++;
        if (index < [fileNames count]) {
            [next restoreLevel:fileNames withIndex:index];
        }
    }
}

@end
