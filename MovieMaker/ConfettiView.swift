import SwiftUI

struct ConfettiBurst: View {
    let trigger: Int

    private let colors: [Color] = [
        Color.accentColor,
        Color(red: 0.98, green: 0.50, blue: 0.30),
        Color(red: 1.00, green: 0.85, blue: 0.20),
        Color(red: 0.95, green: 0.30, blue: 0.45),
        Color(red: 0.40, green: 0.75, blue: 0.95),
        Color(red: 0.85, green: 0.95, blue: 0.40),
        Color(red: 0.65, green: 0.45, blue: 0.95)
    ]

    var body: some View {
        ZStack {
            ForEach(0..<80, id: \.self) { i in
                ConfettiPiece(
                    index: i,
                    color: colors[i % colors.count],
                    trigger: trigger
                )
            }
        }
        .allowsHitTesting(false)
    }
}

private struct ConfettiPiece: View {
    let index: Int
    let color: Color
    let trigger: Int

    var body: some View {
        // BURST phase: radial direction, modest distance
        let angle = Double.random(in: 0...(.pi * 2))
        let distance = Double.random(in: 120...300)

        // FALL phase: gravity-dominated, well past initial burst
        let fall = Double.random(in: 520...780)

        // 3D tumble (X+Y axis rotation, like a flake flipping in air)
        let tumbleAxisX = Double.random(in: -1...1)
        let tumbleAxisY = Double.random(in: -1...1)
        let tumbleHz = Double.random(in: 0.8...2.0)

        // Z spin (gentle, not "ceiling fan")
        let spinDir: Double = Bool.random() ? 1 : -1
        let spinHz = Double.random(in: 0.3...0.8)

        let delay = Double.random(in: 0...0.04)
        let size = CGFloat.random(in: 7...11)
        let shape = index % 4

        Group {
            switch shape {
            case 0: Circle().fill(color)
            case 1: Rectangle().fill(color)
            case 2: RoundedRectangle(cornerRadius: 1).fill(color)
            default: Capsule().fill(color)
            }
        }
        .frame(width: size, height: size * 1.5) // non-square reads as flake
        .keyframeAnimator(initialValue: PieceState(), trigger: trigger) { content, state in
            content
                .rotation3DEffect(
                    .degrees(state.elapsed * tumbleHz * 360),
                    axis: (x: tumbleAxisX, y: tumbleAxisY, z: 0)
                )
                .rotation3DEffect(
                    .degrees(state.elapsed * spinHz * 360 * spinDir),
                    axis: (x: 0, y: 0, z: 1)
                )
                .offset(
                    x: cos(angle) * distance * state.spread,
                    y: sin(angle) * distance * state.spread + state.fall * fall
                )
                .opacity(state.opacity)
                .scaleEffect(state.scale)
        } keyframes: { _ in
            // Continuous "elapsed seconds" track for Hz-based rotation
            KeyframeTrack(\.elapsed) {
                LinearKeyframe(0, duration: delay)
                LinearKeyframe(2.2, duration: 2.2)
            }
            // BURST: fast outward explosion, finishes quickly
            KeyframeTrack(\.spread) {
                LinearKeyframe(0, duration: delay)
                CubicKeyframe(1, duration: 0.45)
            }
            // FALL: kicks in after burst completes, accelerating (gravity)
            KeyframeTrack(\.fall) {
                LinearKeyframe(0, duration: delay + 0.40)
                CubicKeyframe(1, duration: 1.6)
            }
            KeyframeTrack(\.opacity) {
                LinearKeyframe(0, duration: delay)
                LinearKeyframe(1, duration: 0.08)
                LinearKeyframe(1, duration: 1.5)
                LinearKeyframe(0, duration: 0.45)
            }
            KeyframeTrack(\.scale) {
                LinearKeyframe(0, duration: delay)
                CubicKeyframe(1, duration: 0.2)
            }
        }
    }
}

private struct PieceState {
    var elapsed: Double = 0   // seconds — drives Hz-based rotation
    var spread: Double = 0    // 0→1, burst radius progress
    var fall: Double = 0      // 0→1, gravity progress
    var opacity: Double = 0
    var scale: Double = 0
}
