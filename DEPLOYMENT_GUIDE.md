# Deployment Guide: FFmpeg Android Minimal Build

This guide walks you through creating a new GitHub repository and setting up automated builds.

## Prerequisites

- GitHub account
- Git installed locally
- (Optional) GitHub CLI (`gh`) for faster setup

## Method 1: Using GitHub Web Interface (Recommended)

### Step 1: Create the Repository

1. Go to https://github.com/new
2. Fill in the details:
   - **Repository name**: `ffmpeg-android-minimal` (or your preferred name)
   - **Description**: "Minimal FFmpeg build for Android (armeabi-v7a) with AV1, VP9, HEVC, and H.264 support"
   - **Visibility**: Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
3. Click "Create repository"

### Step 2: Push Your Local Repository

GitHub will show you commands. Use these from your local directory:

```bash
cd /path/to/your/ffmpeg-android-minimal

# Add the remote repository
git remote add origin https://github.com/YOUR_USERNAME/ffmpeg-android-minimal.git

# Push to GitHub
git push -u origin main
```

### Step 3: Verify GitHub Actions

1. Go to your repository on GitHub
2. Click on the "Actions" tab
3. You should see "Build FFmpeg Android" workflow
4. The workflow will trigger automatically on push

### Step 4: Create Your First Release

Once the initial workflow completes successfully:

```bash
# Tag the initial version
git tag -a v1.0.0 -m "Release v1.0.0 - Initial FFmpeg Android build"

# Push the tag
git push origin v1.0.0
```

This will trigger the release workflow and publish build artifacts.

## Method 2: Using GitHub CLI

If you have GitHub CLI installed:

```bash
cd /path/to/your/ffmpeg-android-minimal

# Create repository and push
gh repo create ffmpeg-android-minimal \
  --public \
  --source=. \
  --description="Minimal FFmpeg build for Android (armeabi-v7a)" \
  --push

# Create and push first release tag
git tag -a v1.0.0 -m "Release v1.0.0 - Initial FFmpeg Android build"
git push origin v1.0.0
```

## Verification Steps

### 1. Check Repository Setup

Visit `https://github.com/YOUR_USERNAME/ffmpeg-android-minimal` and verify:

- ✅ README.md displays correctly
- ✅ All files are present
- ✅ Build script is executable

### 2. Monitor First Build

1. Go to Actions tab
2. Click on the running workflow
3. Monitor the build progress
4. Expected build time: 45-90 minutes (depending on GitHub runners)

### 3. Verify Release

After pushing a tag:

1. Go to the "Releases" section
2. You should see your release with:
   - `ffmpeg-android-armeabi-v7a-minimal.tar.gz`
   - `checksums.txt`
   - Release notes with codec information

## Troubleshooting

### Build Fails on External Dependencies

**Issue**: dav1d, x264, x265, or other dependency build fails

**Solution**: The GitHub Actions workflow includes steps to build all dependencies. If one fails:

1. Check the specific dependency build step in the workflow log
2. Common issues:
   - Network timeout: Re-run the workflow
   - Version incompatibility: Update the git tag in `.github/workflows/build-release.yml`

### NDK Download Fails

**Issue**: Android NDK download times out or fails

**Solution**: The workflow uses caching to avoid repeated downloads. If it fails:

1. Re-run the workflow
2. The NDK will be cached after the first successful download

### Build Takes Too Long

**Issue**: Build exceeds GitHub Actions timeout (6 hours)

**Solution**: The current setup should complete in 45-90 minutes. If it times out:

1. Check if all external dependencies are being rebuilt
2. Ensure caching is working (check cache hit logs)
3. Consider reducing enabled codecs if absolutely necessary

### Permissions Error When Creating Release

**Issue**: Workflow fails at "Create Release" step with permissions error

**Solution**: 

1. Go to repository Settings → Actions → General
2. Under "Workflow permissions", select "Read and write permissions"
3. Check "Allow GitHub Actions to create and approve pull requests"
4. Re-run the workflow

## Customization

### Change Repository Name

If you want a different name:

```bash
# On GitHub, rename the repository via Settings
# Then update your local remote:
git remote set-url origin https://github.com/YOUR_USERNAME/NEW_NAME.git
```

### Modify Build Configuration

To customize codecs or build settings:

1. Edit `build_ffmpeg_android.sh`
2. Commit and push changes
3. The workflow will pick up the new configuration

### Add More Architectures

To support arm64-v8a, x86, or x86_64:

1. Copy `build_ffmpeg_android.sh` to `build_ffmpeg_android_arm64.sh`
2. Update architecture variables
3. Add a new job in `.github/workflows/build-release.yml`
4. Update release notes

## Maintenance

### Update FFmpeg Version

To build a newer FFmpeg version:

1. The build script uses `--depth 1` which gets the latest release
2. To target a specific version, modify the git clone command:
   ```bash
   git clone --branch n6.1 --depth 1 'https://git.ffmpeg.org/ffmpeg.git'
   ```

### Update External Dependencies

To update dependency versions:

1. Edit `.github/workflows/build-release.yml`
2. Change the `--branch` parameter in git clone commands
3. Example: `--branch 1.5.0` for dav1d

### Monitor Build Status

Set up notifications:

1. Go to repository Settings → Notifications
2. Enable "Actions" notifications
3. Choose email or webhook

## Best Practices

### Versioning

Use semantic versioning for releases:

- `v1.0.0` - Initial release
- `v1.1.0` - New features (e.g., added arm64 support)
- `v1.0.1` - Bug fixes or patches
- `v2.0.0` - Breaking changes

### Release Notes

When creating releases, document:

- FFmpeg version used
- Changes from previous version
- Known issues
- Build configuration details

### Security

- Never commit API keys or secrets
- Use GitHub Secrets for sensitive data
- Keep dependencies updated
- Monitor security advisories for FFmpeg and dependencies

## Next Steps

After successful deployment:

1. ⭐ Star your repository
2. 📝 Update README with your specific repository URL
3. 🏷️ Create releases for stable builds
4. 📊 Monitor build times and optimize if needed
5. 🤝 Share with the community

## Support

If you encounter issues:

1. Check workflow logs in the Actions tab
2. Review FFmpeg build logs
3. Open an issue with:
   - Workflow run URL
   - Error messages
   - Steps to reproduce

---

**Happy Building! 🚀**
