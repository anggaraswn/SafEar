import SwiftUI
import Combine

class StopwatchViewModel: ObservableObject {
    @Published var hoursString = "00"
    @Published var minutesString = "00"
    @Published var secondsString = "00"
    @Published var secondsElapsed: TimeInterval = 0
    @Published var showAlert = false
    
    private var timer: AnyCancellable?
    private var startDate: Date?
    
    func start() {
        reset() // Ensure the state is reset before starting
        startDate = Date()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTime()
            }
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    func reset() {
        stop()
        hoursString = "00"
        minutesString = "00"
        secondsString = "00"
        secondsElapsed = 0
        startDate = nil
        showAlert = false
    }
    
    private func updateTime() {
        guard let startDate = startDate else { return }
        let elapsed = Date().timeIntervalSince(startDate)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60
        hoursString = String(format: "%02d", hours)
        minutesString = String(format: "%02d", minutes)
        secondsString = String(format: "%02d", seconds)
        secondsElapsed = elapsed.truncatingRemainder(dividingBy: 60)
        
        if elapsed.truncatingRemainder(dividingBy: 1800) == 0 && elapsed > 0 {
            showAlert = true
        }
    }
}
