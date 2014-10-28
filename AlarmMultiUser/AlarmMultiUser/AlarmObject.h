
#import <Foundation/Foundation.h>
@interface AlarmObject : NSObject<NSCoding>

@property (nonatomic,assign) int id_alarm;
@property(nonatomic,strong) NSString * label;
@property(nonatomic,strong) NSDate * timeToSetOff;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic,assign) int notificationID;
@property(nonatomic,strong) NSString * username;
@property(nonatomic,strong) NSString * song_name;

@end
