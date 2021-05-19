//
//  LocalNotificationManager.swift
//  Tes
//
//  Created by David Croy on 5/8/20.
//  Copyright © 2020 DoubleDog Software. All rights reserved.
//

import Foundation
import SwiftUI
import UserNotifications

class LocalNotificationManager: ObservableObject {
    
    var notifications = [Notification]()
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("Notifications permitted")
            } else {
                print("Notifications not permitted")
            }
        }
    }

    func sendNotification(title: String, subtitle: String?, body: String, launchIn: Double) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
            
            if settings.alertSetting == .enabled {
                let content   = UNMutableNotificationContent()
                content.title = title
                
                if let subtitle = subtitle {
                    content.subtitle = subtitle
                }
                content.body = body
                
                //        let imageName       = "appIcon"
                //        guard let imageURL  = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
                //        let attachment      = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
                //        content.attachments = [attachment]
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: launchIn, repeats: false)
                let request = UNNotificationRequest(identifier: "tes", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                // Schedule an alert-only notification.
            }
        }
    }
}
