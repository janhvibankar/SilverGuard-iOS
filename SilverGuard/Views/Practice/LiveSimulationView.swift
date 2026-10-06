import SwiftUI
import Combine

struct LiveSimulationView: View {
    let scenario: Scenario
    @ObservedObject var state: PracticeState
    @Environment(\.dismiss) var dismiss

    @State private var isPaused = false
    @State private var callSeconds = 88  // 01:28 initial elapsed time
    @State private var timer: AnyCancellable? = nil
    @State private var showingResult = false
    @State private var selectedAnswer: String? = nil

    // Simulated conversation data
    private let messages: [SimMessage] = [
        SimMessage(id: 0, speaker: "Officer Davis",
                   text: "\"Ma'am, there is suspicious spending on your account. Someone in Miami is trying to charge $1,400 for electronics right now.\"",
                   isRedFlag: false),
        SimMessage(id: 1, speaker: "Officer Davis",
                   text: "\"To cancel this charge immediately, ",
                   boldSegment: "you must give me your 4-digit card PIN right this second",
                   trailingText: " or the funds will be lost forever!\"",
                   isRedFlag: false)
    ]

    private let choices = [
        SimChoice(id: "give_pin", text: "Read my 4-digit PIN to the officer", isCorrect: false),
        SimChoice(id: "hang_up_call_card", text: "Hang up and call the number on my card", isCorrect: true)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // ─── Caller card ───────────────────────────────────────
                CallerCard(scenario: scenario,
                           callSeconds: callSeconds,
                           isPaused: $isPaused)
                    .padding(.horizontal, SGSpacing.gutter)
                    .padding(.top, 8)
                    .padding(.bottom, SGSpacing.md)

                // ─── Risk meter ────────────────────────────────────────
                RiskMeterView(currentLevel: .highRisk, percentage: 85)
                    .silverCard()
                    .padding(.horizontal, SGSpacing.gutter)
                    .padding(.bottom, SGSpacing.md)

                // ─── Audio indicator ───────────────────────────────────
                AudioIndicatorRow()
                    .padding(.horizontal, SGSpacing.gutter)
                    .padding(.bottom, SGSpacing.sm)

                // ─── Simulated conversation ────────────────────────────
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(messages) { msg in
                        SimMessageView(message: msg)
                    }

                    // Red flag alert
                    RedFlagCard()
                }
                .padding(.horizontal, SGSpacing.gutter)
                .padding(.bottom, SGSpacing.md)

                // ─── Waiting indicator ────────────────────────────────
                HStack(spacing: 8) {
                    Image(systemName: "hourglass")
                        .font(.system(size: 14))
                    Text("The caller is on the line waiting for your reaction…")
                        .font(.system(size: 15))
                        .italic()
                }
                .foregroundColor(Color.silverSecondaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: SGRadius.md)
                        .fill(Color.silverSurfaceHigh)
                )
                .padding(.horizontal, SGSpacing.gutter)
                .padding(.bottom, SGSpacing.md)

                // ─── Safe move choices ────────────────────────────────
                SafeMoveSection(choices: choices,
                                selectedAnswer: $selectedAnswer,
                                onSelect: { answerId in
                                    guard selectedAnswer == nil else { return }
                                    withAnimation { selectedAnswer = answerId }
                                    stopTimer()

                                    if let choice = choices.first(where: { $0.id == answerId }) {
                                        Task {
                                            await state.recordSimulationCompletion(
                                                scenario: scenario,
                                                answerId: choice.id,
                                                isCorrect: choice.isCorrect,
                                                durationSeconds: callSeconds
                                            )
                                        }
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        showingResult = true
                                    }
                                })
                    .padding(.horizontal, SGSpacing.gutter)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.silverBackground.ignoresSafeArea())
        .navigationTitle("Practice Simulatio…")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 10) {
                    Button {
                        isPaused.toggle()
                        isPaused ? stopTimer() : startTimer()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text(isPaused ? "Resume" : "Pause")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(Color.silverText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.silverSurface)
                                .overlay(Capsule().stroke(Color.silverBorder, lineWidth: 2))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(minWidth: 88, minHeight: 44)
                    .accessibilityLabel(isPaused ? "Resume simulation" : "Pause simulation")

                    ZStack {
                        Circle().fill(Color.silverPrimaryContainer).frame(width: 36, height: 36)
                        Image(systemName: "person.fill").font(.system(size: 16)).foregroundColor(.white)
                    }
                    .frame(width: 44, height: 44)
                }
            }
        }
        .sheet(isPresented: $showingResult) {
            let choice = choices.first(where: { $0.id == selectedAnswer })
            let isCorrect = choice?.isCorrect ?? false
            SimulationResultSheet(isCorrect: isCorrect, score: isCorrect ? 10 : 2) {
                showingResult = false
                dismiss()
            }
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }

    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if !isPaused { callSeconds += 1 }
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

