# Alarm Clock App Requirements

## 1. Product goal
Create a simple, polished alarm clock app inspired by the reference app "Alarm Clock - Wake up Music".

## 2. Target platform
- iPhone first
- iPad support later
- iOS 17+ as the initial target

## 3. Core user stories
- As a user, I want to create multiple alarms so I can wake up at different times.
- As a user, I want to choose between built-in alarm sounds and music so the wake-up experience feels personal.
- As a user, I want to snooze easily when I am still tired.
- As a user, I want to customize the clock/nightstand screen so it feels pleasant at night.
- As a user, I want a sleep timer so I can fall asleep to music.
- As a user, I want local weather information visible in the app.
- As a user, I want a quick flashlight action for convenience.

## 4. MVP functional requirements
### Alarm management
- Create, edit, delete alarms
- Set time, repeat days, label, sound selection
- Enable/disable alarms
- Unlimited alarms
- Snooze duration setting
- Optional vibration

### Wake-up experience
- Alarm sound playback
- Fade-in volume option
- Stop and snooze actions
- Support for music playback or built-in sounds

### Nightstand / clock screen
- Large digital clock view
- Background color/theme selection
- Brightness and contrast controls
- Minimal, clean UI for nighttime use

### Sleep timer
- Start timer for music playback
- Stop after selected duration

### Optional utility features
- Local weather display
- Flashlight shortcut
- Screen saver mode for OLED-friendly devices

## 5. UI requirements
- Clean, modern, calm interface
- Large tappable controls
- Clear hierarchy for alarms, settings, and clock view
- Light and dark mode support
- Accessible contrast and readable typography

## 6. Non-functional requirements
- Fast app launch
- Reliable notification handling
- Respect battery and background audio rules
- Local-first behavior where possible
- Privacy-conscious implementation
- Smooth animations and low-friction interactions

## 7. Suggested app structure
- Home / Alarm list screen
- Alarm detail/edit screen
- Clock / Nightstand screen
- Settings screen
- Sleep timer screen
- Weather and utilities section

## 8. MVP scope vs later scope
### Included in MVP
- Alarm creation and editing
- Sound selection
- Snooze
- Nightstand clock view
- Sleep timer
- Basic settings

### Later enhancements
- Premium themes
- Ad-free experience
- Apple Watch companion
- Advanced weather widgets
- Smart wake-up features

## 9. Recommended implementation approach
- Build with SwiftUI
- Use UserNotifications for alarms
- Use AVFoundation for sounds and audio playback
- Use Core Data or SwiftData for persistence
- Use GitHub Actions for CI builds
