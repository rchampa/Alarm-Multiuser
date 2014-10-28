
#import "AlarmObject.h"

@implementation AlarmObject

@synthesize id_alarm;
@synthesize label;
@synthesize timeToSetOff;
@synthesize enabled;
@synthesize notificationID;
@synthesize username;
@synthesize song_name;

//This is important to for saving the alarm object in "user defaults"
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:self.id_alarm forKey:@"id_alarm"];
    [encoder encodeObject:self.label forKey:@"label"];
    [encoder encodeObject:self.timeToSetOff forKey:@"timeToSetOff"];
    [encoder encodeBool:self.enabled forKey:@"enabled"];
    [encoder encodeInt:self.notificationID forKey:@"notificationID"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.song_name forKey:@"song_name"];
}
//This is important to for loading the alarm object from user defaults
-(id)initWithCoder:(NSCoder *)decoder
{
    self.id_alarm = [decoder decodeIntForKey:@"id_alarm"];
    self.label = [decoder decodeObjectForKey:@"label"];
    self.timeToSetOff = [decoder decodeObjectForKey:@"timeToSetOff"];
    self.enabled = [decoder decodeBoolForKey:@"enabled"];
    self.notificationID = [decoder decodeIntForKey:@"notificationID"];
    self.username = [decoder decodeObjectForKey:@"username"];
    self.song_name = [decoder decodeObjectForKey:@"song_name"];
    return self;
}

@end
