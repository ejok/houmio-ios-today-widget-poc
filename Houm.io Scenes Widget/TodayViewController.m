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
@property (weak, nonatomic) IBOutlet UITableView *sceneTable;
@property NSString *siteKey;
@property NSArray *scenes;
@end

const int ROW_HEIGHT = 40;

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.fi.nipe.HoumioApplyWidget"];
    self.siteKey = [sharedDefaults objectForKey:@"siteKey"];
    self.scenes = [sharedDefaults objectForKey:@"scenesForWidget"];
    long numberOfScenes = MIN([self.scenes count], 5);
    self.preferredContentSize = CGSizeMake(320, numberOfScenes * ROW_HEIGHT);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return MIN([self.scenes count], 5);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    id scene = [self.scenes objectAtIndex:indexPath.row];
    NSString *name = [scene valueForKey:@"name"];
    NSString *group = [scene valueForKey:@"group"];
    if ([group length] > 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ [%@]", name, group];
    } else {
        cell.textLabel.text = name;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id scene = [self.scenes objectAtIndex:indexPath.row];
    NSString *sceneId = [scene valueForKey:@"_id"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://houmi.herokuapp.com/api/site/%@/scene/%@/apply", self.siteKey, sceneId]]];
    [request setHTTPMethod:@"PUT"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
