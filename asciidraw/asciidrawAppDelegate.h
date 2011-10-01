//
//  asciidrawAppDelegate.h
//  asciidraw
//
//  Created by Martin Kleppmann on 01/10/2011.
//  Copyright 2011 Rapportive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class asciidrawViewController;

@interface asciidrawAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet asciidrawViewController *viewController;

@end
