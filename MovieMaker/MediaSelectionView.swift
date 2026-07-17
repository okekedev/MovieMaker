import SwiftUI
import PhotosUI
import Photos

struct MediaSelectionView: View {
    @Binding var selectedMedia: [MediaItem]
    @Binding var orientation: VideoOrientation
    let onNext: () -> Void

    // MM_SHOW_PICKER=1 → open the photo picker on launch (screenshot capture; see
    // the env-var block in ChannelLinkApp.swift). Grant photo permission first via
    // `simctl privacy <UDID> grant photos <bundle.id>` so no permission alert races the sheet.
    @State private var showingPicker = ProcessInfo.processInfo.environment["MM_SHOW_PICKER"] == "1"
    @State private var showingPaywall = false
    @State private var showingDailySpin = false
    @State private var showingPermissionAlert = false
    @State private var showingSettings = false
    @State private var selectedMediaItemForTrimming: MediaItem?
    @State private var selectedMediaItemForPhotoEdit: MediaItem?
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
        .fullScreenCover(isPresented: $showingPaywall) {
            PaywallView()
                .environmentObject(storeManager)
        }
        .sheet(isPresented: $showingDailySpin) {
            DailySpinView()
                .environmentObject(storeManager)
        }
        .fullScreenCover(item: $selectedMediaItemForTrimming) { item in
            TrimmingView(
                mediaItem: $selectedMedia[selectedMedia.firstIndex(where: { $0.id == item.id })!],
                orientation: $orientation,
                onSplit: { splitTime in
                    guard let i = selectedMedia.firstIndex(where: { $0.id == item.id }) else { return }
                    let originalEndTime = selectedMedia[i].endTime
                    let firstStart = selectedMedia[i].startTime
                    selectedMedia[i].endTime = splitTime

                    var newItem = MediaItem(
                        asset: selectedMedia[i].asset,
                        thumbnail: selectedMedia[i].thumbnail,
                        startTime: splitTime,
                        endTime: originalEndTime,
                        isMuted: selectedMedia[i].isMuted
                    )
                    // Slow-mo stripped on split — the window would misalign against the new bounds.
                    newItem.slowMoStartTime = nil
                    newItem.slowMoEndTime = nil
                    // Crop is a per-frame transform, not a time window — safe to carry across.
                    newItem.cropRect = selectedMedia[i].cropRect

                    selectedMedia.insert(newItem, at: i + 1)

                    // Regenerate thumbnails from actual frames so the two halves
                    // are visually distinguishable in the collection grid.
                    let phAsset = selectedMedia[i].asset
                    let firstId = selectedMedia[i].id
                    let secondId = newItem.id
                    let firstMid = CMTimeMultiplyByFloat64(CMTimeAdd(firstStart, splitTime), multiplier: 0.5)
                    Task {
                        async let firstThumb = MediaSelectionView.thumbnail(from: phAsset, at: firstMid)
                        async let secondThumb = MediaSelectionView.thumbnail(from: phAsset, at: splitTime)
                        let (t1, t2) = await (firstThumb, secondThumb)
                        await MainActor.run {
                            if let t1 = t1, let idx = selectedMedia.firstIndex(where: { $0.id == firstId }) {
                                selectedMedia[idx].thumbnail = t1
                            }
                            if let t2 = t2, let idx = selectedMedia.firstIndex(where: { $0.id == secondId }) {
                                selectedMedia[idx].thumbnail = t2
                            }
                        }
                    }
                }
            )
                .environmentObject(storeManager)
        }
        .fullScreenCover(item: $selectedMediaItemForPhotoEdit) { item in
            PhotoEditorView(
                mediaItem: $selectedMedia[selectedMedia.firstIndex(where: { $0.id == item.id })!],
                orientation: $orientation
            )
        }
        .alert("Photo Access Required", isPresented: $showingPermissionAlert) {
            Button("Open Settings", action: openSystemSettings)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow Movie Maker to access your videos and photos in Settings to create compilations.")
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
        // Header is intentionally empty — Coin/Spin removed for a quieter
        // top area. Coin buy sheet still opens via the paywall path when the
        // user hits the coin gate on export. Daily spin can be surfaced
        // elsewhere (e.g., a settings menu) when needed.
        HStack { Spacer() }
            .frame(height: 12)
            .background(Color.clear)
    }

