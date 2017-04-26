//
//  TAAESCrypt.h
//


#import <Foundation/Foundation.h>

@interface TAAESCrypt : NSObject

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;

@end
