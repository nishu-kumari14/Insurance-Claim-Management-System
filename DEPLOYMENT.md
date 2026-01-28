# Deployment Guide - Insurance Claim Management System

This guide provides instructions for deploying the Insurance Claim Management System to various platforms.

## Web Deployment Options

### Option 1: Firebase Hosting (Recommended)

Firebase Hosting is free and provides fast, secure hosting for Flutter web applications.

#### Setup Firebase Hosting

1. **Install Firebase CLI**:
```bash
npm install -g firebase-tools
```

2. **Login to Firebase**:
```bash
firebase login
```

3. **Initialize Firebase in your project**:
```bash
cd insurance_claim_system
firebase init hosting
```

When prompted:
- Select "Use an existing project" or create a new one
- Set public directory to: `build/web`
- Configure as single-page app: `Yes`
- Don't overwrite `index.html`

4. **Build your Flutter web app**:
```bash
flutter build web --release
```

5. **Deploy to Firebase**:
```bash
firebase deploy
```

Your app will be live at: `https://your-project-id.web.app`

#### Update and Redeploy
```bash
flutter build web --release
firebase deploy
```

---

### Option 2: GitHub Pages

Free hosting through GitHub.

#### Setup GitHub Pages

1. **Create a new GitHub repository** (e.g., `insurance-claim-system`)

2. **Add GitHub remote**:
```bash
git remote add origin https://github.com/YOUR_USERNAME/insurance-claim-system.git
```

3. **Build for web**:
```bash
flutter build web --release --base-href /insurance-claim-system/
```

4. **Deploy to gh-pages branch**:
```bash
cd build/web
git init
git add .
git commit -m "Deploy to GitHub Pages"
git branch -M gh-pages
git remote add origin https://github.com/YOUR_USERNAME/insurance-claim-system.git
git push -f origin gh-pages
```

5. **Enable GitHub Pages**:
   - Go to repository Settings → Pages
   - Source: Deploy from branch `gh-pages`
   - Save

Your app will be live at: `https://YOUR_USERNAME.github.io/insurance-claim-system/`

---

### Option 3: Vercel

Easy deployment with automatic builds.

#### Setup Vercel

1. **Install Vercel CLI**:
```bash
npm install -g vercel
```

2. **Build for web**:
```bash
flutter build web --release
```

3. **Deploy**:
```bash
cd build/web
vercel
```

Follow the prompts to deploy. Your app will be live at a Vercel URL.

#### Automatic Deployments

1. Push your code to GitHub
2. Import your repository on [vercel.com](https://vercel.com)
3. Set build settings:
   - Framework Preset: Other
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
   - Install Command: `flutter pub get`

---

### Option 4: Netlify

Another excellent free hosting option.

#### Setup Netlify

1. **Build for web**:
```bash
flutter build web --release
```

2. **Deploy via Netlify CLI**:
```bash
npm install -g netlify-cli
netlify deploy --dir=build/web --prod
```

Or drag and drop the `build/web` folder to [app.netlify.com/drop](https://app.netlify.com/drop)

---

## Mobile Deployment

### Android (Google Play Store)

1. **Update app information** in `android/app/build.gradle.kts`:
```kotlin
defaultConfig {
    applicationId "com.icms.insurance_claim_system"
    minSdk = 21
    targetSdk = 34
    versionCode = 1
    versionName = "1.0.0"
}
```

2. **Build release APK**:
```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

3. **Build App Bundle** (for Play Store):
```bash
flutter build appbundle --release
```

Bundle location: `build/app/outputs/bundle/release/app-release.aab`

4. Upload to Google Play Console

---

### iOS (App Store)

1. **Open Xcode**:
```bash
open ios/Runner.xcworkspace
```

2. **Configure signing** in Xcode
   - Select Runner → Signing & Capabilities
   - Select your team
   - Update Bundle Identifier

3. **Build for release**:
```bash
flutter build ios --release
```

4. **Archive and upload** via Xcode → Product → Archive

---

## Environment Setup

### Update App Name and Icon

1. **App Name**: Update in:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`
   - `web/index.html`
   - `web/manifest.json`

2. **App Icon**: Use [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

---

## Performance Optimization

### Web Performance

1. **Enable Web Renderer** (for better performance):
```bash
flutter build web --release --web-renderer canvaskit
```

Or for better loading:
```bash
flutter build web --release --web-renderer html
```

2. **Enable Tree Shaking** (already enabled by default):
   - Reduces bundle size
   - Removes unused code

3. **Enable Code Splitting**:
```bash
flutter build web --release --split-debug-info=debug-info --obfuscate
```

---

## Testing Before Deployment

### Test Web Build Locally

```bash
flutter build web --release
cd build/web
python3 -m http.server 8000
```

Open: `http://localhost:8000`

### Test on Different Devices

```bash
# Test on Android emulator
flutter run -d android

# Test on iOS simulator
flutter run -d ios

# Test on web
flutter run -d chrome
```

---

## Post-Deployment Checklist

- [ ] App loads correctly on all target platforms
- [ ] All features work as expected
- [ ] Data persistence works
- [ ] Forms validate properly
- [ ] Responsive design works on mobile/tablet/desktop
- [ ] No console errors
- [ ] App is accessible via public URL
- [ ] README and documentation are updated
- [ ] GitHub repository is public (if using GitHub Pages)

---

## Troubleshooting

### Web Build Issues

**Issue**: White screen on load
- Check browser console for errors
- Ensure all assets are loading correctly
- Try different web renderer (html vs canvaskit)

**Issue**: Large bundle size
- Enable code splitting
- Remove unused dependencies
- Use tree-shaking

### Mobile Build Issues

**Issue**: Build fails on Android
- Update Gradle version in `android/gradle/wrapper/gradle-wrapper.properties`
- Check minimum SDK version

**Issue**: Build fails on iOS
- Update CocoaPods: `cd ios && pod update`
- Check deployment target in Xcode

---

## Quick Deploy Commands

```bash
# Web (Firebase)
flutter build web --release && firebase deploy

# Web (GitHub Pages)
flutter build web --release --base-href /REPO_NAME/ && cd build/web && git init && git add . && git commit -m "Deploy" && git push -f origin gh-pages

# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# All platforms check
flutter build web --release && flutter build apk --release
```

---

## Support

For deployment issues:
1. Check Flutter documentation: https://docs.flutter.dev/deployment
2. Check platform-specific guides
3. Consult hosting provider documentation

---

**Last Updated**: January 2026
