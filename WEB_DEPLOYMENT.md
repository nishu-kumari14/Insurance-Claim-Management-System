# Web Deployment Guide

The Flutter web build is ready in `build/web/`. Choose one of these platforms to deploy:

## Option 1: Vercel (Recommended - Easiest)

1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Deploy:
   ```bash
   cd build/web
   vercel
   ```

3. Follow prompts, select "Other" as framework
4. Your app will be live at: `https://your-project.vercel.app`

## Option 2: Netlify

1. Install Netlify CLI:
   ```bash
   npm install -g netlify-cli
   ```

2. Deploy:
   ```bash
   netlify deploy --prod --dir=build/web
   ```

3. Your app will be live at: `https://your-app.netlify.app`

## Option 3: GitHub Pages

1. Build:
   ```bash
   flutter build web --base-href=/Insurance-Claim-Management-System/
   ```

2. Create `gh-pages` branch:
   ```bash
   git checkout --orphan gh-pages
   git rm -rf .
   cp -r build/web/* .
   git add .
   git commit -m "Deploy web version"
   git push origin gh-pages
   ```

3. Enable GitHub Pages in repo settings (branch: gh-pages)
4. Your app will be live at: `https://nishu-kumari14.github.io/Insurance-Claim-Management-System/`

## Option 4: Firebase Hosting

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login and initialize:
   ```bash
   firebase login
   firebase init hosting
   ```

3. Set public directory to `build/web`

4. Deploy:
   ```bash
   firebase deploy
   ```

## Build Optimization Stats

✅ CupertinoIcons: 99.4% reduction (257.6 KB → 1.5 KB)
✅ MaterialIcons: 99.5% reduction (1.6 MB → 8.8 KB)
✅ Total Size: ~2.5 MB (main.dart.js)

## Testing Locally Before Deployment

```bash
# Serve locally
cd build/web
python3 -m http.server 8080
```

Then visit: http://localhost:8080

## Notes

- All assets are cached by Flutter service worker
- Responsive design works on all devices
- Data persists using browser's SharedPreferences
- No backend/database required
