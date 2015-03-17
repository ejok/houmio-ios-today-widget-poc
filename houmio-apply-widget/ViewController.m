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
@end

@implementation ViewController

- (IBAction)getScenesButtonPressed:(id)sender {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.fi.nipe.HoumioApplyWidget"];
    [sharedDefaults setObject:self.siteKey.text forKey:@"siteKey"];
    [sharedDefaults synchronize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
