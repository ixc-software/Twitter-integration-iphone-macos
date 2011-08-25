//
//  twitterIntegrationAppDelegate.m
//  twitterIntegration
//
//  Created by Oleksii Vynogradov on 25.08.11.
//  Copyright 2011 IXC-USA Corp. All rights reserved.
//

#import "twitterIntegrationAppDelegate.h"

@implementation twitterIntegrationAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)startTwitterAuthForURL:(NSURL *)url
{
    // here u implement delegate method, which called when twitter is start:
    //[[twitterWebViewForPin mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    
    // here u open panel with web frame and field for pin and some buttons (cancel, authorize)
    //    [NSApp beginSheet:twitterAuthorization 
    //       modalForWindow:window
    //        modalDelegate:nil 
    //       didEndSelector:nil
    //          contextInfo:nil];
}

- (IBAction)finishTwitterAuthorization:(id)sender {
    // here u set pin property, which user put in field
    //twitterController.twitterPIN = [twitterPIN stringValue];
        
    // here u close open panel
    //[twitterAuthorization orderOut:sender];
    //[NSApp endSheet:twitterAuthorization];
    [twitterController finishAuthorization:self];
}

- (IBAction)startTwitterAuthorization:(id)sender {

    if (!twitterController) { 
            twitterController = [[TwitterUpdateDataController alloc] init];
            twitterController.delegate = self;
        }
        //[self getRequestToken:sender];
        [twitterController startAuthorization:self];
        
    
}


@end
