//
//  ViewController.m
//  houmio-apply-widget
//
//  Created by Eeli (Koti) on 11/03/15.
//  Copyright (c) 2015 Eeli Jokinen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *siteKey;
@property NSUserDefaults *sharedDefaults;
@end

@implementation ViewController

- (IBAction)getScenesButtonPressed:(id)sender {
    [self.sharedDefaults setObject:self.siteKey.text forKey:@"siteKey"];
    [self.sharedDefaults synchronize];
    [self loadScenes:self];
}

- (NSURLConnection *)loadScenes: (NSObject *) delegate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://houmi.herokuapp.com/api/site/" stringByAppendingString:self.siteKey.text]]];
    [request setHTTPMethod:@"GET"];
    return [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}

-  (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    NSError *error;
    NSDictionary *site = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];

    NSArray *scenes = [site valueForKey:@"scenes"];

    [self.sharedDefaults setObject:scenes forKey:@"scenesForWidget"];
}

- (void)showLoadingError {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Unable to fetch scenes. Check the site key!"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;

    if ([httpResponse statusCode] != 200) {
        [self showLoadingError];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self showLoadingError];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.fi.nipe.HoumioApplyWidget"];
    self.siteKey.text = [self.sharedDefaults objectForKey:@"siteKey"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
