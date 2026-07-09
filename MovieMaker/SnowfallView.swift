import SwiftUI

struct EmojiFlake: Identifiable {
    let id = UUID()
    var emoji: String
    var position: CGPoint
    var size: CGFloat
    var speed: CGFloat
    var opacity: Double
}

struct SnowfallView: View {
    @State private var flakes: [EmojiFlake] = []
    // Positive-only emoji set. Curated for the empty-state background —
    // upbeat, creative-tool-adjacent, and share-worthy.
    private let emojis = [
        // Happy faces
        "😀", "😃", "😄", "😊", "😍", "🥰", "😘", "😎", "🥳", "🤩", "🥸", "😇", "🙂", "🤗", "🤠", "🤓",
        // Positive gestures
        "👍", "👏", "🙌", "🙏", "💪", "✌️", "👌",
        // Celebration + success
        "🎉", "🎊", "🎈", "🎁", "⭐️", "🌟", "✨", "💫", "🔥", "💯", "✅", "🚀", "💡", "🏆", "🥇", "💰", "📈",
        // Hearts
        "❤️", "🧡", "💛", "💚", "💙", "💜", "💖", "💗", "💝", "💞",
        // Creative/media
        "🎬", "🎥", "📹", "📸", "🎨", "🎭", "🎵", "🎶",
        // Cute + nature
        "🐶", "🐱", "🦄", "🐼", "🦋", "🌈", "🌸", "🌺", "🌻", "🍀",
    ]

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    for flake in flakes {
                        let x = flake.position.x
                        let y = flake.position.y
                        context.opacity = flake.opacity
                        context.draw(
                            Text(flake.emoji).font(.system(size: flake.size)),
                            at: CGPoint(x: x, y: y)
                        )
                    }
                }
                .onChange(of: timeline.date) {
                    updateFlakes(in: geometry.size)
                }
            }
        }
        .onAppear {
            flakes = createInitialFlakes(in: UIScreen.main.bounds.size)
        }
    }

    private func createInitialFlakes(in size: CGSize) -> [EmojiFlake] {
        var initialFlakes: [EmojiFlake] = []
        for _ in 0..<50 {
            initialFlakes.append(createFlake(in: size, isInitial: true))
        }
        return initialFlakes
    }

    private func createFlake(in size: CGSize, isInitial: Bool = false) -> EmojiFlake {
        let emoji = emojis.randomElement()!
        let x = CGFloat.random(in: 0...size.width)
        let y = isInitial ? CGFloat.random(in: 0...size.height) : -20
        let size = CGFloat.random(in: 15...35)
        let speed = CGFloat.random(in: 1...3)
        let opacity = Double.random(in: 0.15...0.3)

        return EmojiFlake(
            emoji: emoji,
            position: CGPoint(x: x, y: y),
            size: size,
            speed: speed,
            opacity: opacity
        )
    }

    private func updateFlakes(in size: CGSize) {
        for i in 0..<flakes.count {
            flakes[i].position.y += flakes[i].speed
            
            // Reset flake if it goes off screen
            if flakes[i].position.y > size.height + 20 {
                flakes[i] = createFlake(in: size)
            }
        }
        
        // Add new flakes periodically
        if flakes.count < 80 && Int.random(in: 0...10) == 0 {
            flakes.append(createFlake(in: size))
        }
    }
}
