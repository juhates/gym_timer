import SwiftUI

struct ContentView: View {
    @StateObject private var timerApp = TimerApp()
    @State private var isFinnish = true
    @State private var isTrainingStarted = false

    // English translations
    let englishStrings = [
        "get_ready": "Get Ready",
        "training_time": "Training Time",
        "recovery_time": "Recovery Time",
        "total_rounds": "Total Rounds",
        "start": "Start",
        "stop": "Stop",
        "round": "Round",
    ]
    
    // Finnish translations
    let finnishStrings = [
        "get_ready": "Valmistaudu",
        "training_time": "Harjoittelu",
        "recovery_time": "Palautumisaika",
        "total_rounds": "Kokonaiskierrokset",
        "start": "Aloita",
        "stop": "Pysäytä",
        "round": "Kierros",
    ]

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        isFinnish.toggle()
                    }
                }) {
                    Text(isFinnish ? "English" : "Suomi")
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .padding()

            ZStack {
                Circle()
                    .fill(timerApp.lightColor)
                    .frame(width: isTrainingStarted ? 300 : 120, height: isTrainingStarted ? 300 : 120)
                    .shadow(radius: 10)
                    .scaleEffect(isTrainingStarted ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isTrainingStarted)
                    .padding()

                Text("\(timerApp.currentTime)")
                    .font(.system(size: isTrainingStarted ? 100 : 50, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .animation(.easeInOut(duration: 0.3), value: isTrainingStarted)
            }

            if !isTrainingStarted {
                Text(isFinnish ? (timerApp.isCountdown ? finnishStrings["get_ready"]! : (timerApp.isTraining ? "Harjoittelu" : "Palautuminen")) : (timerApp.isCountdown ? englishStrings["get_ready"]! : (timerApp.isTraining ? "Training" : "Recovery")))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(timerApp.isCountdown ? .red : (timerApp.isTraining ? .red : .green))
                    .padding()
                    .transition(.scale)
            }

            if !isTrainingStarted {
                Text(isFinnish ? "\(finnishStrings["round"]!) \(timerApp.currentRound) / \(timerApp.totalRounds)" : "\(englishStrings["round"]!) \(timerApp.currentRound) / \(timerApp.totalRounds)")
                    .font(.headline)
                    .padding()
            }

            Spacer()

            HStack(spacing: 20) {
                Button(action: {
                    withAnimation {
                        if timerApp.isActive {
                            timerApp.stopTimer()
                            UIApplication.shared.isIdleTimerDisabled = false // Re-enable idle timer
                            isTrainingStarted = false
                        } else {
                            timerApp.startTimer()
                            UIApplication.shared.isIdleTimerDisabled = true // Disable idle timer
                            isTrainingStarted = true
                        }
                    }
                }) {
                    Text(timerApp.isActive ? (isFinnish ? finnishStrings["stop"]! : englishStrings["stop"]!) : (isFinnish ? finnishStrings["start"]! : englishStrings["start"]!))
                        .font(.title)
                        .frame(width: 100, height: 50)
                        .background(timerApp.isActive ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding(.bottom, isTrainingStarted ? 50 : 20)
            .animation(.easeInOut(duration: 0.3), value: isTrainingStarted)

            if !isTrainingStarted {
                VStack(alignment: .leading, spacing: 10) {
                    SettingRow(label: isFinnish ? finnishStrings["training_time"]! : englishStrings["training_time"]!, value: $timerApp.trainingTime, increment: 10, decrement: 10)
                    SettingRow(label: isFinnish ? finnishStrings["recovery_time"]! : englishStrings["recovery_time"]!, value: $timerApp.recoveryTime, increment: 10, decrement: 10)
                    SettingRow(label: isFinnish ? finnishStrings["total_rounds"]! : englishStrings["total_rounds"]!, value: $timerApp.totalRounds, increment: 1, decrement: 1)
                }
                .padding()
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.3), value: isTrainingStarted)
            }
        }
        .padding()
        .onDisappear {
            // Re-enable idle timer when the view disappears
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

struct SettingRow: View {
    var label: String
    @Binding var value: Int
    var increment: Int
    var decrement: Int

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            HStack {
                Button(action: {
                    if value > 1 {
                        value -= decrement
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }

                Text("\(value)")
                    .font(.subheadline)
                    .frame(width: 50)

                Button(action: {
                    value += increment
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
