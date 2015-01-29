//
//  AppDelegate.m
//  Stand Up
//
//  Created by Andreas Graulund on 02/01/15.
//  Copyright (c) 2015 Pongsocket. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

-(NSDate *)calculateFirstAlertTime;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // Create a new local notification
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    // Set the title of the notification
    notification.title = @"Stand Up";
    // Set the text of the notification
    notification.informativeText = @"Don't sit down!";
    // Schedule the notification to be delivered 20 seconds after execution
    notification.deliveryDate = [self calculateFirstAlertTime];
    
    NSDateComponents *repeat = [[NSDateComponents alloc] init];
    [repeat setMinute:STAND_UP_MINUTE_INTERVAL];
    
    notification.deliveryRepeatInterval = repeat;
    
    NSLog(@"Delivery at %@", notification.deliveryDate); //DEBUG
    NSLog(@"Repeat: %@", notification.deliveryRepeatInterval); //DEBUG
    
    // Get the default notification center and schedule delivery
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(NSDate *)calculateFirstAlertTime {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    // Set the time components manually
    [dateComps setHour:STAND_UP_FIRST_HOUR];
    [dateComps setMinute:STAND_UP_FIRST_MINUTE];
    [dateComps setSecond:0];
    
    // Convert back
    // This is the first alert time of the current day.
    NSDate *alertDate = [calendar dateFromComponents:dateComps];
    
    // Now we convert this to the first alert time that we're actually doing.
    // We add the interval until we get a time that's in the future
    
    NSDate *now = [NSDate date];
    
    while ([alertDate compare:now] != NSOrderedDescending) {
        alertDate = [NSDate dateWithTimeInterval:STAND_UP_MINUTE_INTERVAL * 60 sinceDate:alertDate];
    }
    
    return alertDate;
}

@end
