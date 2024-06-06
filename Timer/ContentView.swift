import SwiftUI

struct ContentView: View {
    @StateObject private var timerApp = TimerApp()

    var body: some View {
        VStack {
            Circle()
                .fill(timerApp.lightColor)
                .frame(width: 100, height: 100)
                .padding()

            if timerApp.isCountdown {
                Text("Get Ready")
                    .font(.largeTitle)
                    .padding()
            } else {
                Text(timerApp.isTraining ? "Training" : "Recovery")
                    .font(.largeTitle)
                    .padding()
            }

            Text("\(timerApp.currentTime) seconds")
                .font(.title)
                .padding()
            
            Text("Round \(timerApp.currentRound) of \(timerApp.totalRounds)")
                .padding()
            
            HStack {
                Button(action: {
                    if timerApp.isActive {
                        timerApp.stopTimer()
                        UIApplication.shared.isIdleTimerDisabled = false // Re-enable idle timer
                    } else {
                        timerApp.startTimer()
                        UIApplication.shared.isIdleTimerDisabled = true // Disable idle timer
                    }
                }) {
                    Text(timerApp.isActive ? "Stop" : "Start")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            VStack(alignment: .leading) {
                Text("Training Time:")
                Stepper(value: $timerApp.trainingTime, in: 10...600, step: 10) {
                    Text("\(timerApp.trainingTime) seconds")
                }
                .padding()

                Text("Recovery Time:")
                Stepper(value: $timerApp.recoveryTime, in: 10...600, step: 10) {
                    Text("\(timerApp.recoveryTime) seconds")
                }
                .padding()

                Text("Total Rounds:")
                Stepper(value: $timerApp.totalRounds, in: 1...20) {
                    Text("\(timerApp.totalRounds)")
                }
                .padding()
            }
            .padding()
        }
        .onDisappear {
            // Re-enable idle timer when the view disappears
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

@main
struct TimerAppMain: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
