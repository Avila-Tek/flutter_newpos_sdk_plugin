part of flutter_newpos_sdk;
// import 'dart:async';

// import 'package:flutter/services.dart';

// import 'exceptions/flutter_pos_exceptions.dart';
// import 'models/models.dart';

class FlutterNewposSdk {
  /// Default time out
  static const _defaultTimeOut = Duration(seconds: 10);

  static bool _initialized = false;

  /// Native platform channel
  static const MethodChannel _methods =
      MethodChannel('flutter_newpos_sdk/methods');

  /// stream used for the isScanning public api
  static final _isScanning = _StreamController<bool>(initialValue: false);

  /// stream used for the isScanning public api
  static final _isConnectedToDevice =
      _StreamController<bool>(initialValue: false);

  /// Stream used for the scanResults public api
  static final _scanResultsList =
      _StreamController<List<DeviceScanned>>(initialValue: []);

  /// the subscription to the scan results stream
  static StreamSubscription<dynamic>? _scanSubscription;

  /// a broadcast stream version of the MethodChannel
  // ignore: close_sinks
  static final StreamController<MethodCall> _methodStream =
      StreamController.broadcast();

  /// Timeout for scanning that can be cancelled by stopScan
  static Timer? _scanTimeout;

  /// FlutterBluePlus log level
  static const LogLevel _logLevel = LogLevel.debug;

  /// Show log color
  static const bool _logColor = true;

  /// Log level
  static LogLevel get logLevel => _logLevel;

  /// Returns whether we are scanning as a stream
  static Stream<bool> get isScanning => _isScanning.stream;

  /// Returns whether we are scanning as a stream
  static Stream<bool> get isConnectedToDevice => _isConnectedToDevice.stream;

  /// Are we scanning right now ?
  static bool get isScanningNow => _isScanning.latestValue;

  /// Returns a stream of List<ScanResult> results while a scan is in progress.
  /// - The list contains all the results since the scan started.
  /// - The returned stream is never closed.
  static Stream<List<DeviceScanned>> get scanResults => _scanResultsList.stream;

