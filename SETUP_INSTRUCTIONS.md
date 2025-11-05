# Channel Link - Setup Instructions

## ✅ What's Done

1. **Project Created** - New Xcode project at `/Users/christian/Desktop/ChannelLink`
2. **Bundle ID Configured** - `com.christianokeke.ezvideo` (matches OAuth!)
3. **Source Files Copied** - All slidecast files copied as reference (slidecast untouched)
4. **YouTubeAuthManager.swift** - Created ✅
5. **GeminiService.swift** - Created ✅
6. **YouTubeUploadManager.swift** - Created ✅
7. **UploadView.swift** - Created ✅
8. **Info.plist** - OAuth URL scheme added ✅

## 📝 Next Steps

### 1. Add Files to Xcode Project

**In Xcode** (already open):
1. In Project Navigator, right-click on "ChannelLink" folder
2. Choose "Add Files to ChannelLink"
3. Select ALL the .swift files in `/Users/christian/Desktop/ChannelLink/ChannelLink/`
4. Make sure "Copy items if needed" is **UNCHECKED**
5. Click "Add"

### 2. Add OAuth Plist

Copy the OAuth plist:
```bash
cp ~/Downloads/client_880243579911-95788vph5je6vjm2rnhvnqo8n6lk31gm.apps.googleusercontent.com.plist \
  /Users/christian/Desktop/ChannelLink/ChannelLink/GoogleService-Info.plist
```

Then add to Xcode project.

### 3. Get Gemini API Key

1. Go to https://makersuite.google.com/app/apikey
2. Create key for project `ez-video-1762052788`
3. Replace `YOUR_GEMINI_API_KEY_HERE` in GeminiService.swift (line 4)

### 4. Update for Videos (instead of Photos)

The copied files from slidecast are for photo slideshows. You'll need to update:
- `MediaSelectionView.swift` - Change `.images` to `.videos` in PHPickerConfiguration
- `VideoComposer.swift` - Adapt for video inputs instead of images
- `CompletionView.swift` - Add YouTube upload button that presents `UploadView`

### 5. Update Branding

Change references from "MemorySlideshow" to "Channel Link" in:
- App name in files
- Display strings
- Comments

## 📦 Project Status

- ✅ slidecast: Completely untouched
- ✅ ChannelLink: New separate project
- ✅ OAuth: Configured for `com.christianokeke.ezvideo`
- ✅ All YouTube integration files created
- ✅ Info.plist configured with OAuth URL scheme
- ⏳ Files need to be added to Xcode project
- ⏳ Need Gemini API key
- ⏳ Need to adapt for videos (currently set up for photos)
