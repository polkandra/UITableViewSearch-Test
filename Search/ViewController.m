//
//  ViewController.m
//  Search
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.

//

#import "ViewController.h"
#import "Student.h"
#import "Section.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *studentHeap;
@property (strong, nonatomic) NSMutableArray *sectionHeap;
@property (strong, nonatomic) NSMutableArray *sortDescriptionHeap;
@property (strong, nonatomic) NSInvocationOperation *sortOperation;

@property (strong, nonatomic) UIColor *myColorBlack;
@property (strong, nonatomic) UIColor *myColorGreen;
@property (strong, nonatomic) UIColor *myColorLightGray;
@property (strong, nonatomic) UIColor *myColorGray;
@property (strong, nonatomic) UIColor *myColorWhite;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.studentHeap = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5000; i++) {
        
        Student *anyStudent = [[Student alloc] init];
        [self.studentHeap addObject:anyStudent];
    }
    
    NSSortDescriptor *firstName = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastName = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSSortDescriptor *birthDay = [[NSSortDescriptor alloc] initWithKey:@"birthDay" ascending:YES];
    self.sortDescriptionHeap = [[NSMutableArray alloc] initWithObjects: firstName, lastName, birthDay, nil];
    self.sectionHeap = [[NSMutableArray alloc] init];
    
    self.sortOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                              selector:@selector(sortByMonthInBackground)
                                                                object:nil];
    [self.sortOperation start];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;

    self.myColorBlack = [UIColor colorWithRed:39.f / 255.f
                                        green:39.f / 255.f
                                         blue:39.f / 255.f alpha:1.0];
    
    self.myColorGreen = [UIColor colorWithRed:176.f / 255.f
                                       green:191.f / 255.f
                                        blue:90.f / 255.f alpha:1.0];
    
    self.myColorLightGray = [UIColor colorWithRed:166.f / 255.f
                                            green:166.f / 255.f
                                             blue:166.f / 255.f alpha:1.0];
    
    self.myColorGray = [UIColor colorWithRed:91.f / 255.f
                                       green:91.f / 255.f
                                        blue:91.f / 255.f alpha:1.0];
    
    self.myColorWhite = [UIColor colorWithRed:244.f / 255.f
                                        green:244.f / 255.f
                                         blue:244.f / 255.f alpha:1.0];
    
    self.tableView.sectionIndexColor = self.myColorGreen;
    self.tableView.backgroundColor = self.myColorWhite;
    self.searchBar.tintColor = self.myColorGreen;

}

- (void) sortByMonthInBackground {
    
     self.studentHeap = [self sortStudentByBirthDayMonth:self.studentHeap];
     self.sectionHeap = [self generateSectionFromBirthDayMonth:self.studentHeap];
    
    __weak ViewController *wiakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [wiakSelf.tableView reloadData];
        
    });
}

- (void) sortByNamesInBackground {
    
    [self.studentHeap sortUsingDescriptors:self.sortDescriptionHeap];
    self.sectionHeap = [self generateSectionFromNames:self.studentHeap];
    
    __weak ViewController *wiakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [wiakSelf.tableView reloadData];
        
    });
}

- (void) sortByFamalysInBackground {
    
    NSArray *sortDescriptor = [[NSArray alloc] initWithObjects:
                               [self.sortDescriptionHeap objectAtIndex:1],
                               [self.sortDescriptionHeap objectAtIndex:2],
                               [self.sortDescriptionHeap objectAtIndex:0], nil];
    
    [self.studentHeap sortUsingDescriptors:sortDescriptor];
    self.sectionHeap = [self generateSectionFromFamalys:self.studentHeap];
    [self.tableView reloadData];
    
    __weak ViewController *wiakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [wiakSelf.tableView reloadData];
        
    });
}

