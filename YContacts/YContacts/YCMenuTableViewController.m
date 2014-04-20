//
//  YCMenuTableViewController.m
//  YContacts
//
//  Created by Weiwei Shi on 4/20/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "YCMenuTableViewController.h"

@interface YCMenuTableViewController ()

@property (nonatomic, strong) NSMutableArray *menuArray;

@end

@implementation YCMenuTableViewController

@synthesize menuArray = _menuArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
	self.menuArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menuArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (aCell == nil)
	{
		aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aCell.detailTextLabel.numberOfLines = 0;
        
        // Display descriptions for the Edit Unknown Contact and Display and Edit Contact rows
        aCell.detailTextLabel.text = [[self.menuArray objectAtIndex:indexPath.section] valueForKey:@"description"];
        aCell.textLabel.text = [[self.menuArray objectAtIndex:indexPath.section] valueForKey:@"title"];
	}
	
	return aCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            // show scanner
            [self performSegueWithIdentifier:@"Show Scanner" sender:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
