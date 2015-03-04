#import "FlurryAnalyticsPlugin.h"
#import "Flurry.h"

@implementation FlurryAnalyticsPlugin

- (void)initialize:(CDVInvokedUrlCommand *)command {

    CDVPluginResult *result;

    @try {
        NSString *appKey = [command argumentAtIndex:0];
        NSDictionary *options = [command argumentAtIndex:1 withDefault:nil andClass:[NSDictionary class]];

        if (options != nil) {

            if ([options valueForKey:@"version"] != nil) {
                [Flurry setAppVersion:options[@"version"]];
            }

            if ([options valueForKey:@"continueSessionMillis"] != nil) {

                [Flurry setSessionContinueSeconds:[options[@"continueSessionMillis"] integerValue]];
            }

            if ([options valueForKey:@"logLevel"] != nil) {
                NSString *level = [options[@"logLevel"] uppercaseString];

                if ([@"VERBOSE" isEqualToString:level]) {
                    [Flurry setLogLevel:FlurryLogLevelAll];
                } else if ([@"DEBUG" isEqualToString:level]) {
                    [Flurry setLogLevel:FlurryLogLevelDebug];
                } else if ([@"INFO" isEqualToString:level]) {
                    [Flurry setLogLevel:FlurryLogLevelDebug];
                } else if ([@"WARN" isEqualToString:level]) {
                    [Flurry setLogLevel:FlurryLogLevelCriticalOnly];
                } else if ([@"ERROR" isEqualToString:level]) {
                    [Flurry setLogLevel:FlurryLogLevelCriticalOnly];
                } else {
                    // TODO: log and return warning, leave log level at default
                }
            }

            if ([options valueForKey:@"continueSessionSeconds"] != nil) {

                [Flurry setSessionContinueSeconds:[options[@"continueSessionSeconds"] intValue]];
            }

            if ([options valueForKey:@"userId"] != nil) {

                [Flurry setUserID:options[@"userId"]];
            }

            if ([options valueForKey:@"gender"] != nil) {

                char gender = [[options[@"gender"] lowercaseString] characterAtIndex:0];
                if (gender == 'm') {
                    [Flurry setUserID:@"m"];
                } else if (gender == 'f') {
                    [Flurry setUserID:@"f"];
                } else {
                    // TODO: log and warning, leave gender as default
                }
            }

            if ([options valueForKey:@"age"] != nil) {

                [Flurry setAge:[options[@"age"] intValue]];
            }

            if ([options valueForKey:@"enableEventLogging"] != nil) {
                [Flurry setEventLoggingEnabled:[options[@"enableEventLogging"] boolValue]];
            }

            if ([options valueForKey:@"reportSessionsOnPause"] != nil) {
                [Flurry setSessionReportsOnCloseEnabled:[options[@"reportSessionsOnPause"] boolValue]];
            }

            if ([options valueForKey:@"reportSessionsOnPause"] != nil) {
                [Flurry setSessionReportsOnPauseEnabled:[options[@"reportSessionsOnPause"] boolValue]];
            }

            if ([options valueForKey:@"enableBackgroundSessions"] != nil) {
                [Flurry setBackgroundSessionEnabled:[options[@"enableBackgroundSessions"] boolValue]];
            }

            if ([options valueForKey:@"enableCrashReporting"] != nil) {
                [Flurry setCrashReportingEnabled:[options[@"enableCrashReporting"] boolValue]];
            }
        }

        [Flurry startSession:appKey];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                   messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)logEvent:(CDVInvokedUrlCommand *)command {

    CDVPluginResult *result = nil;

    NSString *event = [command argumentAtIndex:0];
    BOOL isTimed = [[command argumentAtIndex:1] boolValue];
    NSDictionary *parameters = [command argumentAtIndex:2 withDefault:nil andClass:[NSDictionary class]];

    NSLog(@"Logging Event %@", event);

    @try {

        if (parameters == nil) {

            [Flurry logEvent:event timed:isTimed];
        } else {

            [Flurry logEvent:event withParameters:parameters timed:isTimed];
        }
        [Flurry logEvent:event];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)endTimedEvent:(CDVInvokedUrlCommand *)command {

    CDVPluginResult *result;

    NSLog(@"Logging End of Timed Event %@", [command argumentAtIndex:0]);

    @try {
        NSString *event = [command argumentAtIndex:0];
        NSDictionary *parameters = [command argumentAtIndex:1 withDefault:nil andClass:[NSDictionary class]];

        [Flurry endTimedEvent:event withParameters:parameters];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION
                                         messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)logPageView:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = nil;

    NSLog(@"Logging Page View");

    @try {

        [Flurry logPageView];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


- (void)setLocation:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = nil;

    NSLog(@"Reporting location to Flurry");

    @try {
        double latitude = [[command argumentAtIndex:0] doubleValue];
        double longitude = [[command argumentAtIndex:1] doubleValue];
        float horizontalAccuracy = [[command argumentAtIndex:2] floatValue];
        float verticalAccuracy = [[command argumentAtIndex:3] floatValue];

        [Flurry setLatitude:latitude longitude:longitude horizontalAccuracy:horizontalAccuracy verticalAccuracy:verticalAccuracy];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION
                                         messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)logError:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = nil;

    NSString *errorID = [command argumentAtIndex:0];
    NSString *message = [command argumentAtIndex:1];

    NSLog(@"Logging Error with id %@", errorID);

    @try {

        [Flurry logError:errorID message:message error:nil];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)startSession:(CDVInvokedUrlCommand *)command {

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"startSession is not supported for ios"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)endSession:(CDVInvokedUrlCommand *)command {

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"endSession is not supported for ios"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end