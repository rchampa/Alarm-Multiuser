
#import <Foundation/Foundation.h>
@interface UserSettingsObject : NSObject<NSCoding>

@property (nonatomic, assign) BOOL vibration;
@property (nonatomic, assign) BOOL day_of_weak;
@property (nonatomic, assign) BOOL day_of_month;
@property (nonatomic, assign) BOOL month;
@property (nonatomic, assign) BOOL year;
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * password;
@end
