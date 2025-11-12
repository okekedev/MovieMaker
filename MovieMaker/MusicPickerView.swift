import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct MusicPickerView: View {
    @Binding var selectedMusicTitle: String
    @Binding var musicAsset: AVURLAsset?
    @Environment(\.dismiss) var dismiss

    @State private var showingDocumentPicker = false

    var body: some View {
        // Directly present the DocumentPicker when this view appears
        Text("") // Empty text view as a placeholder for NavigationView content
            .onAppear {
                showingDocumentPicker = true
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(
                    selectedMusicTitle: $selectedMusicTitle,
                    musicAsset: $musicAsset,
                    onDismiss: {
                        dismiss()
                    }
                )
            }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedMusicTitle: String
    @Binding var musicAsset: AVURLAsset?
    let onDismiss: () -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        print("🎵 Creating DocumentPicker")
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [
                UTType.audio,
                UTType.mp3,
                UTType(filenameExtension: "m4a")!,
                UTType(filenameExtension: "wav")!,
                UTType(filenameExtension: "aac")!
            ],
            asCopy: true
        )
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        print("🎵 DocumentPicker delegate set to: \(context.coordinator)")
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
            print("🎵 Coordinator initialized")
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("🎵 documentPicker delegate called with \(urls.count) URLs")
            guard let url = urls.first else {
                print("❌ No URL in array")
                parent.onDismiss()
                return
            }

            print("🎵 Selected URL: \(url)")

            // File is already in our app's sandbox due to asCopy: true
            // No need for security-scoped resource access
            let musicTitle = url.deletingPathExtension().lastPathComponent
            let musicAsset = AVURLAsset(url: url)

            print("🎵 Music title: \(musicTitle)")
            print("🎵 Creating AVURLAsset from: \(url)")

            DispatchQueue.main.async {
                print("🎵 Setting music title to: \(musicTitle)")
                self.parent.selectedMusicTitle = musicTitle
                print("🎵 Setting music asset")
                self.parent.musicAsset = musicAsset
                print("✅ Music selection complete!")

                // Delay dismiss slightly to ensure bindings update
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.parent.onDismiss()
                }
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onDismiss()
        }
    }
}
