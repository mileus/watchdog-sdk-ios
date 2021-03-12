
import Foundation
import UserNotifications


protocol NotificationsService {
    func requestPermission(completion: @escaping (Bool) -> Void)
    func showBackgroundSyncNotification()
}

protocol LocalNotificationsServiceDelegate {
    func notificationServiceStartBackgroundSync()
}

final class LocalNotificationsService: NSObject, NotificationsService {
    
    private enum Categories: String {
        case backgroundSync = "BackgroundSync"
        case backgroundSyncStartAction = "BackgroundSyncStartAction"
    }
    
    let delegate: LocalNotificationsServiceDelegate
    private let client = UNUserNotificationCenter.current()
    
    init(delegate: LocalNotificationsServiceDelegate) {
        self.delegate = delegate
        super.init()
        client.delegate = self
    }
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        client.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (granted, error) in
            if granted {
                self?.registerCategories()
            }
            completion(granted)
        }
    }
    
    func showBackgroundSyncNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Background Location Testing"
        content.subtitle = "Long press this notification and press the button to start location scanning."
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = Categories.backgroundSync.rawValue

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        client.add(request)
    }
    
    private func registerCategories() {
        let backgroundSyncAction = UNNotificationAction(
            identifier: Categories.backgroundSyncStartAction.rawValue,
            title: "Start Sync",
            options: []
        )
        let backgroundSyncCategory = UNNotificationCategory(
            identifier: Categories.backgroundSync.rawValue,
            actions: [backgroundSyncAction],
            intentIdentifiers: [],
            options: [])
        client.setNotificationCategories(Set([backgroundSyncCategory]))
    }
    
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == Categories.backgroundSyncStartAction.rawValue {
            handleBackgroundSyncAction(completion: completionHandler)
        } else {
            completionHandler()
        }
    }
    
    private func handleBackgroundSyncAction(completion: @escaping () -> Void) {
        delegate.notificationServiceStartBackgroundSync()
    }
}
