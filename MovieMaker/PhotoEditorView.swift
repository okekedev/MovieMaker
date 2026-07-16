import SwiftUI
import Photos
import AVFoundation

/// Simple 3-tool editor for photo tiles: Duration, Zoom, Aspect ratio.
/// Uses the same icon-row + inline sub-tab pattern as TrimmingView, minus
/// everything video-specific (no timeline, trim, split, mute, speed).
struct PhotoEditorView: View {
    @Binding var mediaItem: MediaItem
    @Binding var orientation: VideoOrientation
    @Environment(\.dismiss) var dismiss

    private static let durationOptions: [Double] = [2, 3, 5, 10]

    @State private var expandedTool: PhotoTool?
    @State private var pendingDuration: Double = 5
    @State private var pendingCropRect: CGRect?
    @State private var activeZoom: CGFloat? = nil
    @State private var image: UIImage?
    @State private var displaySourceSize: CGSize = .zero
    /// Snapshot of pendingCropRect at drag start so mid-drag math is stable.
    @State private var dragBaseRect: CGRect?

    enum PhotoTool { case duration, zoom, title }

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 8)

            // Preview — explicit aspect-fit rect centered via .position, same
            // pattern that reliably centers the composition preview in
            // SettingsView. The Color.clear.aspectRatio trick was leaving the
            // photo off-center.
            GeometryReader { geo in
                let aspect = orientation.size.width / orientation.size.height
                let (fitW, fitH): (CGFloat, CGFloat) = {
                    let scaleToWidth = geo.size.width / aspect
                    if scaleToWidth <= geo.size.height {
                        return (geo.size.width, scaleToWidth)
                    } else {
                        return (geo.size.height * aspect, geo.size.height)
                    }
                }()

                ZStack {
                    Color.black
                    if let img = image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(zoomScale, anchor: zoomAnchor)
                            .clipped()
                            .animation(.easeInOut(duration: 0.2), value: pendingCropRect)
                    } else {
                        ProgressView().tint(.white)
                    }
                    titleOverlayView
                }
                .frame(width: fitW, height: fitH)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged { value in
                            dragCrop(translation: value.translation,
                                     container: CGSize(width: fitW, height: fitH))
                        }
                        .onEnded { _ in dragBaseRect = nil }
                )
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .padding(.horizontal, 12)

            Spacer(minLength: 8)

            // 3-tool row + inline sub-tab
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Button(action: { toggle(.duration) }) {
                        toolIconBody(icon: "clock", active: expandedTool == .duration)
                    }.buttonStyle(.plain)
                    Button(action: { toggle(.zoom) }) {
                        toolIconBody(icon: "plus.magnifyingglass", active: expandedTool == .zoom)
                    }.buttonStyle(.plain)
                    Button(action: { toggle(.title) }) {
                        toolIconBody(icon: "textformat",
                                     active: expandedTool == .title || !mediaItem.titleText.isEmpty || !mediaItem.subtitleText.isEmpty)
                    }.buttonStyle(.plain)
                }

                Group {
                    switch expandedTool {
                    case .duration:
                        HStack(spacing: 8) {
                            ForEach(Self.durationOptions, id: \.self) { d in
                                durationChip(d)
                            }
                        }
                    case .zoom:
                        HStack(spacing: 8) {
                            zoomChip("1×", zoom: nil)
                            zoomChip("1.5×", zoom: 1.5)
                            zoomChip("2×", zoom: 2.0)
                            zoomChip("3×", zoom: 3.0)
                        }
                    case .title:
                        VStack(spacing: 8) {
                            HStack(spacing: 10) {
                                Image(systemName: "textformat")
                                    .foregroundColor(.brandPrimary)
                                    .frame(width: 24)
                                TextField("", text: $mediaItem.titleText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "textformat.size.smaller")
                                    .foregroundColor(.brandPrimary)
                                    .frame(width: 24)
                                TextField("", text: $mediaItem.subtitleText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            HStack(spacing: 10) {
                                colorSwatch(isWhite: true)
                                colorSwatch(isWhite: false)
                            }
                        }
                    case .none:
                        EmptyView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, expandedTool == nil ? 0 : 4)
                .animation(.easeInOut(duration: 0.08), value: expandedTool)
            }
            .layoutPriority(1)

            Color.clear.frame(height: 36)

            HStack(spacing: 20) {
                actionCircle(icon: "chevron.backward", filled: false, action: { dismiss() })
                actionCircle(icon: "checkmark", filled: true, action: saveAndDismiss)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 40)
        }
        .task {
            pendingDuration = mediaItem.photoDuration ?? 5
            pendingCropRect = mediaItem.cropRect
            activeZoom = inferZoomFromCropRect(pendingCropRect)
            image = await loadImage()
        }
    }

    // MARK: - Actions

    private func toggle(_ tool: PhotoTool) {
        expandedTool = expandedTool == tool ? nil : tool
    }

    private func saveAndDismiss() {
        mediaItem.photoDuration = pendingDuration
        mediaItem.cropRect = pendingCropRect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { dismiss() }
    }

    // MARK: - Chip helpers

    @ViewBuilder
    private func durationChip(_ v: Double) -> some View {
        let active = abs(pendingDuration - v) < 0.01
        Button(action: {
            pendingDuration = v
            expandedTool = nil
        }) {
            Text("\(Int(v))s")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(active ? .white : .brandPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(active ?
                    AnyView(LinearGradient(colors: Color.primaryGradient, startPoint: .leading, endPoint: .trailing)) :
                    AnyView(Color.brandPrimary.opacity(0.12)))
                .cornerRadius(10)
        }.buttonStyle(.plain)
    }

    @ViewBuilder
    private func zoomChip(_ label: String, zoom: CGFloat?) -> some View {
        let active = activeZoom == zoom
        Button(action: {
            applyZoom(zoom)
            expandedTool = nil
        }) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(active ? .white : .brandPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(active ?
                    AnyView(LinearGradient(colors: Color.primaryGradient, startPoint: .leading, endPoint: .trailing)) :
                    AnyView(Color.brandPrimary.opacity(0.12)))
                .cornerRadius(10)
        }.buttonStyle(.plain)
    }


    @ViewBuilder
    private func toolIconBody(icon: String, active: Bool) -> some View {
        Image(systemName: icon)
            .font(.system(size: 26, weight: .semibold))
            .foregroundColor(active ? .white : .brandPrimary)
            .frame(width: 68, height: 58)
            .background(active ? Color.brandPrimary : Color.brandPrimary.opacity(0.12))
            .cornerRadius(14)
    }

    @ViewBuilder
    private func actionCircle(icon: String, filled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(filled ? .white : .brandPrimary)
                .frame(width: 72, height: 72)
                .background(filled ?
                    AnyView(LinearGradient(colors: Color.brandGradient, startPoint: .leading, endPoint: .trailing)) :
                    AnyView(Color.brandPrimary.opacity(0.12)))
                .clipShape(Circle())
                .shadow(color: filled ? Color.brandSecondary.opacity(0.4) : .clear, radius: 10, x: 0, y: 4)
        }.buttonStyle(.plain)
    }

    // MARK: - Zoom math (mirrors TrimmingView so behavior is consistent)

    private var zoomScale: CGFloat {
        guard let rect = pendingCropRect, rect.width > 0, rect.height > 0 else { return 1.0 }
        return 1.0 / min(rect.width, rect.height)
    }

    private var zoomAnchor: UnitPoint {
        guard let rect = pendingCropRect, zoomScale > 1 else { return .center }
        let invS = 1.0 / zoomScale
        let denom = 1 - invS
        guard denom > 0 else { return .center }
        return UnitPoint(x: min(1, max(0, rect.origin.x / denom)),
                         y: min(1, max(0, rect.origin.y / denom)))
    }

    private func applyZoom(_ zoom: CGFloat?) {
        activeZoom = zoom
        guard let zoom = zoom, displaySourceSize.width > 0, displaySourceSize.height > 0, zoom > 0 else {
            pendingCropRect = nil
            return
        }
        let sourceAspect = displaySourceSize.width / displaySourceSize.height
        let targetAspect = orientation.size.width / orientation.size.height
        let baseW: CGFloat = sourceAspect >= targetAspect ? min(1, targetAspect / sourceAspect) : 1
        let baseH: CGFloat = sourceAspect >= targetAspect ? 1 : min(1, sourceAspect / targetAspect)
        let w = min(1, baseW / zoom)
        let h = min(1, baseH / zoom)
        pendingCropRect = CGRect(x: (1 - w) / 2, y: (1 - h) / 2, width: w, height: h)
    }

    @ViewBuilder
    private func colorSwatch(isWhite: Bool) -> some View {
        let active = mediaItem.titleIsWhite == isWhite
        Button(action: { mediaItem.titleIsWhite = isWhite }) {
            Circle()
                .fill(isWhite ? Color.white : Color.black)
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(active ? Color.brandPrimary : Color.gray.opacity(0.5), lineWidth: active ? 3 : 1))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var titleOverlayView: some View {
        let title = mediaItem.titleText
        let subtitle = mediaItem.subtitleText
        let fg: Color = mediaItem.titleIsWhite ? .white : .black
        let shadow: Color = mediaItem.titleIsWhite ? .black : .white
        if !title.isEmpty || !subtitle.isEmpty {
            VStack(spacing: 4) {
                if !title.isEmpty {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(fg)
                        .shadow(color: shadow.opacity(0.7), radius: 4, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(fg)
                        .shadow(color: shadow.opacity(0.7), radius: 3, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
    }

    /// Pan the current crop rect within the source. No-op if not zoomed.
    /// Same math as TrimmingView.dragCrop so behavior is consistent.
    private func dragCrop(translation: CGSize, container: CGSize) {
        guard pendingCropRect != nil, container.width > 0, container.height > 0 else { return }
        if dragBaseRect == nil { dragBaseRect = pendingCropRect }
        guard let base = dragBaseRect else { return }
        let scale = 1.0 / min(base.width, base.height)
        let dxN = translation.width / (container.width * scale)
        let dyN = translation.height / (container.height * scale)
        var newRect = base
        newRect.origin.x = max(0, min(1 - base.width, base.origin.x - dxN))
        newRect.origin.y = max(0, min(1 - base.height, base.origin.y - dyN))
        pendingCropRect = newRect
    }

    private func inferZoomFromCropRect(_ rect: CGRect?) -> CGFloat? {
        guard let rect = rect, displaySourceSize.width > 0 else { return nil }
        let sourceAspect = displaySourceSize.width / displaySourceSize.height
        let targetAspect = orientation.size.width / orientation.size.height
        let baseW: CGFloat = sourceAspect >= targetAspect ? min(1, targetAspect / sourceAspect) : 1
        guard rect.width > 0 else { return nil }
        let z = baseW / rect.width
        for preset in [1.5, 2.0, 3.0] as [CGFloat] where abs(z - preset) < 0.05 {
            return preset
        }
        return nil
    }

    // MARK: - Image loading

    private func loadImage() async -> UIImage? {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        let target = CGSize(width: 1200, height: 1200)
        let img: UIImage? = await withCheckedContinuation { continuation in
            var resumed = false
            PHImageManager.default().requestImage(for: mediaItem.asset, targetSize: target, contentMode: .aspectFit, options: options) { image, info in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                guard !isDegraded, !resumed else { return }
                resumed = true
                continuation.resume(returning: image)
            }
        }
        if let img = img {
            displaySourceSize = img.size
        }
        return img
    }
}
