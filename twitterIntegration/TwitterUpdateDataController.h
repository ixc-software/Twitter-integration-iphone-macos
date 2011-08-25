//
//  TwitterUpdateController.h
//  snow
//
//  Created by Oleksii Vynogradov on 24.08.11.
//  Copyright 2011 IXC-USA Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "MGTwitterEngine.h"


@interface TwitterUpdateDataController : NSObject {
@private
    OAToken *accessToken;
    MGTwitterEngine *twitterEngine;
    NSString *twitterPIN;
    id delegate;
    BOOL isAuthorized;

}

@property (nonatomic,retain) NSString *twitterPIN;
@property (nonatomic,retain) id delegate;
@property (readwrite) BOOL isAuthorized;

- (IBAction)startAuthorization:(id)sender;
- (IBAction)finishAuthorization:(id)sender; 
- (void) postTwitterMessageWithText:(NSString *)text;


- (id)initWithDelegate:(id)delegateForInit;


@end
