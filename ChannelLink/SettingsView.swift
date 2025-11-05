import SwiftUI
import Photos

struct SettingsView: View {
    let selectedMedia: [MediaItem]
    @Binding var settings: SlideshowSettings
    let onBack: () -> Void
    let onCreate: () -> Void

    @State private var showingWarning = false
    @State private var warningMessage = ""
    @State private var orientationExpanded = false
    @State private var durationExpanded = false
    @State private var loopExpanded = false
    @State private var showingPaywall = false
    @State private var apiKeyExpanded = false
    @State private var musicExpanded = false
    @State private var showingMusicPicker = false
    @State private var selectedMusicTitle: String = "None"
    @AppStorage("gemini_api_key") private var geminiAPIKey: String = ""
    @EnvironmentObject var storeManager: StoreManager

    private var totalDuration: Double {
        var duration: Double = 0

        // Add intro if present
        if !settings.introText.isEmpty {
            duration += 4 // 4 seconds for intro
        }

        // Calculate total media duration (photos only)
        duration += Double(selectedMedia.count) * settings.photoDuration

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
                    // Intro Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Intro Slide (Optional)")
                            .font(.headline)

                        TextField("Title", text: $settings.introText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: settings.introText) { newValue in
                                if newValue.count > 100 {
                                    settings.introText = String(newValue.prefix(100))
                                }
                            }

                        Text("\(settings.introText.count)/100 characters")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if !settings.introText.isEmpty {
                            Text("Intro will display with white background")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }

                    Divider()

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
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                Text("Pro")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }

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
                                            .foregroundColor(.blue)

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
                                    .background(Color(.systemGray6))
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
                                            .accentColor(.blue)
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
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)

                                    if settings.loopDuration != .noLoop {
                                        Text("Your slideshow is \(formattedDuration). Loop for \(Int(settings.loopDuration.hours)) hour\(settings.loopDuration.hours == 1 ? "" : "s") = plays ~\(loopCount) time\(loopCount == 1 ? "" : "s")")
                                            .font(.callout)
                                            .foregroundColor(.secondary)
                                            .padding(12)
                                            .background(Color.blue.opacity(0.1))
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
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                Text("Pro")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    Divider()

                    // Gemini API Key Section (for YouTube uploads)
                    DisclosureGroup(
                        isExpanded: $apiKeyExpanded,
                        content: {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Enter your Gemini API key to enable AI-powered metadata generation for YouTube uploads")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                SecureField("API Key", text: $geminiAPIKey)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()

                                Link(destination: URL(string: "https://makersuite.google.com/app/apikey")!) {
                                    HStack {
                                        Image(systemName: "key.fill")
                                        Text("Get API Key from Google")
                                        Image(systemName: "arrow.up.right")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                }

                                if !geminiAPIKey.isEmpty {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                        Text("API Key configured")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding(.top, 8)
                        },
                        label: {
                            HStack {
                                Text("Gemini API Key")
                                    .font(.headline)
                                Spacer()
                                if geminiAPIKey.isEmpty {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                        .font(.subheadline)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                }
                            }
                        }
                    )

                    Divider()

                    // Preview Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preview")
                            .font(.headline)

                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text("Total length: \(formattedDuration)")
                                .fontWeight(.medium)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        HStack {
                            Image(systemName: "photo.stack")
                                .foregroundColor(.blue)
                            Text("\(selectedMedia.count) item\(selectedMedia.count == 1 ? "" : "s")")
                                .fontWeight(.medium)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }

            // Create Button
            Button(action: {
                checkAndCreate()
            }) {
                HStack {
                    Image(systemName: "tv")
                        .font(.title3)
                    Text("Create Slideshow")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.green, Color.green.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(12)
                .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
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
