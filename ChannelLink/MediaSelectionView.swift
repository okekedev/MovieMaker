import SwiftUI
import PhotosUI
import Photos

struct MediaSelectionView: View {
    @Binding var selectedMedia: [MediaItem]
    let onNext: () -> Void

    @State private var showingPicker = false
    @State private var showingPaywall = false
    @State private var showingPermissionAlert = false
    @State private var showingInfo = false
    @State private var showingSettings = false
    @State private var settings = VideoCompilationSettings()
    @State private var selectedMediaItemForTrimming: MediaItem?
    @EnvironmentObject var storeManager: StoreManager
    @State private var pulseOpacity: Double = 1.0
    @State private var timer: Timer?

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
            .overlay(settingsOverlay, alignment: .bottomLeading)

            if showingSettings {
                AppConfigurationView(isPresented: $showingSettings)
            }
        }
        .sheet(isPresented: $showingPicker) {
            PhotoPicker(selectedMedia: $selectedMedia, storeManager: storeManager, showPaywall: $showingPaywall)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
                .environmentObject(storeManager)
        }
        .sheet(isPresented: $showingInfo) {
            InformationView()
        }
        .fullScreenCover(item: $selectedMediaItemForTrimming) { item in
            TrimmingView(mediaItem: $selectedMedia[selectedMedia.firstIndex(where: { $0.id == item.id })!])
        }
        .alert("Photo Access Required", isPresented: $showingPermissionAlert) {
            Button("Open Settings", action: openSettings)
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
            Color.white.ignoresSafeArea()
        }
    }

    @ViewBuilder
    private var headerView: some View {
        if !selectedMedia.isEmpty {
            VStack(spacing: 0) {
                HStack {
                    Button(action: { selectedMedia.removeAll() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    .padding(.leading)
                    Spacer()
                }
                .frame(height: 44)

                VStack(spacing: 4) {
                    Text("Tap and hold to rearrange")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Tap to edit")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 10)
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        if selectedMedia.isEmpty {
            mainSelectionButton
        } else {
            mediaGridView
        }
    }

    private var mainSelectionButton: some View {
        // This container isolates the button and its animation from the parent layout
        VStack {
            Button(action: requestPhotoLibraryAccess) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.brandPrimary.opacity(0.15), Color.brandSecondary.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)

                    Image(systemName: "video.badge.plus")
                        .font(.system(size: 80, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: Color.brandGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .opacity(pulseOpacity)
                .animation(.easeInOut(duration: 1.0), value: pulseOpacity)
            }
        }
        .frame(width: 200, height: 200)
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }

    private var mediaGridView: some View {
        VStack(spacing: 16) {
            if !storeManager.isPro && selectedMedia.count >= 8 {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    Text("Free plan: \(selectedMedia.count)/10 videos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
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
                .padding(.horizontal)
            }
            .frame(maxHeight: 400)
        }
    }

    private var bottomBar: some View {
        ZStack {
            if !selectedMedia.isEmpty {
                Button(action: onNext) {
                    HStack(spacing: 12) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color.brandSecondary, Color.brandAccent],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)
                    .shadow(color: Color.brandSecondary.opacity(0.5), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal, 24)
            } else {
                HStack {
                    Spacer()
                    Button(action: { showingInfo = true }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.6))
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.bottom, 36)
    }

    @ViewBuilder
    private var settingsOverlay: some View {
        if selectedMedia.isEmpty {
            HStack {
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.6))
                }
                .padding(.leading, 24)
                Spacer()
            }
            .padding(.bottom, 36)
        }
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

    private func openSettings() {
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
        ZStack(alignment: .bottom) { // Align content to bottom to place text below
            if let thumbnail = item.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)
                    .overlay(removeButton, alignment: .topTrailing)
                    .overlay(indexIndicator, alignment: .topLeading)
            }
            
            if let orientationText = orientationText {
                Text(orientationText)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(4)
                    .padding(.bottom, 4) // Small padding from the bottom edge of the thumbnail
            }
        }
        .onAppear {
            // Determine orientation when the view appears
            let asset = item.asset
            if asset.pixelWidth < asset.pixelHeight { // Corrected logic: Width < Height for Portrait
                orientationText = "Portrait"
            } else if asset.pixelWidth > asset.pixelHeight { // Corrected logic: Width > Height for Landscape
                orientationText = "Landscape"
            } else {
                orientationText = "Square" // Or handle as needed
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
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
                .background(Circle().fill(Color.black.opacity(0.6)))
        }
        .padding(4)
    }

    private var indexIndicator: some View {
        Text("\(index + 1)")
            .font(.caption2.bold())
            .foregroundColor(.white)
            .padding(4)
            .background(Circle().fill(Color.black.opacity(0.7)))
            .padding(4)
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
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
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