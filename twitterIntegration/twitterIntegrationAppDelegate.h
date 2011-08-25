//
//  twitterIntegrationAppDelegate.h
//  twitterIntegration
//
//  Created by Oleksii Vynogradov on 25.08.11.
//  Copyright 2011 IXC-USA Corp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TwitterUpdateDataController.h"
@interface twitterIntegrationAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    TwitterUpdateDataController *twitterController;
}

@property (assign) IBOutlet NSWindow *window;

@end
