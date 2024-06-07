import Foundation
import AVFoundation
import SwiftUI

class TimerApp: ObservableObject {
    @Published var trainingTime: Int = 60 // default training time in seconds
    @Published var recoveryTime: Int = 60 // default recovery time in seconds
    @Published var totalRounds: Int = 5 // default number of rounds
    @Published var currentRound: Int = 0
    @Published var currentTime: Int = 0
    @Published var isTraining: Bool = true
    @Published var isActive: Bool = false
    @Published var isCountdown: Bool = true
    @Published var lightColor: Color = .red // Red for training, blue for recovery

    var timer: Timer?
    var audioPlayer: AVAudioPlayer?

    init() {
        loadSound()
    }

    func startTimer() {
        self.currentRound = 1
        self.isTraining = true
        self.isActive = true
        self.isCountdown = true
        self.currentTime = 5 // 5 seconds countdown at the start
        self.lightColor = .red
        runTimer()
    }

    func runTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.currentTime > 0 {
                self.currentTime -= 1
            } else {
                self.playSound()
                if self.isCountdown {
                    self.isCountdown = false
                    self.currentTime = self.isTraining ? self.trainingTime : self.recoveryTime
                } else if self.isTraining {
                    self.isTraining = false
                    self.lightColor = .blue
                    self.currentTime = self.recoveryTime
                } else {
                    self.currentRound += 1
                    if self.currentRound > self.totalRounds {
                        self.timer?.invalidate()
                        self.isActive = false
                        return
                    }
                    self.isTraining = true
                    self.lightColor = .red
                    self.currentTime = self.trainingTime
                }
            }
        }
    }

    func stopTimer() {
        self.timer?.invalidate()
        self.isActive = false
        self.currentTime = 0
        self.currentRound = 0
        self.isCountdown = true
        self.lightColor = .red
    }

    private func loadSound() {
        if let soundURL = Bundle.main.url(forResource: "Hero", withExtension: "aiff") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                print("Sound file loaded successfully.")
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found.")
        }
    }

    private func playSound() {
        audioPlayer?.play()
        print("Playing sound.")
    }
}
