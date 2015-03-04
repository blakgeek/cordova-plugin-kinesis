#import "KinesisPlugin.h"
#import <AWSiOSSDKv2/AWSCore.h>
#import <AWSCognitoSync/Cognito.h>
#import <AWSiOSSDKv2/Kinesis.h>

@implementation KinesisPlugin

- (void)initialize:(CDVInvokedUrlCommand *)command {

    NSString *poolId = [command argumentAtIndex:0];
    NSString *region = [command argumentAtIndex:1 withDefault:@"AWSRegionUSEast1"];

    NSDictionary *regions = @{
            @"us-east-1" : @(AWSRegionUSEast1),
            @"us-west-1" : @(AWSRegionUSWest1),
            @"us-west-2" : @(AWSRegionUSWest2),
            @"eu-west-1" : @(AWSRegionEUWest1),
            @"eu-central-1" : @(AWSRegionEUCentral1),
            @"ap-southeast-1" : @(AWSRegionAPSoutheast1),
            @"ap-northeast-1" : @(AWSRegionAPNortheast1),
            @"ap-southeast-2" : @(AWSRegionAPSoutheast2),
            @"sa-east-1" : @(AWSRegionSAEast1),
            @"cn-north-1" : @(AWSRegionCNNorth1)
    };

    // Initialize the Amazon Cognito credentials provider
    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider
            credentialsWithRegionType:[[regions valueForKey:region] integerValue]
                       identityPoolId:poolId];

    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1
                                                                          credentialsProvider:credentialsProvider];

    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


- (void)sendMessage:(CDVInvokedUrlCommand *)command {

    NSString *message = [command argumentAtIndex:0 withDefault:@"Waaazup?"];
    NSString *streamName = [command argumentAtIndex:1];
    AWSKinesisRecorder *kinesisRecorder = [AWSKinesisRecorder defaultKinesisRecorder];
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];

    [[[kinesisRecorder saveRecord:messageData streamName:streamName] continueWithSuccessBlock:^id(BFTask *task) {
        return [kinesisRecorder submitAllRecords];
    }] continueWithBlock:^id(BFTask *task) {
        CDVPluginResult *result;
        if (task.error) {
            // TODO: figure out the best way to return errors
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:task.error.localizedFailureReason];
        } else {

            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return nil;
    }];
}

- (void)purge:(CDVInvokedUrlCommand *)command {

    AWSKinesisRecorder *kinesisRecorder = [AWSKinesisRecorder defaultKinesisRecorder];
    [[kinesisRecorder removeAllRecords] continueWithBlock:^id(BFTask *task) {
        CDVPluginResult *result;
        if (task.error) {
            // TODO: figure out the best way to return errors
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:task.error.localizedFailureReason];
        } else {

            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];

        return nil;
    }];
}


@end