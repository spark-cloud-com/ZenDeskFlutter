#import <SDKConfigurations/SDKConfigurations.h>
#import <ChatProvidersSDK/ChatProvidersSDK.h>
#import <MessagingSDK/MessagingSDK.h>
#import <ChatSDK/ChatSDK.h>
#import "ZendeskPlugin.h"

@implementation ZendeskPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.codeheadlabs.zendesk"
            binaryMessenger:[registrar messenger]];
  ZendeskPlugin* instance = [[ZendeskPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
    [ZDKChat initializeWithAccountKey:call.arguments[@"accountKey"] appId:call.arguments[@"appId"] queue:dispatch_get_main_queue()];
    ZDKChatConfiguration *chatConfiguration = [[ZDKChatConfiguration alloc] init];
    chatConfiguration.isAgentAvailabilityEnabled = YES;
    result(@(true));
  } else if ([@"setVisitorInfo" isEqualToString:call.method]) {
      ZDKChatAPIConfiguration *chatAPIConfiguration = [[ZDKChatAPIConfiguration alloc] init];
      NSString *department = call.arguments[@"department"];
      NSMutableString *name = call.arguments[@"name"];
      NSMutableString *email = call.arguments[@"email"];
      NSMutableString *phoneNumber = call.arguments[@"phoneNumber"];
      chatAPIConfiguration.department = department;

      if ([name isKindOfClass:[NSNull class]]){
          name = [[NSMutableString alloc] initWithString:@""];
      }

      if ([phoneNumber isKindOfClass:[NSNull class]]){
          phoneNumber = [[NSMutableString alloc] initWithString:@""];
      }

      if ([email isKindOfClass:[NSNull class]]){
          email = [[NSMutableString alloc] initWithString:@""];
      }

      chatAPIConfiguration.visitorInfo = [[ZDKVisitorInfo alloc]initWithName:name email:email phoneNumber:phoneNumber];
      ZDKChat.instance.configuration = chatAPIConfiguration;
      result(@(true));
  } else if ([@"startChat" isEqualToString:call.method]) {
     ZDKMessagingConfiguration *messagingConfiguration = [[ZDKMessagingConfiguration alloc] init];
       messagingConfiguration.name = @"Chat Bot";
       ZDKChatConfiguration *chatConfiguration = [[ZDKChatConfiguration alloc] init];
       chatConfiguration.isPreChatFormEnabled = YES;

       NSError *error = nil;
       NSArray *engines = @[
           (id <ZDKEngine>) [ZDKChatEngine engineAndReturnError:&error]
       ];

       UIViewController *viewController = [ZDKMessaging.instance buildUIWithEngines:engines
                                                                 configs:@[messagingConfiguration, chatConfiguration]
                                                                 error:&error];

      UINavigationController *navVc = [[UINavigationController alloc] init];
           navVc.navigationBar.translucent = NO;
      navVc.navigationBar.barTintColor = [UIColor colorWithDisplayP3Red:0.1427645981 green:0.6482573152 blue:0.7222642899 alpha:1];
      navVc.viewControllers = @[viewController];

      UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController ;

      [rootVc presentViewController:navVc animated:true completion:^{
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", comment: @"")
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:self
                                                                                          action:@selector(close:)];
        back.tintColor = [UIColor whiteColor];
        navVc.topViewController.navigationItem.leftBarButtonItem = back;
      }];

    result(@(true));
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)close:(id)sender {
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
}
@end