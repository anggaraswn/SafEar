import Foundation
import AVFoundation

class AudioMonitor: ObservableObject {
    @Published var dBValue: Float = 0.0
    private var outputMonitor: AudioOutputMonitor?

    init() {
        setupNotificationObserver()
        outputMonitor = AudioOutputMonitor()
    }

    func startMonitoring() {
        outputMonitor?.startMonitoring()
    }

    func stopMonitoring() {
        outputMonitor?.stopMonitoring()
    }

    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDBLevel(notification:)), name: NSNotification.Name("AudioLevelUpdated"), object: nil)
    }

    @objc private func updateDBLevel(notification: Notification) {
        if let dB = notification.object as? NSNumber {
            DispatchQueue.main.async {
                print(self.dBValue)
                self.dBValue = dB.floatValue
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
