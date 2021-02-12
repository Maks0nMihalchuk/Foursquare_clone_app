//
//  NotificationManager.swift
//  Foursquare_clone_app
//
//  Created by maks on 04.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UserNotifications
import Foundation
import UIKit

struct NotificationManager {

    static private var notifications = [Notification]()

    static private func requestPermission() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: options) { (isAllowed, error) in

                if isAllowed == true && error == nil {

                }
        }
    }

    static private func addNotification(title: String, body: String) {
        notifications.append(Notification(id: UUID().uuidString,
                                          title: title,
                                          body: body))
    }

    static private func scheduleNotifications(_ durationInSeconds: Int,
                                              repeats: Bool,
                                              userInfo: [AnyHashable: Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        notifications.forEach { (notification) in
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
            content.userInfo = userInfo

            let timeInterval = TimeInterval(durationInSeconds)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                            repeats: repeats)
            let request = UNNotificationRequest(identifier: notification.id,
                                                content: content,
                                                trigger: trigger)

            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) { (error) in

                guard error == nil else { return }

            }
        }
        notifications.removeAll()
    }

    static private func scheduleNotifications(_ duration: Int,
                                              of type: NotificationDurationType,
                                              repeats: Bool,
                                              userInfo: [AnyHashable: Any]) {
        var second = 0
        switch type {
        case .seconds:
            second = duration
        case .minutes:
            second = duration * 60
        }
        scheduleNotifications(second, repeats: repeats, userInfo: userInfo)
    }

    static func cancel() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    static func setNotification(_ duration: Int,
                                of type: NotificationDurationType,
                                repeats: Bool,
                                notificationOptions: (title: String, body: String),
                                userInfo: [AnyHashable: Any]) {
        requestPermission()
        addNotification(title: notificationOptions.title, body: notificationOptions.body)
        scheduleNotifications(duration, of: type, repeats: repeats, userInfo: userInfo)
    }
}
