//
//  TwitterUpdateController.m
//  snow
//
//  Created by Oleksii Vynogradov on 24.08.11.
//  Copyright 2011 IXC-USA Corp. All rights reserved.
//
#import "OAuthConsumer.h"
#import "MGTwitterEngine.h"


#import "TwitterUpdateDataController.h"

#define kOAuthConsumerKey				@"xxxxxxxxxxx"		//REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret			@"yyyyyyyyyyyy"		//REPLACE With 


@implementation TwitterUpdateDataController

@synthesize delegate,twitterPIN,isAuthorized;


- (id)init
{
    self = [super init];
    if (self) {
        isAuthorized = NO;
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithDelegate:(id)delegateForInit;
{
    self = [super init];
    if (self) {
        isAuthorized = NO;
        // Initialization code here.
        self.delegate = delegateForInit;
    }
    
    return self;

}


- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark request token block (twitter methods)


- (IBAction) getRequestToken:(id)sender
{
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kOAuthConsumerKey
													secret:kOAuthConsumerSecret];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:consumer
																	  token:nil
																	  realm:nil
														  signatureProvider:nil];
	
	[request setHTTPMethod:@"POST"];
	
    NSLog(@"Getting request token...");
	
	[fetcher fetchDataWithRequest:request 
						 delegate:self
				didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];	
    [consumer release];
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data 
													   encoding:NSUTF8StringEncoding];
		accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [responseBody release];
		
		NSLog(@"Got request token. Redirecting to twitter auth page...");
		
		NSString *address = [NSString stringWithFormat:
							 @"https://api.twitter.com/oauth/authorize?oauth_token=%@",
							 accessToken.key];
		
		NSURL *url = [NSURL URLWithString:address];
    
        // delegate open panel for autorization and input pin (don't forget set pin property!!!)
        if (delegate != nil && [delegate respondsToSelector:@selector(startTwitterAuthForURL:)]) {
            [delegate performSelector:@selector(startTwitterAuthForURL:) withObject:url];
        }

	}
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
    NSLog(@"Getting request token failed: %@", [error localizedDescription]);
}


#pragma mark -
#pragma mark access token block (twitter methods)


- (IBAction) getAccessToken:(id)sender
{
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kOAuthConsumerKey
													secret:kOAuthConsumerSecret];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    OAToken *accessTokenLocal = accessToken;
    
	[accessTokenLocal setVerifier:twitterPIN];
	
    NSLog(@"Using PIN %@", [accessTokenLocal verifier]);
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:consumer
																	  token:accessToken
																	  realm:nil
														  signatureProvider:nil];
    [consumer release];
	
	[request setHTTPMethod:@"POST"];
	
    
    NSLog(@"Getting access token...");
	
	[fetcher fetchDataWithRequest:request 
						 delegate:self
				didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
	[request release];

    
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [responseBody release];
        
		NSLog(@"Got access token. Ready to use Twitter API.");
        isAuthorized = YES;
	}
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"Getting access token failed: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark working with data (twitter methods)


- (void) refreshTweets {
    [twitterEngine getHomeTimelineSinceID:0 startingAtPage:0 count:20];
}

-(void) postTwitterMessageWithText:(NSString *)text;
{
    dispatch_async(dispatch_get_main_queue(), ^(void) { 
        if (!twitterEngine) twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
        [twitterEngine setUsesSecureConnection:NO];
        [twitterEngine setConsumerKey:kOAuthConsumerKey secret:kOAuthConsumerSecret];
        
        [twitterEngine setAccessToken:accessToken];
        // check if it need:
        [self refreshTweets];
        [twitterEngine sendUpdate:text];
    });
    
}

#pragma mark -
#pragma mark apiTicket block (twitter methods)


- (void) apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Got home timeline. Length: %@.", [NSNumber numberWithUnsignedInteger:[responseBody length]]);
            NSLog(@"Body:\n%@", responseBody);
        [responseBody release];
        
	}
}

- (void) apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"Getting home timeline failed: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark twitter  authorization flow

// authorize login/pass
- (IBAction)startAuthorization:(id)sender ;
{
    [self getRequestToken:sender];
}
// put inserted pin and authozied final
- (IBAction)finishAuthorization:(id)sender; 
{
    [self getAccessToken:sender];
}

@end