// MARK: - Caller Card
private struct CallerCard: View {
    let scenario: Scenario
    let callSeconds: Int
    @Binding var isPaused: Bool

    private var timeString: String {
        let m = callSeconds / 60, s = callSeconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color.silverSafeContainer).frame(width: 48, height: 48)
                Image(systemName: "phone.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.silverSafe)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("National Bank Se…")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.silverText)
                Text("+1 (800) 555-0199")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.silverSecondaryText)
            }

            Spacer()

            HStack(spacing: 6) {
                Circle().fill(Color.silverDanger).frame(width: 8, height: 8)
                Text(timeString)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.silverText)
            }
        }
        .padding(SGSpacing.md)
        .background(Color.silverSurface)
        .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                .stroke(Color.silverBorder, lineWidth: 2)
        )
        .silverCardShadow()
        .accessibilityLabel("Simulated call from National Bank Security Dept, \(timeString) elapsed")
    }
}

// MARK: - Audio Indicator Row
private struct AudioIndicatorRow: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "speaker.wave.2.fill")
                .font(.system(size: 16))
                .foregroundColor(Color.silverSecondaryText)
            Text("Listening to simulated audio")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color.silverSecondaryText)
            Spacer()
            // Waveform bars
            HStack(spacing: 3) {
                ForEach(0..<5, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.silverPrimaryContainer)
                        .frame(width: 4, height: animating ? CGFloat.random(in: 8...20) : 8)
                        .animation(
                            .easeInOut(duration: 0.4).repeatForever().delay(Double(i) * 0.1),
                            value: animating
                        )
                }
            }
            .frame(height: 20)
        }
        .padding(.vertical, 8)
        .onAppear { animating = true }
        .accessibilityLabel("Listening to simulated audio")
        .accessibilityHidden(true)
    }
}

// MARK: - Sim Message Model
struct SimMessage: Identifiable {
    let id: Int
    let speaker: String
    let text: String
    var boldSegment: String? = nil
    var trailingText: String? = nil
    let isRedFlag: Bool
}

// MARK: - Sim Choice Model
struct SimChoice: Identifiable {
    let id: String
    let text: String
    let isCorrect: Bool
}

// MARK: - Simulation Message View
private struct SimMessageView: View {
    let message: SimMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Speaker label
            HStack(spacing: 6) {
                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color.silverSecondaryText)
                Text("Caller: \"\(message.speaker)\"")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.silverSecondaryText)
            }

            // Message bubble
            Group {
                if let bold = message.boldSegment, let trail = message.trailingText {
                    Text(message.text)
                        + Text(bold).bold().foregroundColor(Color.silverDanger)
                        + Text(trail)
                } else {
                    Text(message.text)
                }
            }
            .font(SilverGuardTypography.bodyLG)
            .foregroundColor(Color.silverText)
            .fixedSize(horizontal: false, vertical: true)
            .padding(SGSpacing.md)
            .background(Color.silverSurface)
            .clipShape(RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous)
                    .stroke(Color.silverBorder, lineWidth: 2)
            )
        }
    }
}

