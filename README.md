# ChannelLink

A powerful iOS video compilation app with YouTube upload integration and AI-powered metadata generation.

## Features

- **Video Compilation**: Select, trim, and arrange multiple videos
- **Advanced Editing**: Slow-motion effects, transitions, title screens
- **Background Music**: Add music with volume control and looping
- **YouTube Integration**: Direct upload to YouTube with OAuth 2.0
- **AI Metadata**: Auto-generate titles, descriptions, and tags using Gemini AI
- **Freemium Model**: Free tier (up to 10 videos) with Pro upgrade

## Project Structure

```
ChannelLink/
├── ChannelLink.xcodeproj/       # Xcode project
├── ChannelLink/                 # Source files
│   ├── ChannelLinkApp.swift    # App entry point
│   ├── ContentView.swift        # Main navigation
│   ├── MediaSelectionView.swift # Video picker
│   ├── SettingsView.swift       # Compilation settings
│   ├── VideoCompiler.swift      # Core video processing
│   ├── YouTubeUploadView.swift  # YouTube upload UI
│   ├── YouTubeAuthManager.swift # OAuth handling
│   ├── GeminiService.swift      # AI metadata generation
│   └── ...
├── GoogleService-Info.plist     # OAuth credentials (DO NOT COMMIT)
└── README.md
```

## Setup Instructions

### Prerequisites

- Xcode 14.0+
- iOS 16.0+
- Swift 5.7+
- Google OAuth credentials
- Gemini API key (optional, for AI features)

### Local Development Setup

1. **Open the project**:
   ```bash
   open /Users/christian/Desktop/ChannelLink/ChannelLink.xcodeproj
   ```

2. **Configure OAuth**:
   - GoogleService-Info.plist is already configured
   - Bundle ID: `com.christianokeke.ezvideo`
   - URL Scheme: `com.googleusercontent.apps.880243579911-95788vph5je6vjm2rnhvnqo8n6lk31gm`

3. **Add Gemini API Key** (optional):
   - Open the app and go to Settings (gear icon)
   - Tap "Advanced Settings"
   - Enter your Gemini API key
   - Get your key from: https://makersuite.google.com/app/apikey

4. **Build and Run**:
   - Select a simulator or device
   - Press Cmd+R to build and run

### Configuration

**Bundle ID**: `com.christianokeke.ezvideo`

**OAuth Scopes**:
- `https://www.googleapis.com/auth/youtube.upload`
- `https://www.googleapis.com/auth/userinfo.email`

**Privacy Permissions Required** (Info.plist):
- Photo Library Access (NSPhotoLibraryUsageDescription)
- Camera (if recording)

## Development Workflow

### Git Configuration

If you haven't set up your Git identity:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes

3. Commit with descriptive messages:
   ```bash
   git add .
   git commit -m "Add: brief description of changes"
   ```

4. Merge back to main when ready:
   ```bash
   git checkout main
   git merge feature/your-feature-name
   ```

## Key Components

### Video Compilation (`VideoCompiler.swift`)
- AVFoundation-based video composition
- Supports trimming, slow-motion, transitions
- Background music with looping
- Title screen generation
- Exports to 1080p or 1920x1080

### YouTube Upload (`YouTubeUploadManager.swift`)
- Resumable uploads via YouTube Data API v3
- OAuth 2.0 authentication
- Upload progress tracking
- Privacy settings (public/private/unlisted)

### AI Integration (`GeminiService.swift`)
- Gemini API integration
- Auto-generates SEO-optimized metadata
- Title, description, and tag suggestions

### Monetization (`StoreManager.swift`)
- StoreKit integration
- Free tier: up to 10 videos
- Pro tier: unlimited videos, orientation control, looping

## Troubleshooting

### Build Errors
- Clean build folder: Shift+Cmd+K
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### OAuth Issues
- Verify GoogleService-Info.plist is in the project
- Check URL Scheme in Info.plist
- Ensure bundle ID matches OAuth configuration

### Video Export Fails
- Check available disk space
- Verify photo library permissions
- Try with smaller/fewer videos

## Notes

- **Local vs iCloud**: This is the local development version at `/Users/christian/Desktop/ChannelLink`
- **iCloud Version**: Original is at iCloud Desktop path (for backup only)
- **GoogleService-Info.plist**: Already configured, not tracked in Git for security
- **Development**: Use this local version for all Xcode work to avoid iCloud sync issues

## License

Private project - all rights reserved
