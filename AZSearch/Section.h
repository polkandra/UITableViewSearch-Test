//
//  Section.h
//  Search
//
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.

//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property (strong, nonatomic) NSString *sectionName;
@property (strong, nonatomic) NSMutableArray *sectionObjectsArray;

- (void) sortByNameAndFamaly;

@end
