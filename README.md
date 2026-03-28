# Someone's 25th Birthday App (Flutter Web)

This app runs as a Flutter web app and is set up to deploy to GitHub Pages.
It now launches directly into birthday mode (no login/auth flow).

## Run locally (web)

1. Install Flutter (stable channel).
2. From project root:
	- `flutter pub get`
	- `flutter run -d chrome`

## Responsive layout

The UI is optimized for both phone and laptop:
- Centered max-width containers on larger screens
- Adaptive game cards and sections across mobile/laptop widths

## Quick test checklist

1. Start locally: `flutter run -d chrome`
2. Verify mobile width in browser devtools (e.g., 390x844)
3. Verify laptop width (e.g., 1366x768)
4. Verify all birthday games open and return correctly
5. Production build test: `flutter build web --release`

## Deploy to GitHub Pages

This repo includes CI workflow: [.github/workflows/deploy_web.yml](.github/workflows/deploy_web.yml)

### One-time GitHub setup

1. Push to `main`.
2. In GitHub repository settings:
	- Open **Pages**
	- Set **Source** to **GitHub Actions**
3. The workflow will build and deploy automatically on each push to `main`.

Your site URL will be:

`https://<your-github-username>.github.io/<your-repo-name>/`
