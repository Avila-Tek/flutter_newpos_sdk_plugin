# flutter_newpos_sdk

<img alt="NEWPOS N98 unit" src="https://i.imgur.com/6HkNhh2.png" width=100%></img>

A Flutter plugin that adds support for the NEWPOS N98 mPOS unit. Only available for Android.

## Example

This library has an implementation [example](https://github.com/Avila-Tek/flutter_newpos_sdk_plugin/tree/main/example) you can use to test all the features available in this plugin. You will need an N98 mPOS unit to test all the features.

## Getting Started

First, you must add the dependency to your Flutter app. To do so, add the latest release to your `pubspec.yaml` dependencies as follows.

```YAML
dependencies:
    flutter_newpos_sdk: 
        git:
            url: https://github.com/Avila-Tek/flutter_newpos_sdk_plugin.git
            ref: 0.0.2-alpha

```

> Note: You may set `ref` to `stable` if you want to use the latest stable version available, but it may break your code if a breaking change is made.

## Usage

First, start by creating an instance of `FlutterNewposSdk`. This class defines all the methods available by the N98 unit.

```dart
final pos = FlutterNewposSdk.instance;
```

The first step to communicate with the device is connecting to it via Bluetooth. This **must** be done with the `FlutterNewposSdk.instance.connectToBluetoothDevice` method, instead of manually connecting via the OS Bluetooth settings.

The `connectToBluetoothDevice` method requires the device's MAC address parameter. In order to get the MAC address of the POS, you must scan the Bluetooth devices in-app. You can use the integrated `FlutterNewposSdk.instance.scanBluetoothDevices` method, or other Bluetooth library to do so.

> 📍Note: You must call `FlutterNewposSdk.instance.connectToBluetoothDevice` in every app session to communicate with the POS, even if it is already connected to the smartphone. So, it is adviced to remember the MAC address to avoid having to scan for Bluetooth devices every time the app is opened.

Once the POS is connected using the library API, you will see a Bluetooth indicator at the top-center side of the screen of the N98 device. This means you are ready to use all the available features!

## Reading a card

The next thing you might want to do is read a card to process a payment.

> 🪧 Work in progress. ****

---

For more information, read the documentation of this library.


