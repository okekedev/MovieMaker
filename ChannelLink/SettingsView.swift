import SwiftUI
import Photos

struct SettingsView: View {
    let selectedMedia: [MediaItem]
    @Binding var settings: VideoCompilationSettings
    let onBack: () -> Void
    let onCreate: () -> Void

    @State private var showingWarning = false
    @State private var warningMessage = ""
    @State private var orientationExpanded = false
    @State private var loopExpanded = false
    @State private var showingPaywall = false
    @State private var titleExpanded = false
    @State private var musicExpanded = false
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

    private var loopCount: Int {
        guard settings.loopDuration.hours > 0, totalDuration > 0 else { return 1 }
        return Int((settings.loopDuration.hours * 3600) / totalDuration)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.brandPrimary)
                }
                Spacer()
                Text("Settings")
                    .font(.headline)
                Spacer()
                // Invisible button for symmetry
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .opacity(0)
            }
            .padding()
            .background(Color(.systemBackground))

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Orientation
                    if storeManager.isPro {
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
                                        .font(.headline)
                                    Spacer()
                                    Text(settings.orientation.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                    } else {
                        Button(action: {
                            showingPaywall = true
                        }) {
                            HStack {
                                Text("Video Orientation")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color.brandAccent)
                                    .font(.subheadline)
                                Text("Pro")
                                    .font(.subheadline)
                                    .foregroundColor(Color.brandAccent)
                            }
                        }
                    }

                    Divider()

                    // Title Screen
                    DisclosureGroup(
                        isExpanded: $titleExpanded,
                        content: {
                            VStack(spacing: 16) {
                                Toggle("Add Title Screen", isOn: $settings.includeTitleScreen)
                                    .tint(Color.brandAccent)

                                if settings.includeTitleScreen {
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
                            }
                            .padding(.top, 8)
                        },
                        label: {
                            HStack {
                                Text("Title Screen")
                                    .font(.headline)
                                Spacer()
                                if settings.includeTitleScreen && !settings.titleText.isEmpty {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                } else {
                                    Text("Optional")
                                        .font(.subheadline)
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
                            }
                            .padding(.top, 8)
                        },
                        label: {
                            HStack {
                                Text("Transition Style")
                                    .font(.headline)
                                Spacer()
                                Text(settings.transition.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    )

                    Divider()

                    // Background Music
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
                                    .font(.headline)
                                Spacer()
                                if settings.musicAsset != nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                } else {
                                    Text("None")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    )

                    Divider()

                    // Loop Settings
                    if storeManager.isPro {
                        DisclosureGroup(
                            isExpanded: $loopExpanded,
                            content: {
                                VStack(spacing: 12) {
                                    Picker("Loop Duration", selection: $settings.loopDuration) {
                                        ForEach(LoopDuration.allCases, id: \.self) { duration in
                                            Text(duration.rawValue).tag(duration)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .padding(12)
                                    .background(Color.brandPrimary.opacity(0.1))
                                    .cornerRadius(8)

                                    if settings.loopDuration != .noLoop {
                                        Text("Your video is \(formattedDuration). Loop for \(Int(settings.loopDuration.hours)) hour\(settings.loopDuration.hours == 1 ? "" : "s") = plays ~\(loopCount) time\(loopCount == 1 ? "" : "s")")
                                            .font(.callout)
                                            .foregroundColor(.secondary)
                                            .padding(12)
                                            .background(Color.brandAccent.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.top, 8)
                            },
                            label: {
                                HStack {
                                    Text("Loop Settings")
                                        .font(.headline)
                                    Spacer()
                                    Text(settings.loopDuration.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                    } else {
                        Button(action: {
                            showingPaywall = true
                        }) {
                            HStack {
                                Text("Loop Settings")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color.brandAccent)
                                    .font(.subheadline)
                                Text("Pro")
                                    .font(.subheadline)
                                    .foregroundColor(Color.brandAccent)
                            }
                        }
                    }
                            
                    Divider()
                
                    // Preview Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preview")
                            .font(.headline)

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
                Text("Create Video Compilation")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
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
            .padding()
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
            MusicPickerView(selectedMusicTitle: $selectedMusicTitle, musicAsset: $settings.musicAsset)
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
