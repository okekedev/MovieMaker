import SwiftUI

struct InformationView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(.systemBackground), Color.brandAccent.opacity(0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        Text("How It Works")
                            .font(.largeTitle.bold())
                            .foregroundStyle(
                                LinearGradient(
                                    colors: Color.primaryGradient,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .padding(.bottom, 10)

                        // Step 1: Select
                        FeatureView(
                            iconName: "video.badge.plus",
                            title: "1. Select Your Videos",
                            description: "Tap the upload icon to choose multiple videos from your photo library. You can add, remove, and reorder them as you like."
                        )

                        // Step 2: Trim
                        FeatureView(
                            iconName: "scissors",
                            title: "2. Trim Your Videos",
                            description: "Tap on any selected video to precisely trim its start and end points, ensuring only the best moments are included."
                        )

                        // Step 3: Compile
                        FeatureView(
                            iconName: "film.stack",
                            title: "3. Compile & Preview",
                            description: "Combine everything into a single, high-quality video file. Preview the final result before uploading."
                        )

                        // Step 4: Upload
                        FeatureView(
                            iconName: "arrow.up.forward.app",
                            title: "4. Upload to YouTube",
                            description: "Directly upload your finished video to your YouTube channel without ever leaving the app."
                        )
                    }
                    .padding(30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureView: View {
    let iconName: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.brandPrimary)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.bold())
                    .foregroundColor(.primary)

                Text(description)
                    .foregroundColor(.secondary)
                    .lineSpacing(3)
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
