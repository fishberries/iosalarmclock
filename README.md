# Alarm Clock App

This project is a SwiftUI-based alarm clock app designed for GitHub Actions CI builds.

## Structure
- AlarmClockApp/: app source files
- .github/workflows/ios-build.yml: GitHub Actions workflow for building the app on macOS

## Build requirements
- A GitHub repository with GitHub Actions enabled
- A valid Xcode project or workspace in the repository root
- A macOS runner for iOS builds

## Notes
- The app is structured so it can be compiled in CI with minimal dependencies.
- The current implementation includes alarm list, editing, persistence, and UI screens for a full MVP.
