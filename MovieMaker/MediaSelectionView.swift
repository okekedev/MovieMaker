import SwiftUI
import PhotosUI
import Photos

struct MediaSelectionView: View {
    @Binding var selectedMedia: [MediaItem]
    let onNext: () -> Void

    @State private var showingPicker = false
    @State private var showingPaywall = false
    @State private var showingPermissionAlert = false
    @State private var showingSettings = false
    @State private var selectedMediaItemForTrimming: MediaItem?
    @EnvironmentObject var storeManager: StoreManager
    @State private var pulseOpacity: Double = 1.0
    @State private var timer: Timer?
    @State private var secretTapCount: Int = 0

    var body: some View {
        ZStack {
            background
            
            VStack(spacing: 0) {
                headerView
                Spacer()
                mainContent
                Spacer()
                bottomBar
            }
            if showingSettings {
                AppConfigurationView(isPresented: $showingSettings)
            }

            // Secret Pro unlock - only visible on empty state
            if selectedMedia.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Button(action: handleSecretTap) {
                            Text("🤖")
                                .font(.system(size: 24))
                                .opacity(0.01)
                        }
                        .buttonStyle(.plain)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $showingPicker) {
            PhotoPicker(selectedMedia: $selectedMedia, storeManager: storeManager, showPaywall: $showingPaywall)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
                .environmentObject(storeManager)
        }
        .fullScreenCover(item: $selectedMediaItemForTrimming) { item in
            TrimmingView(mediaItem: $selectedMedia[selectedMedia.firstIndex(where: { $0.id == item.id })!])
                .environmentObject(storeManager)
        }
        .alert("Photo Access Required", isPresented: $showingPermissionAlert) {
            Button("Open Settings", action: openSystemSettings)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow Channel Link to access your videos in Settings to create compilations.")
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var background: some View {
        if selectedMedia.isEmpty {
            SnowfallView()
            LinearGradient(
                colors: [Color(.systemBackground), Color.brandAccent.opacity(0.1), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        } else {
            Color(.systemGroupedBackground).ignoresSafeArea()
        }
    }

    @ViewBuilder
    private var headerView: some View {
        if !selectedMedia.isEmpty {
            HStack {
                Button(action: { selectedMedia.removeAll() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 17, weight: .regular))
                    }
                    .foregroundColor(.primary)
                }
                .padding(.leading, 20)
                Spacer()
            }
            .frame(height: 60)
            .background(Color(.systemBackground))
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        if selectedMedia.isEmpty {
            VStack(spacing: 40) {
                Text("Movie Maker")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.primary)

                mainSelectionButton
            }
        } else {
            mediaGridView
        }
    }

    private var mainSelectionButton: some View {
        VStack(spacing: 24) {
            Button(action: requestPhotoLibraryAccess) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: Color.brandGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.brandSecondary.opacity(0.5), radius: 20, x: 0, y: 10)

                    Image(systemName: "plus")
                        .font(.system(size: 60, weight: .regular))
                        .foregroundColor(.white)
                }
                .opacity(pulseOpacity)
                .animation(.easeInOut(duration: 1.0), value: pulseOpacity)
            }

            Text("Tap to select videos")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }

    private var mediaGridView: some View {
        VStack(spacing: 24) {
            // Headline
            VStack(spacing: 8) {
                Text("Select Your Moments")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Text("Tap to edit  |  Hold to rearrange")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)

            if !storeManager.isPro && selectedMedia.count >= 8 {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    Text("Free plan: \(selectedMedia.count)/10 videos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(Array(selectedMedia.enumerated()), id: \.element.id) { index, item in
                        MediaGridItemView(item: item, index: index, selectedMedia: $selectedMedia, selectedMediaItemForTrimming: $selectedMediaItemForTrimming) {
                            removeItem(item)
                        }
                    }
                    // Add a "+" button at the end of the list
                    AddMediaButton {
                        requestPhotoLibraryAccess() // This will add to the end
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(maxHeight: 500)
        }
    }

    private var bottomBar: some View {
        ZStack {
            if !selectedMedia.isEmpty {
                Button(action: onNext) {
                    HStack(spacing: 8) {
                        Text("Continue")
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: Color.brandGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.brandSecondary.opacity(0.5), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 40)
    }

    // MARK: - Functions
    
    private func startTimer() {
        stopTimer() // Ensure no duplicate timers
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            pulseOpacity = (pulseOpacity == 1.0) ? 0.7 : 1.0
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func handleSecretTap() {
        secretTapCount += 1

        if secretTapCount >= 5 {
            // Unlock Pro features
            storeManager.isPro = true
            secretTapCount = 0
            print("🤖 Secret Pro unlock activated!")
        }
    }

    private func openSystemSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
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

// MARK: - Sub-structs for complex parts

struct MediaGridItemView: View {
    let item: MediaItem
    let index: Int
    @Binding var selectedMedia: [MediaItem]
    @Binding var selectedMediaItemForTrimming: MediaItem?
    let onRemove: () -> Void

    @State private var orientationText: String? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            if let thumbnail = item.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 110, height: 110)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(removeButton, alignment: .topTrailing)
                    .overlay(indexIndicator, alignment: .topLeading)
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            }

            if let orientationText = orientationText {
                Text(orientationText)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(6)
                    .padding(.bottom, 6)
            }
        }
        .onAppear {
            // Determine orientation when the view appears
            let asset = item.asset
            if asset.pixelWidth < asset.pixelHeight {
                orientationText = "Portrait"
            } else if asset.pixelWidth > asset.pixelHeight {
                orientationText = "Landscape"
            } else {
                orientationText = "Square"
            }
        }
        .onDrag {
            let provider = NSItemProvider(object: item.id.uuidString as NSString)
            provider.suggestedName = item.id.uuidString
            return provider
        }
        .onDrop(of: [.text], delegate: MediaGridItemView.DropViewDelegate(destinationItem: item, selectedMedia: $selectedMedia))
        .onTapGesture {
            selectedMediaItemForTrimming = item
        }
    }

    private var removeButton: some View {
        Button(action: onRemove) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.7))
                    .frame(width: 28, height: 28)
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(6)
    }

    private var indexIndicator: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.8))
                .frame(width: 28, height: 28)
            Text("\(index + 1)")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(6)
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
}

// MARK: - AddMediaButton
struct AddMediaButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(width: 110, height: 110)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                VStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                    Text("Add More")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
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

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

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