// MARK: - Red Flag Card
private struct RedFlagCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.silverDanger)
                Text("Red Flag: Extreme Panic & Secret PIN Demand")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.silverDanger)
                    .fixedSize(horizontal: false, vertical: true)
            }

            (Text("Real banks will ")
             + Text("never").bold()
             + Text(" ask for your secret 4-digit PIN over the phone. Urgency and panic are weapons scammers use to stop you from thinking clearly."))
                .font(SilverGuardTypography.bodyLG)
                .foregroundColor(Color(hex: "7C1600"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(SGSpacing.md)
        .background(Color.silverDangerContainer)
        .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                .stroke(Color.silverDanger.opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - Safe Move Section
private struct SafeMoveSection: View {
    let choices: [SimChoice]
    @Binding var selectedAnswer: String?
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("What is your safe move?")
                    .font(SilverGuardTypography.headlineMD)
                    .foregroundColor(Color.silverText)
                Spacer()
                Text("Tap one\noption")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.silverSecondaryText)
                    .multilineTextAlignment(.trailing)
            }

            ForEach(choices) { choice in
                SafeMoveButton(choice: choice,
                               isSelected: selectedAnswer == choice.id,
                               action: { onSelect(choice.id) })
            }
        }
    }
}

// MARK: - Safe Move Button
private struct SafeMoveButton: View {
    let choice: SimChoice
    let isSelected: Bool
    let action: () -> Void

    private var bgColor: Color {
        guard isSelected else { return Color.silverSurface }
        return choice.isCorrect ? Color.silverPrimaryContainer : Color.silverSurface
    }
    private var borderColor: Color {
        guard isSelected else { return Color.silverBorder }
        return choice.isCorrect ? Color.silverPrimaryContainer : Color.silverDanger
    }
    private var textColor: Color {
        guard isSelected else { return Color.silverText }
        return choice.isCorrect ? .white : Color.silverDanger
    }
    private var iconName: String {
        if isSelected {
            return choice.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"
        }
        return choice.isCorrect ? "checkmark.circle" : "xmark.circle"
    }
    private var iconColor: Color {
        if isSelected {
            return choice.isCorrect ? .white : Color.silverDanger
        }
        return Color.silverSecondaryText
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(iconColor)

                Text(choice.text)
                    .font(SilverGuardTypography.bodyXL)
                    .foregroundColor(textColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected && choice.isCorrect ? Color.white.opacity(0.7) : Color.silverOutline)
            }
            .padding(SGSpacing.md)
            .frame(minHeight: 72)
            .background(
                RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                    .fill(bgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                            .stroke(borderColor, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .silverCardShadow()
        .accessibilityLabel(choice.text)
        .accessibilityHint(isSelected ? (choice.isCorrect ? "Correct answer" : "Incorrect answer") : "Tap to select")
    }
}

// MARK: - Simulation Result Completion Sheet
private struct SimulationResultSheet: View {
    let isCorrect: Bool
    let score: Int
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(isCorrect ? Color.silverSafeContainer : Color.silverWarningContainer)
                    .frame(width: 80, height: 80)
                Image(systemName: isCorrect ? "checkmark.shield.fill" : "shield.slash.fill")
                    .font(.system(size: 40))
                    .foregroundColor(isCorrect ? Color.silverSafe : Color.silverWarning)
            }
            .padding(.top, 28)

            Text(isCorrect ? "Safe Move Confirmed!" : "Review & Practice Again")
                .font(SilverGuardTypography.headlineLG)
                .foregroundColor(Color.silverText)

            Text(isCorrect ? "You recognized the pressure tactic immediately. Real banks will never demand your private 4-digit PIN over the phone." : "Urgency is a weapon scammers use to induce panic. Remember the Golden Rule: Stop, Hang Up, and Call the number on the back of your card.")
                .font(SilverGuardTypography.bodyLG)
                .foregroundColor(Color.silverSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SGSpacing.gutter)

            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(Color.silverWarning)
                Text("+\(score) Safety Points Recorded")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.silverPrimaryContainer)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.silverPracticeBackground))

            PrimaryButton(title: "Return to Practices", action: onDismiss)
                .padding(.horizontal, SGSpacing.gutter)
                .padding(.top, 8)

            Spacer()
        }
        .presentationDetents([.medium])
        .background(Color.silverBackground.ignoresSafeArea())
    }
}

// MARK: - Preview
struct LiveSimulationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LiveSimulationView(scenario: Scenario.featuredScenario, state: PracticeState())
        }
    }
}
