//
//  BAIDViewController.h
//  Twext
//
//  Created by Ishdeep Baid on 2/8/14.
//  Copyright (c) 2014 BaidApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface BAIDViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tweetButton:(id)sender;

@end
