//
//  DailySpinView.swift
//  MovieMaker
//
//  Casino-style 3-reel daily spin.
//     • 3 coins align → jackpot (+2 coins), 1/16 (6.25%) chance
//     • 2 coins align → prize (+1 coin), 1/4 (25%) chance
//     • no alignment  → try again tomorrow
//     • first-ever spin: guaranteed jackpot (seeds new users at 3 total)
//

import SwiftUI

struct DailySpinView: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.dismiss) var dismiss

    @State private var phase: SpinPhase = .idle
    @State private var reels: [Int] = [0, 0, 0]           // current index per reel
    @State private var finalReels: [String] = ["🪙", "🪙", "🪙"]  // reveal state
    @State private var result: StoreManager.SpinResult?
    @State private var timers: [Timer?] = [nil, nil, nil]
    @State private var confettiTrigger: Int = 0

    enum SpinPhase { case idle, spinning, revealed }

    /// Reel symbols. Coin is the "win" symbol; others are "no-win" fillers.
    private let symbols = ["🪙", "🎬", "🎥", "⭐️", "🎉", "🌟"]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: Color.brandGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 26) {
                Spacer()

                Text("Daily Spin")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                subtitleView

                slotMachine

                actionArea

                Spacer()

                Button("Close") { dismiss() }
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 30)
            }

            // Confetti overlay for wins. Triggered by incrementing confettiTrigger.
            ConfettiBurst(trigger: confettiTrigger)
                .ignoresSafeArea()
        }
        .onDisappear { timers.forEach { $0?.invalidate() } }
    }

    /// Subtitle line. Uses inline GoldCoin views for the "3 [coin] = jackpot"
    /// hint so the coin symbols in the label match the reels.
    @ViewBuilder
    private var subtitleView: some View {
        Group {
            switch phase {
            case .idle where !storeManager.canSpinNow:
                Text("Come back tomorrow for another spin")
            case .revealed:
                switch result {
                case .win(let n):
                    HStack(spacing: 6) {
                        Text("You won")
                        Text("+\(n)")
                            .fontWeight(.bold)
                        GoldCoin(size: 20)
                        Text(n == 1 ? "coin!" : "coins!")
                    }
                case .lose:
                    Text("So close! Try again tomorrow")
                case .none:
                    Text("")
                }
            default:
                HStack(spacing: 6) {
                    Text("3")
                    GoldCoin(size: 18)
                    Text("= jackpot")
                    Text("·")
                    Text("2")
                    GoldCoin(size: 18)
                    Text("= prize")
                }
            }
        }
        .font(.system(size: 14))
        .foregroundColor(.white.opacity(0.9))
        .padding(.horizontal, 32)
    }

    private var slotMachine: some View {
        HStack(spacing: 12) {
            ForEach(0..<3, id: \.self) { i in
                reelCell(index: i)
            }
        }
        .padding(.horizontal, 24)
    }

    private func reelCell(index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.4), lineWidth: 2)
                )

            symbolView(currentSymbol(for: index))
        }
        .frame(width: 92, height: 110)
    }

    private func currentSymbol(for reelIndex: Int) -> String {
        switch phase {
        case .idle:
            return "🪙"
        case .spinning:
            return symbols[reels[reelIndex] % symbols.count]
        case .revealed:
            return finalReels[reelIndex]
        }
    }

    /// Renders a reel symbol. The "coin" marker uses our branded SVG-style
    /// gold-coin view; everything else falls back to native emoji glyphs.
    @ViewBuilder
    private func symbolView(_ s: String) -> some View {
        if s == "🪙" {
            GoldCoin(size: 68)
        } else {
            Text(s).font(.system(size: 60))
        }
    }

    @ViewBuilder
    private var actionArea: some View {
        switch phase {
        case .idle:
            if storeManager.canSpinNow {
                Button(action: spin) {
                    Text("Spin")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(colors: Color.primaryGradient,
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 220, height: 54)
                        .background(Color.white)
                        .cornerRadius(14)
                }
            } else {
                EmptyView()
            }
        case .spinning:
            Text("Rolling…")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.85))
        case .revealed:
            Button(action: { dismiss() }) {
                Text(result.map {
                    if case .win = $0 {
                        return NSLocalizedString("Awesome", comment: "Daily-spin dismiss after a win")
                    } else {
                        return NSLocalizedString("Continue", comment: "Daily-spin dismiss after a miss")
                    }
                } ?? NSLocalizedString("Continue", comment: "Daily-spin dismiss default"))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: Color.primaryGradient,
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 220, height: 54)
                    .background(Color.white)
                    .cornerRadius(14)
            }
        }
    }

    private func spin() {
        let outcome = storeManager.performSpin()
        result = outcome

        // Decide the final reel state based on outcome.
        //   .win(2) → all three coins
        //   .win(1) → two coins + one random non-coin
        //   .lose   → no two-coin alignment (0 or 1 coin, in scattered positions)
        finalReels = finalStateFor(outcome)

        // Precompute each reel's target index in `symbols` so the last shown
        // frame matches the reveal. Avoids the "snap" from a random symbol.
        let targetIndexes: [Int] = finalReels.map { s in
            symbols.firstIndex(of: s) ?? 0
        }

        phase = .spinning

        // Ticks per reel — reel 1 lands first, then 2, then 3.
        let ticksToStop: [Int] = [18, 26, 34]

        for reelIdx in 0..<3 {
            var step = 0
            timers[reelIdx]?.invalidate()
            timers[reelIdx] = Timer.scheduledTimer(withTimeInterval: 0.075, repeats: true) { t in
                step += 1

                let remaining = ticksToStop[reelIdx] - step
                if remaining > 6 {
                    // Fast tumbling phase — cycle at full speed.
                    reels[reelIdx] &+= 1
                } else if remaining > 0 {
                    // Deceleration phase — walk each step *toward* the target
                    // so the reel visibly ratchets into place, no snap.
                    let current = reels[reelIdx] % symbols.count
                    // Distance in forward direction (never go backward).
                    let target = targetIndexes[reelIdx]
                    let distanceForward = (target - current + symbols.count) % symbols.count
                    let stepSize: Int
                    if distanceForward == 0 {
                        // Already on target early — advance a full cycle so
                        // the visual doesn't freeze while other reels finish.
                        stepSize = symbols.count
                    } else {
                        // Aim to arrive exactly at `remaining` == 0.
                        stepSize = max(1, distanceForward / max(1, remaining))
                    }
                    reels[reelIdx] &+= stepSize
                } else {
                    // Snap to target, invalidate. `reels % symbols.count`
                    // now equals targetIndexes[reelIdx] so the cell is
                    // showing the final symbol *before* phase changes.
                    let current = reels[reelIdx] % symbols.count
                    if current != targetIndexes[reelIdx] {
                        reels[reelIdx] &+= (targetIndexes[reelIdx] - current + symbols.count) % symbols.count
                    }
                    t.invalidate()
                    if reelIdx == 2 {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                            phase = .revealed
                        }
                        if case .win = result {
                            confettiTrigger &+= 1
                        }
                    }
                }
            }
        }
    }

    private func finalStateFor(_ outcome: StoreManager.SpinResult) -> [String] {
        let coin = "🪙"
        let others = symbols.filter { $0 != coin }

        switch outcome {
        case .win(let n) where n >= 2:
            return [coin, coin, coin]
        case .win:
            // +1 coin → two coins align. Randomize which two positions.
            let noncoin = others.randomElement()!
            let missing = Int.random(in: 0..<3)
            return (0..<3).map { $0 == missing ? noncoin : coin }
        case .lose:
            // Zero or one coin, non-adjacent. To keep it visually "close",
            // pick one coin + two different non-coins.
            let coinPos = Int.random(in: 0..<3)
            let a = others.randomElement()!
            let b = others.filter { $0 != a }.randomElement()!
            return (0..<3).map { i in
                if i == coinPos { return coin }
                return (i < coinPos) ? a : b
            }
        }
    }
}