- (NSMutableArray *) sortStudentByBirthDayMonth : (NSMutableArray *) students {
   
    [students sortUsingComparator:^NSComparisonResult(Student *obj1, Student *obj2) {
        
        
        if ([obj1 getBirthDayMonth] < [obj2 getBirthDayMonth]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else if ([obj1 getBirthDayMonth] > [obj2 getBirthDayMonth]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else return (NSComparisonResult)NSOrderedSame;
    }];
    
    return students;
}

#pragma mark - generate section

- (NSMutableArray *) generateSectionFromBirthDayMonth: (NSMutableArray *) array{
    
    NSMutableArray *sectionArray = [NSMutableArray array];
    NSString *currentMonth = nil;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM"];
    
    for(Student *anyStudent in array) {
        
        NSString *firstMonth = [dateFormat stringFromDate:anyStudent.birthDay];
        Section *section = nil;
        
        if(![currentMonth isEqualToString:firstMonth]) {
            
            section = [[Section alloc] init];
            section.sectionName = firstMonth;
            section.sectionObjectsArray = [NSMutableArray array];
            currentMonth = firstMonth;
            [sectionArray addObject:section];
            
        } else {
            
            section = [sectionArray lastObject];
        }
        
        [section.sectionObjectsArray addObject:anyStudent];
    }
    
    for(Section *anySection in sectionArray) {
        
        [anySection sortByNameAndFamaly];
    }
    
    return sectionArray;
}

- (NSMutableArray *) generateSectionFromNames: (NSMutableArray *) array{
    
    NSMutableArray *sectionArray = [NSMutableArray array];
    NSString *currentLetter = nil;
    
    for(Student *anyStudent in array) {
  
        NSString *firstLetter = [anyStudent.firstName substringToIndex:1];
        Section *section = nil;
        
        if(![currentLetter isEqualToString:firstLetter]) {
            
            section = [[Section alloc] init];
            section.sectionName = firstLetter;
            section.sectionObjectsArray = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionArray addObject:section];
            
        } else {
            
            section = [sectionArray lastObject];
        }
        
        [section.sectionObjectsArray addObject:anyStudent];
    }
    return sectionArray;
}

- (NSMutableArray *) generateSectionFromFamalys: (NSMutableArray *) array{
    
    NSMutableArray *sectionArray = [NSMutableArray array];
    NSString *currentLetter = nil;
    
    for(Student *anyStudent in array) {
        
        NSString *firstLetter = [anyStudent.lastName substringToIndex:1];
        Section *section = nil;
        
        if(![currentLetter isEqualToString:firstLetter]) {
            
            section = [[Section alloc] init];
            section.sectionName = firstLetter;
            section.sectionObjectsArray = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionArray addObject:section];
            
        } else {
            
            section = [sectionArray lastObject];
        }
        
        [section.sectionObjectsArray addObject:anyStudent];
    }
    return sectionArray;
}

