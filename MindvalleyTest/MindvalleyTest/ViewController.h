//
//  ViewController.h
//  MindvalleyTest
//
//  Created by Divyam on 30/05/17.
//  Copyright © 2017 divyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"


@interface ViewController : UIViewController<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , weak) IBOutlet UITableView *tableView_User;

@end

