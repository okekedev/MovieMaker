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
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.onDismiss()
                return
            }

            // Start accessing the security-scoped resource
            guard url.startAccessingSecurityScopedResource() else {
                parent.onDismiss()
                return
            }

            defer { url.stopAccessingSecurityScopedResource() }

            // Copy to app's temp directory
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(url.pathExtension)

            do {
                try? FileManager.default.removeItem(at: tempURL)
                try FileManager.default.copyItem(at: url, to: tempURL)

                parent.selectedMusicTitle = url.deletingPathExtension().lastPathComponent
                parent.musicAsset = AVURLAsset(url: tempURL)
            } catch {
                print("Error copying music file: \(error)")
            }

            parent.onDismiss()
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onDismiss()
        }
    }
}
