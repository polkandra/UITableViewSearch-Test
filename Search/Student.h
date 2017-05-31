//
//  Student.h
//  Search
//
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.

//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate *birthDay;
@property (assign, nonatomic) NSRange firstNameSearchChar;
@property (assign, nonatomic) NSRange lastNameSearchChar;

+ (NSDate *) createBirthDay;
- (NSInteger) getBirthDayMonth;

@end
