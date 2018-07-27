//
//  AppDelegate.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/16/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "AppDelegate.h"
#import "SpotifySingleton.h"
#import "BackendAPIManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) SPTAuth *auth;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) UIViewController *authViewController;

@end

@implementation AppDelegate

//opens the default browser and presents the user with the Spotify authorization dialog, before calling back into the application.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.auth = [SPTAuth defaultInstance];
    self.player = [SPTAudioStreamingController sharedInstance];
    // The client ID you got from the developer site
    self.auth.clientID = @"ec30b68d8b244721a5571f71a519f42c";
    // The redirect URL as you entered it at the developer site
    self.auth.redirectURL = [NSURL URLWithString:@"kool-kits-login://callback"];
    // Setting the `sessionUserDefaultsKey` enables SPTAuth to automatically store the session object for future use.
    self.auth.sessionUserDefaultsKey = @"current session";
    // Set the scopes you need the user to authorize. `SPTAuthStreamingScope` is required for playing audio.
    self.auth.requestedScopes = @[SPTAuthStreamingScope,SPTAuthPlaylistReadPrivateScope,SPTAuthPlaylistModifyPublicScope];
    
    // Become the streaming controller delegate
    self.player.delegate = self;
    
    // Start up the streaming controller.
    NSError *audioStreamingInitError;
    if (![self.player startWithClientId:self.auth.clientID error:&audioStreamingInitError]) {
        NSLog(@"There was a problem starting the Spotify SDK: %@", audioStreamingInitError.description);
    }
    
    // Start authenticating when the app is finished launching
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAuthenticationFlow];
    });
    
    return YES;
}

//checks if the token is. If it is not, this procedure opens a request in a SFSafariViewController.
- (void)startAuthenticationFlow
{
    // Check if we could use the access token we already have
    if ([self.auth.session isValid]) {
        // Use it to log in
        [self.player loginWithAccessToken:self.auth.session.accessToken];
    }
    // Get the URL to the Spotify authorization portal
    NSURL *authURL = [self.auth spotifyWebAuthenticationURL];
    // Present in a SafariViewController
    self.authViewController = [[SFSafariViewController alloc] initWithURL:authURL];
    [self.window.rootViewController presentViewController:self.authViewController animated:YES completion:nil];
}

/*When the user has finished the authorization process, the authorization service closes the SFSafariViewController and triggers this method. In the method SPTAuth checks if the provided URL is a Spotify authentication callback. If so, to get an access token, the procedure calls the token swap service (see the Readme in the download package). When the access token is generated, this procedure calls -loginWithAccessToken: to login the player.
 */
// Handle auth callback
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    // If the incoming url is what we expect we handle it
    if ([self.auth canHandleURL:url]) {
        // Close the authentication window
        [self.authViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        self.authViewController = nil;
        // Parse the incoming url to a session object
        [self.auth handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (session) {
                // login to the player
                [self.player loginWithAccessToken:self.auth.session.accessToken];
                NSLog(@"ACCESS TOKEN: ");
                NSLog(@"%@", self.auth.session.accessToken);
                
                SpotifySingleton *spotifySingleton = [SpotifySingleton getInstance];
                [spotifySingleton setPlayer:self.player];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.auth.session.canonicalUsername forKey:@"username"];
                [defaults setObject:self.auth.session.accessToken forKey:@"accessToken"];
                
                [[BackendAPIManager shared] touchUser:self.auth.session.canonicalUsername withCompletion:^(UNIHTTPJsonResponse *a, NSError *aa) {
                    NSLog(@"%@", [BackendAPIManager shared].currentUser);
                }];
            }
        }];
        
        return YES;
    }
    return NO;
}

@end
