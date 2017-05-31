//
//  Section.m
//  Search
//
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.

//

#import "Section.h"

@implementation Section

- (id)init
{
    self = [super init];
    if (self) {
        
        self.sectionObjectsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) sortByNameAndFamaly {
    
    NSSortDescriptor *firstName = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastName = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescription = [[NSMutableArray alloc] initWithObjects: firstName, lastName, nil];
    
    [self.sectionObjectsArray sortUsingDescriptors:sortDescription];
}


@end
