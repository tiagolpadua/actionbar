import Foundation
import UserNotifications

enum NotificationService {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func sendStartNotification(run: WorkflowRun) {
        send(run: run, title: "Started: \(run.title)", identifier: "run-start-\(run.id)")
    }

    static func sendCompletionNotification(run: WorkflowRun) {
        send(run: run, title: "\(RunStatus(from: run).label): \(run.title)", identifier: "run-\(run.id)")
    }

    private static func send(run: WorkflowRun, title: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "\(run.repositoryFullName) · \(run.headBranch ?? "")"
        content.sound = .default
        content.userInfo = ["url": run.htmlUrl]

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }
}
