//
//  iCareViewController.m
//  iCareTest
//
//  Created by Kevin Lee on 13-5-16.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "iCareViewController.h"
#import "iCareCell.h"

@interface iCareViewController ()

@end

@implementation iCareViewController
@synthesize chosenIndexPath,chosenCellFrame;

NSArray *tableTitle;
NSArray *newsDescription;
NSArray *newsContents;

- (void)viewDidLoad
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"datalist" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    tableTitle = [dict objectForKey:@"newsTitle"];
    newsDescription = [dict objectForKey:@"newsDescription"];
    newsContents = [dict objectForKey:@"newsContents"];

    [super viewDidLoad];
    if (iPhone5) {
        appHeight = HeightFOR5;
    }
    else
    {
        appHeight = HeightFOR4;
    }
	// Do any additional setup after loading the view, typically from a nib.
    mtableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, appHeight) style:UITableViewStylePlain];
    mtableview.delegate = self;
    mtableview.dataSource = self;
    mtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    mtableview.backgroundColor = BackgroundColor;
    [self.view addSubview:mtableview];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 19;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (!expand)
    {       
        static NSString *cellIdentifier = @"cell";
        iCareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[iCareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.tag = indexPath.row;
        cell.label_title.text = [tableTitle objectAtIndex:indexPath.row];
        cell.label_source.text = [newsDescription objectAtIndex:indexPath.row];
        cell.tabledelegate = self;
        cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];

        if (expand) {
            cell.myScrollview.scrollEnabled = YES;
            cell.myScrollview.hidden = NO;
        }
        else
        {
            cell.myScrollview.scrollEnabled = NO;
            cell.myScrollview.hidden = YES;
        }
        
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    iCareCell * cell;
    if (expand)
    {
        expand = NO;
        cell = (iCareCell*)[tableView cellForRowAtIndexPath:chosenIndexPath];
        mtableview.scrollEnabled = YES;
        
//        cell.cellView.hidden = NO;
    }
    else
    {
        expand = YES;
        self.chosenIndexPath = indexPath;
        
        cell = (iCareCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.subIndex = indexPath;
        chosenCellFrame = cell.frame;
        mtableview.scrollEnabled = NO;
//        cell.cellView.hidden = YES;
    }
    
    [cell changeContent:expand];
    
    CGRect rect = [tableView convertRect:cell.frame toView:self.view];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    
    for ( UITableViewCell * subCell1 in tableView.subviews )
    {
        CGRect subCellFrame = [tableView convertRect:subCell1.frame toView:self.view];
        NSIndexPath * subIndex = [tableView indexPathForCell:subCell1];
        if ([subCell1 isKindOfClass:[iCareCell class]] || [subCell1 isKindOfClass:[UITableViewCell class]])
        {
            if (expand)
            {
                if ( subIndex.row == indexPath.row )
                {
                    self.chosenCellFrame = subCell1.frame;
                    subCell1.frame = CGRectMake(0, subCell1.frame.origin.y - rect.origin.y, 320, appHeight);
                }
                if (subIndex.row > indexPath.row)
                {
                    subCell1.frame = CGRectMake(0, appHeight - rect.origin.y - rect.size.height + subCell1.frame.origin.y, 320, subCellFrame.size.height);
                }
                if ( subIndex.row < indexPath.row )
                {
                    subCell1.frame = CGRectMake(0, subCell1.frame.origin.y - rect.origin.y, 320, subCell1.frame.size.height);
                }
                cell.myScrollview.scrollEnabled = YES;
            }
            else
            {
                CGRect chosenRect = [tableView convertRect:chosenCellFrame toView:self.view];
                if ( subIndex.row == chosenIndexPath.row )
                {
                    subCell1.frame = chosenCellFrame;
                }
                if (subIndex.row > chosenIndexPath.row)
                {
                    subCell1.frame = CGRectMake(0,  subCell1.frame.origin.y - (appHeight - chosenRect.origin.y - chosenRect.size.height), 320, subCell1.frame.size.height);
                }
                if ( subIndex.row < chosenIndexPath.row )
                {
                    subCell1.frame = CGRectMake(0, subCell1.frame.origin.y + chosenRect.origin.y, 320, subCell1.frame.size.height);
                }
                cell.myScrollview.scrollEnabled = NO;
            }
        }
    }
    [UIView commitAnimations];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

-(void)backTableView:(NSIndexPath *)indexpath
{
    [self tableView:mtableview didSelectRowAtIndexPath:indexpath];
}

@end
