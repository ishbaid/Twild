//
//  BAIDViewController.m
//  Twext
//
//  Created by Ishdeep Baid on 2/8/14.
//  Copyright (c) 2014 BaidApps. All rights reserved.
//

#import "BAIDViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
@interface BAIDViewController ()

@property(strong, nonatomic)NSArray *arrray;

@end

@implementation BAIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self twitterTimeline];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Data Source Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Returns the number of rows for the table view using the array instance variable.
    
    return [_arrray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Creates each cell for the table view.
    
    static NSString *cellID =  @"CELLID" ;
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    // Creates an NSDictionary that holds the user's posts and then loads the data into each cell of the table view.
    
    NSDictionary *tweet = _arrray[indexPath.row];
    
    cell.textLabel.text = tweet[@"text"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // When a user selects a row this will deselect the row.
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)twitterTimeline{
    
    ACAccountStore *account = [[ACAccountStore alloc]init];
    //if you want to use facebook, change identifier to facebook
    ACAccountType *accounttype = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter
                                  ];
    [account requestAccessToAccountsWithType:accounttype options:nil completion:^(BOOL granted, NSError *error){
        
        if((granted = YES)){
            
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accounttype];
            if([arrayOfAccounts count]){
                
                //if multiple twitter accounts, last account is stored in NSArray
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                //how many tweets we want: 100 in this case
                [parameters setObject:@"100" forKey:@"count"];
                [parameters setObject:@"1" forKey:@"include_entities"];
                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:parameters ];
                
                posts.account = twitterAccount;
                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error){
                   
                    
                    self.arrray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error: &error];
                    
                    if(self.arrray.count != 0){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                           
                            [self.tableView reloadData];
                        });
                        
                        
                    }
                    
                }];
                
            }
            
            
        }
        else{
            
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }];

}

- (IBAction)tweetButton:(id)sender {
    
    NSArray *monty = @[@"Zoot/Dingo: And after the spanking, the oral sex! \nSir Galahad: Well, I suppose I could stay a bit longer.", @"Sir Lancelot: I thought your son was a girl.\nKing: That\'s understandable.", @"Black Knight: What are you going to do, bleed on me?", @"K: You only killed the bride's father. S: Well, I didn't mean to. K: Didn't mean to? You put your sword right through his head. S: Oh dear... is he all right?", @"French: Your motha was a hamster and your fatha smelled of hoozenberries!!!", @"Sir Bedevere: How do know so much about swallows?\nKing Arthur: Well, you have to know these things when you're a king, you know.", @"Old Man: WHAT is the airspeed velocity of an unladen swallow?King Arthur: What do you mean? African or European swallow?"];
    
    NSArray *hitch = @[@"Don't Panic", @"“This must be Thursday,' said Arthur to himself, sinking low over his beer. 'I never could get the hang of Thursdays.” ", @"“Ford... you're turning into a penguin. Stop it.” ", @"there's an infinite number of monkeys outside who want to talk to us about this script for Hamlet they've worked out.”", @"“Life,” said Marvin dolefully, “loathe it or ignore it, you can’t like it.” ", @"\"Is there any tea on this spaceship?\" he asked.” ", @"“The Ultimate Answer to Life, The Universe and Everything is...42!” ", @"Marvin: I've calculated your chance of survival, but I don't think you'll like it."];
    
    NSArray *montyHash = @[@"#MontyPython", @"#TheKnightsWhoSayNi"];

    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        NSString *tweet;
        NSUInteger randMovie = arc4random() % 2;
        if(randMovie){
         
            NSUInteger randomIndex = arc4random() % [hitch count];
            NSString *quote = [hitch objectAtIndex:randomIndex];
            NSString *hash =@" #HitchHikersGuide";
            tweet = [quote stringByAppendingString:hash];
            
        }else{
            
            NSUInteger randomIndex = arc4random() % [monty count];
            NSString *quote = [monty objectAtIndex:randomIndex];
            NSUInteger randomHash = arc4random() % 2;
            NSString *hash = [montyHash objectAtIndex:randomHash];
            tweet = [quote stringByAppendingString:hash];
            
        }
        
        
        [controller setInitialText:tweet];
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to send tweet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
@end
