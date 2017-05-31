//
//  Student.m
//  Search
//
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import "Student.h"

@implementation Student

- (id)init
{
    self = [super init];
    if (self) {
        
        NSArray *firstNames = [[NSArray alloc] initWithObjects:
                               @"Alex",@"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
                               @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
                               @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
                               @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
                               @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
                               @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
                               @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
                               @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
                               @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
                               @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie", nil];
        
        NSArray *lastNames = [[NSArray alloc] initWithObjects:
                              
                              @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
                              @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
                              @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
                              @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
                              @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
                              @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
                              @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
                              @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
                              @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
                              @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook", nil];
        
        
        self.firstName = [firstNames objectAtIndex:arc4random() % [firstNames count]];
        self.lastName = [lastNames objectAtIndex:arc4random() % [lastNames count]];
        self.birthDay = [Student createBirthDay];
        self.firstNameSearchChar = NSMakeRange(0, 0);
        self.lastNameSearchChar = NSMakeRange(0, 0);
        
    }
    return self;
}

- (NSInteger) getBirthDayMonth {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.birthDay];
    
    return [components month];
}

+ (NSDate *) createBirthDay {
    
    NSDate *dateBirth = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitYear fromDate:dateBirth];
    
    [components setYear:(arc4random() % 29) + 1970];
    [components setMonth:(arc4random() % 12) + 1];
    [components setDay:(arc4random() % 29) + 1];
    
    dateBirth = [currentCalendar dateFromComponents:components];
    
    return dateBirth;
    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd.MM.yyyy"];
//    
//    return [dateFormat dateFromString:[NSString stringWithFormat:@"%u.%u.%u",
//                                       (arc4random() % 29) + 1,
//                                       (arc4random() % 12) + 1,
//                                       (arc4random() % 29) + 1970]];
    
}

-(NSString *)description{
    
    return [NSString stringWithFormat:@"student: %@ %@ %@", self.firstName, self.lastName, self.birthDay];
}



@end