    @ViewBuilder
    private var mainContent: some View {
        if selectedMedia.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "arrow.down")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.brandAccent)
                    .offset(y: pulseOpacity == 1.0 ? 0 : 8)
                    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulseOpacity)

                mainSelectionButton
            }
        } else {
            mediaGridView
        }
    }

    private var mainSelectionButton: some View {
        VStack(spacing: 24) {
            Button(action: requestPhotoLibraryAccess) {
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .shadow(color: Color.brandPrimary.opacity(0.35), radius: 24, x: 0, y: 12)
                .opacity(pulseOpacity)
                .animation(.easeInOut(duration: 1.0), value: pulseOpacity)
            }

        }
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }

    private var mediaGridView: some View {
        VStack(spacing: 16) {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 14),
                        GridItem(.flexible(), spacing: 14)
                    ],
                    spacing: 14
                ) {
                    ForEach(Array(selectedMedia.enumerated()), id: \.element.id) { index, item in
                        MediaGridItemView(
                            item: item,
                            index: index,
                            selectedMedia: $selectedMedia,
                            selectedMediaItemForTrimming: $selectedMediaItemForTrimming,
                            selectedMediaItemForPhotoEdit: $selectedMediaItemForPhotoEdit
                        ) {
                            removeItem(item)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 20) {
            if !selectedMedia.isEmpty {
                mediaActionCircle(icon: "chevron.backward", tint: .brandPrimary, filled: false) {
                    selectedMedia.removeAll()
                }
                mediaActionCircle(icon: "plus", tint: .brandPrimary, filled: false) {
                    requestPhotoLibraryAccess()
                }
                mediaActionCircle(icon: "checkmark", tint: .white, filled: true, action: onNext)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 40)
    }

    @ViewBuilder
    private func mediaActionCircle(icon: String, tint: Color, filled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(tint)
                .frame(width: 72, height: 72)
                .background(
                    Group {
                        if filled {
                            LinearGradient(colors: Color.brandGradient, startPoint: .leading, endPoint: .trailing)
                        } else {
                            Color.brandPrimary.opacity(0.12)
                        }
                    }
                )
                .clipShape(Circle())
                .shadow(color: filled ? Color.brandSecondary.opacity(0.4) : .clear, radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
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

    /// Extract a UIImage frame from a PHAsset video at the given time — used
    /// to give each half of a split its own visually-distinct grid thumbnail.
    static func thumbnail(from asset: PHAsset, at time: CMTime) async -> UIImage? {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = true

        let avAsset: AVAsset? = await withCheckedContinuation { continuation in
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
                continuation.resume(returning: avAsset)
            }
        }
        guard let avAsset = avAsset else { return nil }

        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 220, height: 220)
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero

        return await withCheckedContinuation { continuation in
            generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, _, _ in
                if let cgImage = cgImage {
                    continuation.resume(returning: UIImage(cgImage: cgImage))
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}

// MARK: - Sub-structs for complex parts

struct MediaGridItemView: View {
    let item: MediaItem
    let index: Int
    @Binding var selectedMedia: [MediaItem]
    @Binding var selectedMediaItemForTrimming: MediaItem?
    @Binding var selectedMediaItemForPhotoEdit: MediaItem?
    let onRemove: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            if let thumbnail = item.thumbnail {
                // Square tile via Color.clear.aspectRatio + overlay — the
                // classic SwiftUI "aspect-fill inside a fixed aspect frame"
                // pattern. Direct chaining of .aspectRatio on Image doesn't
                // reliably square the container, hence the wrapper.
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Image(uiImage: thumbnail)
                            .resizable()
                            .scaledToFill()
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(indexIndicator, alignment: .topTrailing)
                    .overlay(removeButton, alignment: .topLeading)
                    .overlay(aspectLabel, alignment: .bottomLeading)
                    .overlay(editIndicator, alignment: .bottomTrailing)
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            }

        }
        // Make the whole tile rect hit-testable — the Color.clear inside the
        // ZStack isn't tappable by default, so onTapGesture would only fire
        // in overlay areas otherwise.
        .contentShape(Rectangle())
        .onTapGesture {
            // Videos → full TrimmingView editor. Photos → simpler
            // PhotoEditorView with just duration/zoom/aspect.
            if item.asset.mediaType == .video {
                selectedMediaItemForTrimming = item
            } else {
                selectedMediaItemForPhotoEdit = item
            }
        }
        .onDrag {
            let provider = NSItemProvider(object: item.id.uuidString as NSString)
            provider.suggestedName = item.id.uuidString
            return provider
        }
        .onDrop(of: [.text], delegate: MediaGridItemView.DropViewDelegate(destinationItem: item, selectedMedia: $selectedMedia))
    }

    /// Small aspect ratio label (e.g. "16:9", "9:16", "4:3") in the bottom-
    /// left corner. Simplifies via GCD when possible.
    @ViewBuilder
    private var aspectLabel: some View {
        Text(aspectRatioText(width: item.asset.pixelWidth, height: item.asset.pixelHeight))
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.black.opacity(0.65))
            .clipShape(Capsule())
            .padding(6)
    }

    /// Pencil edit indicator in bottom-right — visual affordance that the
    /// tile is tappable to edit. Tint switches to brand-accent when a crop
    /// is applied so the two states are visible in one glyph.
    @ViewBuilder
    private var editIndicator: some View {
        let hasCrop = item.cropRect != nil
        Image(systemName: "square.and.pencil")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(Circle().fill(hasCrop ? Color.brandAccent : Color.black.opacity(0.65)))
            .padding(6)
    }

    /// Snap to the nearest common aspect ratio; fall back to a fuzzy label
    /// like "~3:2" if the source is far off any standard.
    private func aspectRatioText(width: Int, height: Int) -> String {
        guard width > 0, height > 0 else { return "?" }
        let ratio = Double(width) / Double(height)
        let common: [(label: String, value: Double)] = [
            ("16:9", 16.0/9),   ("9:16", 9.0/16),
            ("4:3",  4.0/3),    ("3:4",  3.0/4),
            ("3:2",  3.0/2),    ("2:3",  2.0/3),
            ("1:1",  1.0),
            ("21:9", 21.0/9),   ("9:21", 9.0/21),
            ("5:4",  5.0/4),    ("4:5",  4.0/5),
        ]
        let tolerance = 0.02
        if let match = common.min(by: { abs($0.value - ratio) < abs($1.value - ratio) }),
           abs(match.value - ratio) <= tolerance {
            return match.label
        }
        // No standard match — show simplified via GCD, but cap to 3 digits each.
        var a = width, b = height
        while b != 0 { (a, b) = (b, a % b) }
        let g = max(1, a)
        let simpW = width / g, simpH = height / g
        if simpW < 100 && simpH < 100 {
            return "\(simpW):\(simpH)"
        }
        // Fall back to a decimal approximation for very unusual ratios.
        return String(format: "%.2f:1", ratio)
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
                .fill(
                    LinearGradient(
                        colors: Color.brandGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 34, height: 34)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
            Text("\(index + 1)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(8)
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
        config.filter = .any(of: [.videos, .images])
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
                            // Free tier no longer gates selection — users can build
                            // whatever they want and the paywall lands at export time.
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