import SwiftUI

struct ContentView: View {
    @StateObject private var timerApp = TimerApp()
    @State private var isFinnish = false

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
        "training_time": "Harjoitusaika",
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
                    isFinnish.toggle()
                }) {
                    Text(isFinnish ? "English" : "Suomi")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()

            Circle()
                .fill(timerApp.lightColor)
                .frame(width: 120, height: 120)
                .shadow(radius: 10)
                .padding()

            Text(timerApp.isCountdown ? (isFinnish ? finnishStrings["get_ready"]! : englishStrings["get_ready"]!) : (timerApp.isTraining ? (isFinnish ? finnishStrings["training_time"]! : englishStrings["training_time"]!) : (isFinnish ? finnishStrings["recovery_time"]! : englishStrings["recovery_time"]!)))
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("\(timerApp.currentTime)")
                .font(.system(size: 50, weight: .bold, design: .monospaced))
                .padding()

            Text(isFinnish ? "\(finnishStrings["round"]!) \(timerApp.currentRound) / \(timerApp.totalRounds)" : "\(englishStrings["round"]!) \(timerApp.currentRound) / \(timerApp.totalRounds)")
                .font(.headline)
                .padding()

            Spacer()

            HStack(spacing: 20) {
                Button(action: {
                    if timerApp.isActive {
                        timerApp.stopTimer()
                        UIApplication.shared.isIdleTimerDisabled = false // Re-enable idle timer
                    } else {
                        timerApp.startTimer()
                        UIApplication.shared.isIdleTimerDisabled = true // Disable idle timer
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
            .padding()

            VStack(alignment: .leading, spacing: 10) {
                SettingRow(label: isFinnish ? finnishStrings["training_time"]! : englishStrings["training_time"]!, value: $timerApp.trainingTime, range: 10...600)
                SettingRow(label: isFinnish ? finnishStrings["recovery_time"]! : englishStrings["recovery_time"]!, value: $timerApp.recoveryTime, range: 10...600)
                SettingRow(label: isFinnish ? finnishStrings["total_rounds"]! : englishStrings["total_rounds"]!, value: $timerApp.totalRounds, range: 1...20)
            }
            .padding()
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
    var range: ClosedRange<Int>

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            HStack {
                Text("\(value)")
                    .font(.subheadline)
                Stepper("", value: $value, in: range)
                    .labelsHidden()
            }
            .frame(width: 120)
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
