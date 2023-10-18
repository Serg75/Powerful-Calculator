# Powerful Calculator

This is a feature-rich calculator with support for arithmetic operations, trigonometric functions, Bitcoin conversion, and a command history. It allows you to switch between two color themes: dark mode and light mode.

## Features
- Arithmetic operations: addition, subtraction, multiplication, and division.
- Trigonometric functions: sine (sin) and cosine (cos).
- Bitcoin conversion: Get the current dollar value for a given Bitcoin amount.
- Command history: Store and manage a history of your calculations.
- Support for two color themes: Dark mode and light mode.

## Prerequisites
- Xcode

## Getting Started
1. Clone this repository.
2. Open the project in Xcode.
3. Build and run the app on a simulator or device.

## Modules
- **BitcoinService**: Handles Bitcoin-related functionality.
- **CoreCalculation**: Manages core calculations and expressions.
- **FeatureToggling**: Allows enabling or disabling features, such as dark mode.

## FeatureToggling
  Feature Flags**: The **FeatureToggling** module enables you to control various features of the app using feature flags. You can customize these flags in the `FeatureFlags.json` file.
  
  Available feature flags:
  - **isDarkMode**: Toggles between dark mode and light mode to change the app's appearance.
  - **bitcoinConversion**: Enables or disables the feature to convert Bitcoin to dollars.
  - **addition**: Controls the availability of the addition operation button.
  - **subtraction**: Controls the availability of the subtraction operation button.
  - **multiplication**: Controls the availability of the multiplication operation button.
  - **division**: Controls the availability of the division operation button.
  - **sinFunction**: Controls the availability of the sine function (sin) button.
  - **cosFunction**: Controls the availability of the cosine function (cos) button.

## Themes
The app supports two color themes:
- **Dark Mode**: A stylish dark theme for low-light environments.
- **Light Mode**: A classic light theme for standard environments.

You can switch between themes using the "isDarkMode" feature toggle in the `FeatureFlags.json` file.

## Usage
- Perform calculations by tapping on the buttons.

## License
This project is not currently under any specific license.