#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for(Section *anySection in self.sectionHeap) {
        
        [indexArray addObject:anySection.sectionName];
    }
    return indexArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionHeap count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.sectionHeap objectAtIndex:section] sectionName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Section *anySection = [self.sectionHeap objectAtIndex:section];
    return [anySection.sectionObjectsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"AddCell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
        cell.imageView.image = [UIImage imageNamed:@"student.png"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd.MM.yy"];
    }
    
    Section *anySection = [self.sectionHeap objectAtIndex:indexPath.section];
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                          [[anySection.sectionObjectsArray objectAtIndex:indexPath.row] firstName],
                          [[anySection.sectionObjectsArray objectAtIndex:indexPath.row] lastName]];
 
    cell.textLabel.text = fullName;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yy"];
    cell.detailTextLabel.text =[dateFormat stringFromDate:[[anySection.sectionObjectsArray objectAtIndex:indexPath.row] birthDay]] ;

    if([self.searchBar.text length]){
        
        Student *anyStudent = [anySection.sectionObjectsArray objectAtIndex:indexPath.row];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:fullName];
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.myColorGreen range:anyStudent.firstNameSearchChar];
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.myColorGreen range:anyStudent.lastNameSearchChar];
        
        [attributedString addAttribute:NSBackgroundColorAttributeName value:self.myColorBlack range:anyStudent.firstNameSearchChar];
        [attributedString addAttribute:NSBackgroundColorAttributeName value:self.myColorBlack range:anyStudent.lastNameSearchChar];
        
        cell.textLabel.attributedText = attributedString;
        cell.imageView.image = [UIImage imageNamed:@"searchStudent.png"];
    }
    else cell.imageView.image = [UIImage imageNamed:@"student.png"];

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionValueChangeSigmentedControl:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            
        case SortDescrptionBirthDay:
        {
            
            [self.sortOperation cancel];
            
            self.sortOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                      selector:@selector(sortByMonthInBackground)
                                                                        object:nil];
            [self.sortOperation start];
        }
            break;
            
        case SortDescrptionFirstName:
        {
            [self.sortOperation cancel];
            
            self.sortOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                      selector:@selector(sortByNamesInBackground)
                                                                        object:nil];
            [self.sortOperation start];
        }
            break;
            
        case SortDescrptionLastName:
        {
            [self.sortOperation cancel];
            
            self.sortOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                      selector:@selector(sortByFamalysInBackground)
                                                                        object:nil];
            [self.sortOperation start];
        }
            break;
    }
    [self clearStudentSearchRange];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
    [self clearStudentSearchRange];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.studentHeap = [self sortStudentByBirthDayMonth:self.studentHeap];
    self.sectionHeap = [self generateSectionFromBirthDayMonth:self.studentHeap];
    self.segmentedControl.selectedSegmentIndex = SortDescrptionBirthDay;
    [self clearStudentSearchRange];
    self.searchBar.text = @"";
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSMutableArray *tempStudentArray = self.studentHeap;
    NSMutableArray *tempSectionArray = [[NSMutableArray alloc] initWithArray:self.sectionHeap];
    [self clearStudentSearchRange];
    
    if([searchText length] == 1) {
        
        [tempSectionArray removeAllObjects];
        Section *anySection = [[Section alloc] init];
        anySection.sectionName = searchText;

        for(Student *anyStudent in tempStudentArray){

            if([anyStudent.firstName compare:searchText
                                     options:NSCaseInsensitiveSearch
                                       range:NSMakeRange(0, 1)] == NSOrderedSame || [anyStudent.lastName compare:searchText
                                                                                                          options:NSCaseInsensitiveSearch
                                                                                                            range:NSMakeRange(0, 1)] == NSOrderedSame) {
       
                
                if([anyStudent.firstName compare:searchText
                                         options:NSCaseInsensitiveSearch
                                           range:NSMakeRange(0, 1)] == NSOrderedSame) {
                    
                    anyStudent.firstNameSearchChar = NSMakeRange(0, 1);
                    
                }
                if([anyStudent.lastName compare:searchText
                                               options:NSCaseInsensitiveSearch
                                                 range:NSMakeRange(0, 1)] == NSOrderedSame) {
                    
                    anyStudent.lastNameSearchChar = NSMakeRange([anyStudent.firstName length] + 1, 1);
                    
                }
                
                [anySection.sectionObjectsArray addObject:anyStudent];
                
            }
        }
        [tempSectionArray addObject:anySection];
        self.sectionHeap = tempSectionArray;
    }
    else if([searchText length] > 1) {
        
        [tempSectionArray removeAllObjects];
        Section *searchSection = [self.sectionHeap firstObject];
        searchSection.sectionName = searchText;
        NSMutableArray *tempStudentArray = [[NSMutableArray alloc] init];
        
        for(Student *anyStudent in searchSection.sectionObjectsArray){
            
            if([anyStudent.firstName compare:searchText
                                     options:NSCaseInsensitiveSearch
                                       range:NSMakeRange(0, [searchText length])] == NSOrderedSame || [anyStudent.lastName compare:searchText
                                                                                                         options:NSCaseInsensitiveSearch
                                                                                                           range:NSMakeRange(0, [searchText length])] == NSOrderedSame) {
                
                
                if([anyStudent.firstName compare:searchText
                                         options:NSCaseInsensitiveSearch
                                           range:NSMakeRange(0, [searchText length])] == NSOrderedSame) {
                    
                    anyStudent.firstNameSearchChar = NSMakeRange(0, [searchText length]);
                    
                }
                
                if([anyStudent.lastName compare:searchText
                                               options:NSCaseInsensitiveSearch
                                                 range:NSMakeRange(0, [searchText length])] == NSOrderedSame) {
                    
                    anyStudent.lastNameSearchChar = NSMakeRange([anyStudent.firstName length] + 1, [searchText length]);
                    
                }
                                [tempStudentArray addObject:anyStudent];
 
            }
        }

        if(![tempStudentArray count]) {
            
            [[[UIAlertView alloc] initWithTitle:@"Search:"
                                       message:[NSString stringWithFormat:@"\" %@ \" not found!",searchText]
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil] show];
            
        } else {
            
            searchSection.sectionObjectsArray = tempStudentArray;
            [tempSectionArray addObject:searchSection];
            self.sectionHeap = tempSectionArray;
        }
        
        
        
        
    } else if([searchText length] < 1) {
        
        self.studentHeap = [self sortStudentByBirthDayMonth:self.studentHeap];
        self.sectionHeap = [self generateSectionFromBirthDayMonth:self.studentHeap];
        self.segmentedControl.selectedSegmentIndex = SortDescrptionBirthDay;
        [self clearStudentSearchRange];

    }

    [self.tableView reloadData];
    
 }

- (void) clearStudentSearchRange {
    
    for(Student *anyStudent in self.studentHeap) {
        
        anyStudent.firstNameSearchChar = NSMakeRange(0, 0);
        anyStudent.lastNameSearchChar = NSMakeRange(0, 0);
    }
}

@end
