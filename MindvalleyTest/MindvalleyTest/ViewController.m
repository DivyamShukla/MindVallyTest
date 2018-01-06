//
//  ViewController.m
//  MindvalleyTest
//
//  Created by Divyam on 30/05/17.
//  Copyright © 2017 divyam. All rights reserved.
//

#import "ViewController.h"
#import "DownloadManager.h"
#import "MyTableViewCell.h"
#import "MBProgressHUD.h"
#import "User.h"

#define API_URL         @"http://pastebin.com/raw/wgkJgazE"



@interface ViewController (){
    MBProgressHUD *hud;
    NSMutableArray *arrayUser;
    
    NSMutableArray *arrayTemp ;
    
    NSInteger offset;
    NSInteger chunkSize;
    UIRefreshControl *refreshControl;
    BOOL isPullToRefresh;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    chunkSize = 5;
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview: hud];
    
    [hud show:YES];
    
    
    self.tableView_User.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView_User addSubview:refreshControl];
    isPullToRefresh = NO;
    
    [refreshControl addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
    [self reloadData];
    
    __weak ViewController *weakSelf = self;
    
    // setup bottom pull-to-refresh
    [self.tableView_User addInfiniteScrollingWithActionHandler:^{
        
        if(arrayUser && [arrayUser count]){
            [weakSelf loadMoreData];
        }else{
            [self.tableView_User.infiniteScrollingView stopAnimating];
        }
    }];
}


-(void)refreshList{
    isPullToRefresh = YES;
    
    [self reloadData];
}




-(void)reloadData{
    [[DownloadManager sharedManager] downloadFileForURL:API_URL completionBlock:^(BOOL success, NSError *error, id data) {
        
        [hud removeFromSuperview];
        [hud show:NO];
        
        if(isPullToRefresh){
            [refreshControl endRefreshing];
        }
        
        isPullToRefresh = NO;
        
        if(error){
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
                                          message:@"Unable to load data"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            return ;
        }
        
        
        NSError *e = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:(NSData *) data options: NSJSONReadingMutableContainers error: &e];
        
        if (!jsonArray) {
            NSLog(@"Error parsing JSON: %@", e);
        } else {
            
            arrayUser = [[NSMutableArray alloc] init];
            
            for (id dic in jsonArray){
                NSDictionary *userData = (NSDictionary *)dic;
                User *user = [[User alloc] init];
                user.userName = [[userData valueForKey:@"user"] valueForKey:@"username"];
                user.name = [[userData valueForKey:@"user"] valueForKey:@"name"];
                user.profilePic = [[[userData valueForKey:@"user"] valueForKey:@"profile_image"] valueForKey:@"small"];
                [arrayUser addObject:user];
                
                
            }
            
            
            if([arrayUser count]>chunkSize){
                arrayTemp = [[NSMutableArray alloc] init];
                for(int i=0;i<chunkSize;i++){
                    [arrayTemp addObject:[arrayUser objectAtIndex:i]];
                }
            }
            offset = [arrayTemp count];
            [self.tableView_User reloadData];
            
        }
        
    }];
}



-(void)loadMoreData{
    
    if(isPullToRefresh) // Pull to referesh already in progress
    {
        [self.tableView_User.infiniteScrollingView stopAnimating];
    }else{
        
        if(([arrayUser count]-1 > offset - 1 )){
            
             isPullToRefresh = NO;
            if([arrayUser count] - offset >= chunkSize ){
            
           
                
                for(NSInteger i=offset ; i<offset+chunkSize;i++)
                    [arrayTemp addObject:[arrayUser objectAtIndex:i]];
                
                
            }
            else{
                for(NSInteger i=offset ; i<[arrayUser count];i++)
                    [arrayTemp addObject:[arrayUser objectAtIndex:i]];
            }
            
            [self.tableView_User reloadData];
            
            offset = [arrayTemp count];
            
             [self.tableView_User.infiniteScrollingView stopAnimating];
        }
            else{
                [self.tableView_User.infiniteScrollingView stopAnimating];
                
            }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayTemp count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  MyTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell" forIndexPath:indexPath];
    
    User *user = [arrayTemp objectAtIndex:indexPath.row];
    
    cell.label_title.text = user.name;
    
    [[DownloadManager sharedManager] downloadFileForURL:user.profilePic completionBlock:^(BOOL success, NSError *error, id data) {
        
        UIImage *img = [UIImage imageWithData:(NSData *)data];
        [cell.imageView_Display setImage:img];
        
    }];
    
    
    
    return cell;
    
}


@end
