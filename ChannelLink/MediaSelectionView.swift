import SwiftUI
import PhotosUI
import Photos

struct MediaSelectionView: View {
    @Binding var selectedMedia: [MediaItem]
    let onNext: () -> Void

    @State private var showingPicker = false
    @State private var showingPaywall = false
    @State private var showingPermissionAlert = false
    @EnvironmentObject var storeManager: StoreManager

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(.systemBackground), Color.blue.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    if selectedMedia.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "link.circle.fill")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.blue, Color.cyan],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            Text("Channel Link")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.blue, Color.cyan],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }

                        Text("Create & Share Amazing Video Compilations")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                } else {
                    Text("Tap and hold to rearrange videos")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 40)

            Spacer()

            if selectedMedia.isEmpty {
                VStack(spacing: 32) {
                    // Icon with animated gradient background
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.2), Color.cyan.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.1), Color.cyan.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 180, height: 180)

                        Image(systemName: "video.badge.plus")
                            .font(.system(size: 56, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }

                    VStack(spacing: 12) {
                        Text("Select Videos to Compile")
                            .font(.title2.bold())

                        Text("Combine multiple videos with smooth transitions\nand upload directly to YouTube")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
            } else {
                VStack(spacing: 12) {
                    HStack {
                        Text("\(selectedMedia.count) item\(selectedMedia.count == 1 ? "" : "s") selected")
                            .font(.headline)

                        if !storeManager.isPro {
                            Text("(10 max)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(Array(selectedMedia.enumerated()), id: \.element.id) { index, item in
                                if let thumbnail = item.thumbnail {
                                    ZStack {
                                        Image(uiImage: thumbnail)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                            .overlay(
                                                Button(action: {
                                                    removeItem(item)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.white)
                                                        .background(Circle().fill(Color.black.opacity(0.6)))
                                                }
                                                .padding(4),
                                                alignment: .topTrailing
                                            )
                                            .overlay(
                                                Text("\(index + 1)")
                                                    .font(.caption2.bold())
                                                    .foregroundColor(.white)
                                                    .padding(4)
                                                    .background(Circle().fill(Color.black.opacity(0.7)))
                                                    .padding(4),
                                                alignment: .topLeading
                                            )
                                            .onDrag {
                                                let provider = NSItemProvider(object: item.id.uuidString as NSString)
                                                provider.suggestedName = item.id.uuidString
                                                return provider
                                            }
                                            .onDrop(of: [.text], delegate: DropViewDelegate(
                                                destinationItem: item,
                                                selectedMedia: $selectedMedia
                                            ))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 400)
                }
            }

            Spacer()

            VStack(spacing: 12) {
                Button(action: {
                    requestPhotoLibraryAccess()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: selectedMedia.isEmpty ? "video.badge.plus" : "plus.circle.fill")
                            .font(.title3)

                        Text(selectedMedia.isEmpty ? "Select Videos" : "Add More Videos")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 24)

                if !selectedMedia.isEmpty {
                    Button(action: onNext) {
                        HStack(spacing: 12) {
                            Text("Continue")
                                .font(.headline)

                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.green, Color.green.opacity(0.85)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.green.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showingPicker) {
            PhotoPicker(selectedMedia: $selectedMedia, storeManager: storeManager, showPaywall: $showingPaywall)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
                .environmentObject(storeManager)
        }
        .alert("Photo Access Required", isPresented: $showingPermissionAlert) {
            Button("Open Settings", action: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow Channel Link to access your videos in Settings to create compilations.")
        }
    }

    private func requestPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            showingPicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        showingPicker = true
                    } else {
                        showingPermissionAlert = true
                    }
                }
            }
        case .denied, .restricted:
            showingPermissionAlert = true
        @unknown default:
            showingPermissionAlert = true
        }
    }

    private func removeItem(_ item: MediaItem) {
        selectedMedia.removeAll { $0.id == item.id }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedMedia: [MediaItem]
    let storeManager: StoreManager
    @Binding var showPaywall: Bool
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .videos
        config.selectionLimit = 0 // unlimited
        config.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()

            guard !results.isEmpty else { return }

            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .highQualityFormat

            for result in results {
                if let assetIdentifier = result.assetIdentifier {
                    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
                    if let asset = fetchResult.firstObject {
                        // Check if already selected
                        if !parent.selectedMedia.contains(where: { $0.asset.localIdentifier == asset.localIdentifier }) {

                            // Check photo limit for free users
                            if !parent.storeManager.isPro && parent.selectedMedia.count >= 10 {
                                DispatchQueue.main.async {
                                    self.parent.showPaywall = true
                                }
                                return
                            }

                            let mediaItem = MediaItem(asset: asset)

                            // Load thumbnail
                            imageManager.requestImage(
                                for: asset,
                                targetSize: CGSize(width: 200, height: 200),
                                contentMode: .aspectFill,
                                options: requestOptions
                            ) { image, _ in
                                if let image = image {
                                    DispatchQueue.main.async {
                                        if let index = self.parent.selectedMedia.firstIndex(where: { $0.asset.localIdentifier == asset.localIdentifier }) {
                                            self.parent.selectedMedia[index].thumbnail = image
                                        }
                                    }
                                }
                            }

                            parent.selectedMedia.append(mediaItem)
                        }
                    }
                }
            }
        }
    }
}

struct DropViewDelegate: DropDelegate {
    let destinationItem: MediaItem
    @Binding var selectedMedia: [MediaItem]

    func performDrop(info: DropInfo) -> Bool {
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func dropEntered(info: DropInfo) {
        guard let fromIndex = selectedMedia.firstIndex(where: { item in
            item.id.uuidString == info.itemProviders(for: [.text]).first?.suggestedName
        }) else {
            return
        }

        guard let toIndex = selectedMedia.firstIndex(where: { $0.id == destinationItem.id }) else {
            return
        }

        if fromIndex != toIndex {
            withAnimation {
                let fromItem = selectedMedia[fromIndex]
                selectedMedia.remove(at: fromIndex)
                selectedMedia.insert(fromItem, at: toIndex)
            }
        }
    }
}
