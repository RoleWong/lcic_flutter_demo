#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <TCICSDK/TCICClassConfig.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* flutterViewController = (FlutterViewController*)self.window.rootViewController;
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:flutterViewController];
    self.window.rootViewController = navigationController;

    FlutterMethodChannel* methodChannel = [FlutterMethodChannel
                                           methodChannelWithName:@"lcic_sdk"
                                           binaryMessenger:flutterViewController.binaryMessenger];

    [methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if ([@"joinClass" isEqualToString:call.method]) {
            NSDictionary *args = call.arguments;
            [self joinClassWithArgs:args result:result];
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];

    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)joinClassWithArgs:(NSDictionary *)args result:(FlutterResult)result {
    NSNumber *schoolId = args[@"schoolId"];
    NSString *userId = args[@"userId"];
    NSString *token = args[@"token"];
    NSNumber *classId = args[@"classId"];

    if (!schoolId || !userId || !token || !classId) {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"缺少必要参数"
                                   details:nil]);
        return;
    }

    // 配置课堂参数
    TCICClassConfig *roomConfig = [[TCICClassConfig alloc] init];
    roomConfig.schoolId = [schoolId intValue];
    roomConfig.userId = userId;
    roomConfig.token = token;
    roomConfig.classId = [classId longValue];

    if (args[@"language"]) {
        [roomConfig setValue:args[@"language"] forKey:@"language"];
    }
    if (args[@"scene"]) {
        [roomConfig setValue:args[@"scene"] forKey:@"scene"];
    }
    if (args[@"preferPortrait"]) {
        [roomConfig setValue:args[@"preferPortrait"] forKey:@"preferPortrait"];
    }
    if (args[@"preferPortrait"]) {
        [roomConfig setValue:args[@"preferPortrait"] forKey:@"preferPortrait"];
    }
    if (args[@"preferPortrait"]) {
        [roomConfig setValue:args[@"preferPortrait"] forKey:@"preferPortrait"];
    }

    // 调起课堂主页面
    TCICClassController *vc = [TCICClassController classRoomWithConfig:roomConfig];
    if (vc) {
        [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES]; // todo: 这一步报错: Exception    NSException *    "-[FlutterViewController pushViewController:animated:]: unrecognized selector sent to instance 0x15a5e8c00"    0x0000000303d9b390
        result(@"进入课堂成功");
    } else {
        result([FlutterError errorWithCode:@"INVALID_PARAMETERS"
                                   message:@"参数错误，无法进入课堂"
                                   details:nil]);
    }
}
@end
