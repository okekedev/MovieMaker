import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct MusicPickerView: View {
    @Binding var selectedMusicTitle: String
    @Binding var musicAsset: AVURLAsset?
    @Environment(\.dismiss) var dismiss

    @State private var showingDocumentPicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "music.note.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.pink, Color.orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("Add Background Music")
                        .font(.title2.bold())

                    Text("Select an audio file from your Files app or iCloud Drive")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Supported formats:")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)

                    HStack(spacing: 8) {
                        ForEach(["MP3", "M4A", "WAV", "AAC"], id: \.self) { format in
                            Text(format)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(.horizontal, 24)

                Button(action: {
                    showingDocumentPicker = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "folder.badge.plus")
                            .font(.title3)

                        Text("Browse Files")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color.pink, Color.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.pink.opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .navigationTitle("Background Music")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
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