  static Future<void> clearAids() async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnClearAids')
        .map((m) {
      return m.arguments as bool;
    });
    try {
      final methodResult = await _invokeMethod(
        'clearAids',
      );

      final result = methodResult as bool;

      if (!result) {
        throw const FlutterPosException(
          code: 'CLEAR_AIDS_FAILURE',
          message: 'Exception clearing aids',
        );
      }
      final streamOutput = await getFirstResultInStream(
        stream,
        const Duration(seconds: 10),
      );
      if (streamOutput == false) {
        throw const FlutterPosException(
          code: 'CLEAR_AIDS_FAILURE',
          message: 'Exception clearing aids',
        );
      }
    } on TimeoutException {
      throw const FlutterPosException(
        code: 'CLEAR_AIDS_TIMEOUT',
        message: 'Timeout clearing aids',
      );
    } catch (e) {
      throw const FlutterPosException(
        code: 'CLEAR_AIDS_FAILURE',
        message: 'Exception clearing aids',
      );
    }
  }

  /// Adds an AID to the FlutterPos plugin.
  ///
  /// This function returns a `Future<void>`, which completes when the AID has been added successfully or when an error occurs.
  ///
  /// If the AID cannot be added, the function throws a `FlutterPosException`.
  ///
  /// Parameters:
  /// * `aid` (required): The AID to be added.
  ///
  /// Example:
  ///
  /// ```dart
  /// await FlutterNewposSdk.addAid('A000000003');
  /// ```
  /// **Throws:**
  /// * `FlutterPosException` with the code `ADD_AID_TIMEOUT` if the AID cannot be added within the timeout period.
  /// * `FlutterPosException` with the code `ADD_AID_FAILURE` if an unknown error occurs while adding the AID.
  /// * `FlutterPosException` with the code `ADD_AID_FAILURE` if the AID is already added.
  static Future<void> addAid(String aid) async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnAddAidSuccess')
        .map((m) {
      return m.arguments as bool;
    });
    try {
      final methodResult = await _invokeMethod(
        'addAid',
        aid,
      );

      final result = methodResult as bool;

      if (!result) {
        throw const FlutterPosException(
          code: 'ADD_AID_FAILURE',
          message: 'Exception adding AID',
        );
      }
      final streamOutput = await getFirstResultInStream(
        stream,
        const Duration(seconds: 2),
      );
      if (streamOutput == false) {
        throw const FlutterPosException(
          code: 'ADD_AID_FAILURE',
          message: 'Exception adding AID',
        );
      }
    } on TimeoutException {
      throw const FlutterPosException(
        code: 'ADD_AID_TIMEOUT',
        message: 'Timeout adding AID',
      );
    } catch (e) {
      throw const FlutterPosException(
        code: 'ADD_AID_FAILURE',
        message: 'Exception adding AID',
      );
    }
  }

  /// Adds an RID to the FlutterPos plugin.
  ///
  /// This function returns a `Future<void>`, which completes when the RID has been added successfully or when an error occurs.
  ///
  /// If the RID cannot be added, the function throws a `FlutterPosException`.
  ///
  /// Parameters:
  /// * `rid` (required): The RID to be added.
  ///
  /// Example:
  ///
  /// ```dart
  /// await FlutterNewposSdk.addRid('A000000003');
  /// ```
  /// **Throws:**
  /// * `FlutterPosException` with the code `ADD_RID_TIMEOUT` if the RID cannot be added within the timeout period.
  /// * `FlutterPosException` with the code `ADD_RID_FAILURE` if an unknown error occurs while adding the RID.
  /// * `FlutterPosException` with the code `ADD_RID_FAILURE` if the RID is already added.
  static Future<void> addRid(String rid) async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnAddRidSuccess')
        .map((m) {
      return m.arguments as bool;
    });
    try {
      final methodResult = await _invokeMethod(
        'addRid',
        rid,
      );

      final result = methodResult as bool;

      if (!result) {
        throw const FlutterPosException(
          code: 'ADD_RID_FAILURE',
          message: 'Exception adding RID',
        );
      }
      final streamOutput = await getFirstResultInStream(
        stream,
        const Duration(seconds: 2),
      );
      if (streamOutput == false) {
        throw const FlutterPosException(
          code: 'ADD_RID_FAILURE',
          message: 'Exception adding RID',
        );
      }
    } on TimeoutException {
      throw const FlutterPosException(
        code: 'ADD_RID_TIMEOUT',
        message: 'Timeout adding RID',
      );
    } catch (e) {
      throw const FlutterPosException(
        code: 'ADD_RID_FAILURE',
        message: 'Exception adding RID',
      );
    }
  }

  /// Displays text on the POS screen for a specified period of time.
  ///
  /// The function uses a stream to verify if the text was displayed correctly.
  ///
  /// **Parameters:**
  ///
  /// * `text`: The text to display. Must be a string.
  /// * `duration` (optional): The duration in seconds that the text will be displayed on the screen. The default value is 3 seconds.
  ///
  /// **Returns:**
  ///
  /// The function returns a `Future<bool>`. The `Future` resolves to `true` if the text was displayed correctly, or `false` if an error occurred.
  ///
  /// **Exceptions:**
  ///
  /// The function throws a `FlutterPosException` if the text cannot be displayed for any reason.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// // Displays the text "Hello world" on the POS screen for 5 seconds.
  /// final result = await FlutterNewposSdk.displayText(
  ///   text: 'Hello world',
  ///   duration: const Duration(seconds: 5),
  /// );
  ///
  /// // Checks if the text was displayed correctly.
  /// if (result) {
  ///   print('The text was displayed correctly');
  /// } else {
  ///   print('An error occurred while displaying the text');
  /// }
  /// ```
  static Future<bool> displayText({
    required String text,
    Duration duration = const Duration(seconds: 3),
  }) async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnDisplayTextOnScreenSuccess')
        .map((m) {
      return m.arguments as bool;
    });
    try {
      final methodResult = await _invokeMethod(
        'displayTextOnScreen',
        {
          'message': text,
          'keepShowTime': duration.inSeconds,
        },
      );

      final result = methodResult as bool;

      if (!result) {
        throw const FlutterPosException(
          code: 'DISPLAY_TEXT_EXCEPTION',
          message: 'Exception displaying text without any reason',
        );
      }
      final streamOutput = await getFirstResultInStream(
        stream,
        const Duration(seconds: 2),
      );
      return streamOutput ?? false;
    } catch (e) {
      throw const FlutterPosException(
        code: 'DISPLAY_TEXT_EXCEPTION',
        message: 'Exception displaying text without any reason',
      );
    }
  }

  /// Updates the master key for the FlutterPos plugin.
  ///
  /// The master key is used to encrypt and decrypt data, so it is important to keep it safe.
  ///
  /// Parameters:
  ///
  /// * `masterKey` (required): The new master key. Must be a 16-character string.
  /// * `ifDukpt` (required): A boolean value that indicates whether the master key should be encrypted with the DUKPT algorithm. If `true`, the master key will be encrypted with DUKPT. If `false`, the master key will not be encrypted.
  ///
  /// Example:
  ///
  /// ```dart
  /// // Update the master key without DUKPT encryption
  /// await FlutterNewposSdk.updateMasterKey(masterKey: 'my_new_master_key');
  ///
  /// // Update the master key with DUKPT encryption
  /// await FlutterNewposSdk.updateMasterKey(masterKey: 'my_new_master_key', ifDukpt: true);
  /// ```
  ///
  /// Implementation details:
  ///
  /// 1. Invokes the `updateMasterKey` method of the FlutterPos plugin, passing the new master key and the `ifDukpt` value.
  /// 2. Gets the first result from the `OnUpdateMasterKeySuccess` event stream of the plugin.
  /// 3. If the result is `true`, the master key has been updated successfully and the function displays a message of success.
  /// 4. If no result is received from the stream within the timeout, the function displays an error message and throws a `FlutterPosException` with the code `UPDATE_MASTER_KEY_TIMEOUT`.
  /// 5. If any other error occurs, the function throws a `FlutterPosException` with the code `UPDATE_MASTER_KEY_FAILED`.
  ///
  /// Return:
  ///
  /// The `updateMasterKey` function returns a `Future<void>`, which completes when the master key has been updated successfully or when an error occurs.
  ///
  /// Additional notes:
  ///
  /// * The `masterKey` parameter must be a 16-character string.
  /// * The `ifDukpt` parameter must be a boolean value.
  /// * The function throws a `FlutterPosException` if the update is unsuccessful.
  static Future<void> updateMasterKey({
    required String masterKey,
    bool ifDukpt = false,
  }) async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnUpdateMasterKeySuccess')
        .map((m) {
      return m.arguments as bool;
    });
    try {
      await _invokeMethod(
        'updateMasterKey',
        {
          'masterKey': masterKey,
          'ifDukpt': ifDukpt,
        },
      );
      final result = await getFirstResultInStream(
        stream,
        const Duration(seconds: 5),
      );

      final success = result ?? false;

      if (success) {
        await displayText(text: 'MasterKey was updated');
      } else {
        throw const FlutterPosException(
          code: 'UPDATE_MASTER_KEY_FAILED',
          message: 'Unknown error updating master key',
        );
      }
    } on TimeoutException {
      await displayText(text: 'Try update master key again');
      throw const FlutterPosException(
        code: 'UPDATE_MASTER_KEY_TIMEOUT',
        message: 'Timeout to update master key',
      );
    } catch (e) {
      throw const FlutterPosException(
        code: 'UPDATE_MASTER_KEY_FAILED',
        message: 'Unknown error updating master key',
      );
    }
  }

  /// Gets the device information from the FlutterPos plugin.
  ///
  /// This function returns a `DeviceInfo` object, which contains information about the device's firmware version, device type, KSN, and current ele per.
  ///
  /// If the device information cannot be obtained, the function throws a `FlutterPosException`.
  ///
  /// Example:
  ///
  /// ```dart
  /// final deviceInfo = await FlutterNewposSdk.getDeviceInfo();
  /// ```
  /// **Parameters:**
  ///
  /// * None.
  ///
  /// **Return:**
  ///
  /// A `DeviceInfo` object containing information about the device.
  ///
  /// **Throws:**
  ///
  /// * `FlutterPosException` with the code `GET_DEVICE_INFO_TIMEOUT` if the device information cannot be obtained within the timeout period.
  /// * `FlutterPosException` with the code `GET_DEVICE_INFO_FAILED` if an unknown error occurs while getting the device information.
  ///
  /// **Example:**
  /// ```dart
  /// final deviceInfo = await FlutterNewposSdk.getDeviceInfo();
  /// print(deviceInfo.firmwareVersion);
  /// print(deviceInfo.deviceType);
  /// print(deviceInfo.ksn);
  /// print(deviceInfo.currentElePer);
  /// ```
  static Future<DeviceInfo> getDeviceInfo() async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnGetDeviceInfo')
        .map((m) {
      final arguments = m.arguments as Map<Object?, Object?>;
      final convertedMap = <dynamic, dynamic>{};
      arguments.forEach((key, value) {
        if (key is String) {
          convertedMap[key] = value;
        }
      });
      return convertedMap;
    }).map(
      (event) {
        try {
          return DeviceInfo.fromMap(event);
        } catch (e) {
          throw const FlutterPosException(
            code: 'GET_DEVICE_INFO_FAILED',
            message: 'Unknown error getting device info',
          );
        }
      },
    );
    try {
      await _invokeMethod(
        'getDeviceInfo',
      );
      final result = await getFirstResultInStream(
        stream,
        const Duration(seconds: 5),
      );

      final success = result != null;

      if (success) {
        return result;
      } else {
        throw const FlutterPosException(
          code: 'GET_DEVICE_INFO_FAILED',
          message: 'Unknown error getting device info',
        );
      }
    } on TimeoutException {
      throw const FlutterPosException(
        code: 'GET_DEVICE_INFO_TIMEOUT',
        message: 'Timeout getting device info',
      );
    } catch (e) {
      throw const FlutterPosException(
        code: 'GET_DEVICE_INFO_FAILED',
        message: 'Unknown error getting device info',
      );
    }
  }

  /// Starts a scan for Bluetooth devices and returns a stream of the results.
  ///
  /// * `timeout`: Optionally specifies a duration after which the scan
  ///  will be stopped.
  ///
  /// Example of how to use the `scanBluetoothDevices()` function.
  ///
  /// This example starts a scan for Bluetooth devices and prints the results to the console.
  /// To use the `scanBluetoothDevices()` function, you can do the following:
  ///
  /// 1. Call the `scanBluetoothDevices()` function with the desired timeout.
  /// 2. Listen to the `scanResults` stream to receive the results of the scan.
  /// 3. Print the results of the scan to the console.
  /// The following example shows how to use the `scanBluetoothDevices()` function:
  static Future<void> scanBluetoothDevices({
    Duration? timeout,
  }) async {
    // Stops any existing scan
    final isScanning = _isScanning.latestValue;
    if (isScanning == true) {
      await stopScan();
    }

    // Sets the scanning flag to true
    _isScanning.add(true);

    final responseStream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnScanResponse')
        .map((m) {
      final arguments = m.arguments as Map<Object?, Object?>;
      final convertedMap = <dynamic, dynamic>{};
      arguments.forEach((key, value) {
        if (key is String) {
          convertedMap[key] = value;
        }
      });
      return convertedMap;
    }).map(
      BluetoothDevice.fromMap,
    );

    // Starts buffering the scan results
    final scanBuffer = _BufferStream.listen(responseStream);

    // Invokes the platform method to start the scan
    await _invokeMethod('scanBlueDevice') as bool;

    // Creates a stream of the scan results, filtered for devices that are still present
    final outputStream = scanBuffer.stream;

    // Creates a list to store the scan results
    final output = <DeviceScanned>[];

    // Listens to the stream of scan results and pushes them to the `scanResults` stream
    _scanSubscription = outputStream.listen((BluetoothDevice? response) {
      if (response != null) {
        // Converts the BluetoothDevice object to a DeviceScanned object
        final sr = DeviceScanned.fromDevice(response);

        // Adds or updates the DeviceScanned object in the output list
        output.addOrUpdate(sr);

        // Pushes the output list to the `scanResults` stream
        _scanResultsList.add(List.from(output));
      }
    });

    // Starts a timer to stop the scan after the specified timeout
    if (timeout != null) {
      _scanTimeout = Timer(_defaultTimeOut, stopScan);
    }
  }

  /// Stops a scan for Bluetooth Low Energy devices.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// // Stops the scan for Bluetooth Low Energy devices.
  /// await FlutterNewposSdk.stopScan();
  /// ```
  static Future<void> stopScan() async {
    await _stopScan();
  }

  // Internal use for stop bluetooth scanning
  static Future<void> _stopScan({bool invokePlatform = true}) async {
    await _scanSubscription?.cancel();
    _scanTimeout?.cancel();
    _isScanning.add(false);
    try {
      if (invokePlatform) {
        await _invokeMethod('stopScan');
      }
    } finally {
      _scanResultsList.latestValue = [];
    }
  }

  static Future<bool> disconnectDevice() async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnDeviceDisConnected')
        .map((m) {
      return m.arguments as bool;
    });

    try {
      await _invokeMethod('disconnectDevice');
      final streamOutputs = await getFirstResultInStream(
        stream,
        const Duration(seconds: 5),
      );
      final result = streamOutputs ?? false;
      return result;
    } on TimeoutException {
      return false;
    } catch (e) {
      throw BluetoothConnectionFailed(code: '');
    }
  }

  /// Connects the POS device to a Bluetooth device with the specified MAC address.
  ///
  /// The function uses a stream to verify if the connection was successful.
  ///
  /// **Parameters:**
  ///
  /// * `macAddress`: The MAC address of the Bluetooth device you want to connect to.
  ///
  /// **Returns:**
  ///
  /// The function returns a `Future<bool>`. The `Future` resolves to `true` if the connection was successful, or `false` if an error occurred.
  ///
  /// **Exceptions:**
  ///
  /// The function throws a `BluetoothConnectionFailed` if the connection to the Bluetooth device fails for any reason.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// // Connects the POS device to the Bluetooth device with the MAC address "00:11:22:33:44:55".
  /// final result = await FlutterNewposSdk.connectToBluetoothDevice('00:11:22:33:44:55');
  ///
  /// // Checks if the connection was successful.
  /// if (result) {
  ///   print('The POS device is connected to the Bluetooth device');
  /// } else {
  ///   print('The POS device could not connect to the Bluetooth device');
  /// }
  /// ```
  static Future<bool> connectToBluetoothDevice(String macAddress) async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnDeviceConnected')
        .map((m) {
      return m.arguments as bool;
    });

    try {
      await _invokeMethod('connectToBluetoothDevice', macAddress);
      final streamOutputs = await getFirstResultInStream(
        stream,
        const Duration(seconds: 5),
      );
      final result = streamOutputs ?? false;
      if (result) {
        await displayText(text: 'Bluetooth connected');
      }
      return result;
    } on TimeoutException {
      return false;
    } catch (e) {
      throw BluetoothConnectionFailed(code: '');
    }
  }

  static Future<ReadCardInfo?> getCardNumber() async {
    /// Stream method
    final stream = FlutterNewposSdk._methodStream.stream
        .where((m) => m.method == 'OnGetReadCardInfo')
        .map((m) {
      final arguments = m.arguments as Map<Object?, Object?>;
      final convertedMap = <String, dynamic>{};
      arguments.forEach((key, value) {
        if (key is String) {
          convertedMap[key] = value;
        }
      });
      return ReadCardInfo.fromJson(convertedMap);
    });
    try {
      await _invokeMethod('getCardNumber', 30);
      final streamOutput = await getFirstResultInStream(
        stream,
        const Duration(seconds: 30),
      );

      // ! Puede devolver true, pero con un resultado que no es exitoso

      return streamOutput;
    } on TimeoutException {
      rethrow;
    } catch (e) {
      throw BluetoothConnectionFailed(code: '');
    }
  }

  static Future<ReadCardInfo> completeTransaction({
    required double amount,
  }) async {
    try {
      /// Stream method
      final stream = FlutterNewposSdk._methodStream.stream
          .where((m) => m.method == 'OnGetReadCardInfo')
          .map((m) {
        final arguments = m.arguments as Map<Object?, Object?>;
        final convertedMap = <String, dynamic>{};
        arguments.forEach((key, value) {
          if (key is String) {
            convertedMap[key] = value;
          }
        });
        return ReadCardInfo.fromJson(convertedMap);
      });
      await _invokeMethod('completeTransaction');
      final card = await getFirstResultInStream(
        stream,
        const Duration(seconds: 10),
      );
      if (card == null) {
        throw const FlutterPosException(
          code: 'COMPLETE_TRANSACTION_EXCEPTION',
          message: 'Exception reading card',
        );
      }

      return card;
    } on TimeoutException {
      rethrow;
    } catch (e) {
      throw BluetoothConnectionFailed(code: '');
    }
  }

  /// Invoke a platform method
  static Future<dynamic> _invokeMethod(
    String method, [
    dynamic arguments,
  ]) async {
    // return value
    dynamic out;

    // only allow 1 invocation at a time (guarentees that hot restart finishes)
    final mtx = await _MutexFactory.getMutexForKey('invokeMethod');
    await mtx.take();

    try {
      // initialize
      await _initFlutterPos();

      // invoke
      out = await _methods.invokeMethod(method, arguments);

      // log result
      if (logLevel == LogLevel.verbose) {
        var func = '<$method>';
        var result = out.toString();
        func = _logColor ? _black(func) : func;
        result = _logColor ? _brown(result) : result;
        print('[FBP] $func result: $result');
      }
    } finally {
      mtx.give();
    }

    return out;
  }

  static Future<dynamic> _initFlutterPos() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    // set platform method handler
    _methods.setMethodCallHandler(_methodCallHandler);

    // hot restart
    if ((await _methods.invokeMethod('flutterHotRestart')) != 0) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      while ((await _methods.invokeMethod('connectedCount')) != 0) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    }
  }

  static Future<dynamic> _methodCallHandler(MethodCall call) async {
    final arguments = call.arguments;
    // keep track of adapter states
    if (call.method == 'scanBluetoothDevices') {}

    _methodStream.add(call);
  }
}
