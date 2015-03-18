//
//  TodayViewController.m
//  Houm.io Scenes Widget
//
//  Created by Eeli (Koti) on 11/03/15.
//  Copyright (c) 2015 Eeli Jokinen. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIButton *sceneRow;
@property NSString *siteKey;
@property NSArray *scenes;
@end

@implementation TodayViewController

- (IBAction)applyScene:(id)sender {
    id scene = [self.scenes objectAtIndex:0];
    NSString *sceneId = [scene valueForKey:@"_id"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://houmi.herokuapp.com/api/site/%@/scene/%@/apply", self.siteKey, sceneId]]];
    [request setHTTPMethod:@"PUT"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 60);
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.fi.nipe.HoumioApplyWidget"];
    self.siteKey = [sharedDefaults objectForKey:@"siteKey"];
    self.scenes = [sharedDefaults objectForKey:@"scenesForWidget"];
    id scene = [self.scenes objectAtIndex:0];
    NSString *sceneName = [scene valueForKey:@"name"];
    [self.sceneRow setTitle:sceneName forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
