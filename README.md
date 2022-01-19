# The Library Is Open! 💃🏼

![A GIF of RuPaul Charles saying: Because reading is what? Fundamental!](TheLibraryIsOpen/Resources/reading-is-fundamental.gif)

This is meant as a celebration of how open podcasts (used to) be.

Download your favorites before the big bad takes them (I'm looking at you, Spotify).

![A GIF showing the app in action.](TheLibraryIsOpen/Resources/main-flow.gif)

![Prototype: 6 screens one beside the other showing the app's main flow, from an empty screen with no podcasts to the episode list from a link informed by the user.](TheLibraryIsOpen/Resources/prototype.png)

## Features

### Main features (MVP)

- [x] Get podcast feed URL from an Apple Podcasts link
- [x] Get episode list
- [x] Download episodes
- [x] Store downloaded episodes in a ZIP file
- [x] Upload the zipped file to iCloud Drive (and later expand to more cloud providers, e. g., Google Drive)

### Backlog

Take a look at the project's backlog on Trello: https://trello.com/b/RvZ82ZLx

### Supported languages

- 🇺🇸 English
- 🇧🇷 Brazilian Portuguese (native)
- 🇨🇦 Canadian French (not perfect, open to contributions :)

To use a different language, change the simulator language in Settings or in Xcode go to `TheLibraryIsOpen (target name at the top) > Edit Scheme... > Run (sidebar) > Options > App Language`.

## Prerequisites

- iOS 15.0+
- Xcode 13+

## How to run

1. Clone the repo and open TheLibraryIsOpen.xcodeproj on Xcode.
1. Wait for Xcode to download all dependencies (Swift packages).
1. Use ⌘ + B to build and ⌘ + R to run the app on the Simulator.

### Unit tests

1. Use any simulator.
1. Set its language to English and its Region to United States in the Settings.
1. Delete the app from the sim to delete any data from a previous run.
1. In Xcode, ⌘ + U to run the tests.

Note: `testGetEpisodesWithoutCache` and `testGetEpisodesWithCache` are known broken tests.

## About this repo

Rafael Claycon Schmitt – [@mitt_rafael](https://twitter.com/mitt_rafael) – rafael.claycon@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.
