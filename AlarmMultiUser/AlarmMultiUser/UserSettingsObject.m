
#import "UserSettingsObject.h"

@implementation UserSettingsObject

@synthesize vibration;
@synthesize day_of_weak;
@synthesize day_of_month;
@synthesize month;
@synthesize year;
@synthesize username;
@synthesize password;

//This is important to for saving the alarm object in "user defaults"
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:self.vibration forKey:@"vibration"];
    [encoder encodeBool:self.day_of_weak forKey:@"day_of_weak"];
    [encoder encodeBool:self.day_of_month forKey:@"day_of_month"];
    [encoder encodeBool:self.month forKey:@"month"];
    [encoder encodeBool:self.year forKey:@"year"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
}
//This is important to for loading the alarm object from user defaults
-(id)initWithCoder:(NSCoder *)decoder
{
    self.vibration = [decoder decodeBoolForKey:@"vibration"];
    self.day_of_weak = [decoder decodeBoolForKey:@"day_of_weak"];
    self.day_of_month = [decoder decodeBoolForKey:@"day_of_month"];
    self.month = [decoder decodeBoolForKey:@"month"];
    self.year = [decoder decodeBoolForKey:@"year"];
    self.username = [decoder decodeObjectForKey:@"username"];
    self.password = [decoder decodeObjectForKey:@"password"];
    return self;
}

@end
