//
//  ViewController.h
//  Search
//
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

typedef enum{
    
    SortDescrptionBirthDay,
    SortDescrptionFirstName,
    SortDescrptionLastName
    
} SortDescrption;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;



- (IBAction)actionValueChangeSigmentedControl:(UISegmentedControl *)sender;

@end
