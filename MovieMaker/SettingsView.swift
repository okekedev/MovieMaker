import SwiftUI
import Photos
import AVFoundation

struct SettingsView: View {
    @Binding var selectedMedia: [MediaItem]
    @Binding var settings: VideoCompilationSettings
    let onBack: () -> Void
    let onCreate: () -> Void

    init(selectedMedia: Binding<[MediaItem]>, settings: Binding<VideoCompilationSettings>, onBack: @escaping () -> Void, onCreate: @escaping () -> Void) {
        self._selectedMedia = selectedMedia
        self._settings = settings
        self.onBack = onBack
        self.onCreate = onCreate
    }

    @State private var showingWarning = false
    @State private var warningMessage = ""
    @State private var orientationExpanded = false
    @State private var showingPaywall = false
    @State private var titleExpanded = false
    @State private var musicExpanded = false // Re-add musicExpanded
    @State private var transitionExpanded = false
    @State private var showingMusicPicker = false
    @State private var selectedMusicTitle: String = "None"
    @EnvironmentObject var storeManager: StoreManager

    private var totalDuration: Double {
        // Calculate total video duration
        var duration: Double = 0
        for item in selectedMedia {
            duration += item.asset.duration
        }
        return duration
    }

    private var formattedDuration: String {
        let minutes = Int(totalDuration) / 60
        let seconds = Int(totalDuration) % 60
        if minutes > 0 {
            return "\(minutes) min \(seconds) sec"
        } else {
            return "\(seconds) sec"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
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

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Orientation
                    DisclosureGroup(
                        isExpanded: $orientationExpanded,
                        content: {
                            VStack(spacing: 12) {
                                Picker("Orientation", selection: $settings.orientation) {
                                    ForEach(VideoOrientation.allCases, id: \.self) { orientation in
                                        Text(orientation.rawValue).tag(orientation)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .padding(.top, 8)
                        },
                        label: {
                            HStack {
                                Text("Video Orientation")
                                    .font(.system(size: 17, weight: .semibold))
                                Spacer()
                                Text(settings.orientation.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                            }
                        }
                    )

                    Divider()

                    // Title Screen
                    DisclosureGroup(
                        isExpanded: $titleExpanded,
                        content: {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Title (Required)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    TextField("Enter title", text: $settings.titleText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())

                                    Text("Subtitle (Optional)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    TextField("Enter subtitle", text: $settings.subtitleText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())

                                    Text("White text on black background • 3 seconds")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 4)
                                }
                            }
                            .padding(.top, 8)
                        },
                        label: {
                            HStack {
                                Text("Title Screen")
                                    .font(.system(size: 17, weight: .semibold))
                                Spacer()
                                if !settings.titleText.isEmpty { // Always consider title screen included if text is present
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 15))
                                } else {
                                    Text("No Title") // Changed from "Optional"
                                        .font(.system(size: 15))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    )

                    Divider()

                    // Transition Style
                    DisclosureGroup(
                        isExpanded: $transitionExpanded,
                        content: {
                            VStack(spacing: 12) {
                                Picker("Transition Style", selection: $settings.transition) {
                                    ForEach(TransitionType.allCases, id: \.self) { transition in
                                        Text(transition.rawValue).tag(transition)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())

                                if settings.transition == .fade { // Only show color picker if transition is fade
                                    ColorPicker("Transition Color", selection: $settings.transitionColor.swiftuiColor)
                                        .padding(.horizontal, 4)
                                }
                            }
                            .padding(.top, 8)
                        },
                        label: {
                            HStack {
                                Text("Transition Style")
                                    .font(.system(size: 17, weight: .semibold))
                                Spacer()
                                Text(settings.transition.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                            }
                        }
                    )



                    Divider()

                    // Background Music (separate)
                    if storeManager.isPro {
                        DisclosureGroup(
                            isExpanded: $musicExpanded,
                            content: {
                                VStack(spacing: 16) {
                                    Button(action: {
                                        showingMusicPicker = true
                                    }) {
                                        HStack {
                                            Image(systemName: "music.note")
                                                .foregroundColor(.brandPrimary)

                                            VStack(alignment: .leading) {
                                                Text("Select Music")
                                                    .font(.subheadline)
                                                    .foregroundColor(.primary)

                                                Text(selectedMusicTitle)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }

                                            Spacer()

                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.secondary)
                                                .font(.caption)
                                        }
                                        .padding(12)
                                        .background(Color.brandPrimary.opacity(0.1))
                                        .cornerRadius(8)
                                    }

                                    if settings.musicAsset != nil {
                                        VStack(spacing: 8) {
                                            HStack {
                                                Text("Volume")
                                                Spacer()
                                                Text("\(Int(settings.musicVolume * 100))%")
                                                    .fontWeight(.semibold)
                                            }
                                            .font(.subheadline)

                                            Slider(value: $settings.musicVolume, in: 0...1)
                                                .tint(Color.brandAccent)
                                        }

                                        Toggle("Background Music Only", isOn: Binding(
                                            get: { selectedMedia.allSatisfy { $0.isMuted } },
                                            set: { newValue in
                                                for index in selectedMedia.indices {
                                                    selectedMedia[index].isMuted = newValue
                                                }
                                            }
                                        ))
                                        .tint(Color.brandAccent)

                                        Button(action: {
                                            settings.musicAsset = nil
                                            selectedMusicTitle = "None"
                                        }) {
                                            HStack {
                                                Image(systemName: "trash")
                                                Text("Remove Music")
                                            }
                                            .font(.subheadline)
                                            .foregroundColor(.red)
                                        }
                                    }

                                    Text("Music will loop throughout the video")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 8)
                            },
                            label: {
                                HStack {
                                    Text("Background Music")
                                        .font(.system(size: 17, weight: .semibold))
                                    Spacer()
                                    if settings.musicAsset != nil {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.system(size: 15))
                                    } else {
                                        Text("None")
                                            .font(.system(size: 15))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        )
                    } else {
                        Button(action: {
                            showingPaywall = true
                        }) {
                            HStack {
                                Text("Background Music")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.yellow)
                                    Text("PRO")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.yellow)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.yellow.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    }

                    
                
                    // Preview Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preview")
                            .font(.system(size: 17, weight: .semibold))

                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.brandPrimary)
                            Text("Total length: \(formattedDuration)")
                                .fontWeight(.medium)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.brandPrimary.opacity(0.1))
                        .cornerRadius(8)

                        HStack {
                            Image(systemName: "photo.stack")
                                .foregroundColor(.brandPrimary)
                            Text("\(selectedMedia.count) item\(selectedMedia.count == 1 ? "" : "s")")
                                .fontWeight(.medium)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.brandPrimary.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }

            // Create Button
            Button(action: {
                checkAndCreate()
            }) {
                Text("Create Video")
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
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
        .alert("Warning", isPresented: $showingWarning) {
            Button("Cancel", role: .cancel) {}
            Button("Create Anyway") {
                onCreate()
            }
        } message: {
            Text(warningMessage)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
                .environmentObject(storeManager)
        }
        .sheet(isPresented: $showingMusicPicker) {
            DocumentPicker(
                selectedMusicTitle: $selectedMusicTitle,
                musicAsset: $settings.musicAsset,
                onDismiss: {
                    showingMusicPicker = false
                }
            )
        }
    }

    private func checkAndCreate() {
        // Check for very long videos
        let longVideos = selectedMedia.filter { $0.asset.mediaType == .video && $0.asset.duration > 300 }
        if !longVideos.isEmpty {
            showingWarning = true
            warningMessage = "You have \(longVideos.count) video\(longVideos.count == 1 ? "" : "s") longer than 5 minutes. This may result in a very large file."
            return
        }

        // Check for large number of items
        if selectedMedia.count > 100 {
            showingWarning = true
            warningMessage = "You have \(selectedMedia.count) items. This may take several minutes to create."
            return
        }

        onCreate()
    }
}
// Dummy comment to force re-evaluation
