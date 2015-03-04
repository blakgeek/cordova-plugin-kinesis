#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

@interface KinesisPlugin : CDVPlugin

- (void)initialize:(CDVInvokedUrlCommand *)command;
- (void)sendMessage:(CDVInvokedUrlCommand *)command;
- (void)purge:(CDVInvokedUrlCommand *)command;

@property(nonatomic) NSString *stream;
@end
