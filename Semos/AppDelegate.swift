//
//  AppDelegate.swift
//  Copy
//
//  Created by JaeHyeon on 2021/07/09.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var myVariable: String = "Hello Swift"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken!)")
        let dataDict:[String: String] = ["token": fcmToken!]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        myVariable = "\(fcmToken!)"
    }
}



//import UIKit
//import Firebase
//import FirebaseMessaging
//import FirebaseAnalytics
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions
//      launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
//  ) -> Bool {
//
//    // 1
//    FirebaseApp.configure()
//    // 2
//    FirebaseConfiguration.shared.setLoggerLevel(.min)
//
//    // 1
//    UNUserNotificationCenter.current().delegate = self
//    // 2
//    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//    UNUserNotificationCenter.current().requestAuthorization(
//      options: authOptions) { _, _ in }
//    // 3
//    application.registerForRemoteNotifications()
//
//    Messaging.messaging().delegate = self
//
//    return true
//  }
//}
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    willPresent notification: UNNotification,
//    withCompletionHandler completionHandler:
//    @escaping (UNNotificationPresentationOptions) -> Void
//  ) {
//    completionHandler([[.banner, .sound]])
//  }
//
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    didReceive response: UNNotificationResponse,
//    withCompletionHandler completionHandler: @escaping () -> Void
//  ) {
//    completionHandler()
//  }
//}
//
//func application(
//  _ application: UIApplication,
//  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//) {
//  Messaging.messaging().apnsToken = deviceToken
//}
//
//extension AppDelegate: MessagingDelegate {
//  func messaging(
//    _ messaging: Messaging,
//    didReceiveRegistrationToken fcmToken: String?
//  ) {
//    let tokenDict = ["token": fcmToken ?? ""]
//    NotificationCenter.default.post(
//      name: Notification.Name("FCMToken"),
//      object: nil,
//      userInfo: tokenDict)
//  }
//}
