// Create mutexes in a parrallel-safe way,
// ignore_for_file: parameter_assignments

part of flutter_newpos_sdk;
// part of 'flutter_newpos_sdk.dart';

enum LogLevel {
  none, //0
  error, // 1
  warning, // 2
  info, // 3
  debug, // 4
  verbose, //5
}

/// Returns a list of results from a stream in a time limit.
///
/// **Parameters:**
///
/// * `stream`: The stream from which to obtain the results.
/// * `timeout`: The time limit in milliseconds.
///
/// **Returns:**
///
/// A list of results.
///
/// **Example:**
///
/// ```dart
/// // Creates a stream that emits numbers
/// Stream<int> generateNumbers() async* {
///   for (int i = 0; i < 10; i++) {
///     await Future.delayed(Duration(seconds: 1));
///     yield i;
///   }
/// }
///
/// // Gets the results of the stream in a time limit of 5 seconds
/// Future<List<int>> results = getStreamResultsInTimeLimit(generateNumbers(), 5000);
///
/// // Prints the results
/// await results.then((list) {
///   print(list);
/// });
/// ```
///
/// **Output:**
///
/// ```
/// [0, 1, 2, 3, 4, 5]
/// ```

Future<List<T>> getStreamResultsInTimeLimit<T>(
  Stream<T> stream,
  Duration timeout,
) async {
  // Creates a list to store the results
  final results = <T>[];

  // Subscribes to the stream
  final subscription = stream.listen(results.add);

  // Starts a timer
  Timer(timeout, subscription.cancel);
  // Waits for the stream to finish emitting events
  // ignore: inference_failure_on_function_invocation
  return Future.delayed(timeout, () {
    return results;
  });
}

/// Returns the first result from a stream in a time limit.
///
/// **Arguments:**
///
/// * `stream`: The stream from which to obtain the result.
/// * `timeout`: The time limit in milliseconds.
///
/// **Returns:**
///
/// The first result from the stream, or throws an exception if no result is obtained within the timeout.
///
/// **Example:**
///
/// ```dart
/// // Creates a stream that emits numbers after 1 second
/// Stream<int> generateNumbers() async* {
///   await Future.delayed(Duration(seconds: 1));
///   yield 10;
/// }
///
/// // Gets the first result of the stream in a time limit of 2 seconds
/// Future<int> firstResult = getStreamFirstResultInTimeLimit(generateNumbers(), 2000);
///
/// // Handles the exception that can be thrown if no result is obtained within the time limit
/// try {
///   // Prints the first result
///   print(await firstResult);
/// } catch (e) {
///   // Handles the exception
///   print(e);
/// }
/// ```
///
/// **Output:**
///
/// ```
/// 10
/// ```

Future<T?> getStreamFirstResultInTimeLimit<T>(
  Stream<T> stream,
  Duration timeout,
) async {
  // Creates a variable to store the first result
  T? firstResult;

  // Subscribes to the stream
  final subscription = stream.listen((event) {
    // If this is the first result, stores it
    firstResult ??= event;
  });

  // Starts a timer to cancel the subscription after the timeout
  Timer(timeout, subscription.cancel);

  // Waits for the stream to finish emitting events or for the timeout to expire
  await Future<void>.delayed(timeout);

  // If a result was obtained, returns it
  if (firstResult != null) {
    return firstResult;
  } else {
    // If no result was obtained, throws an exception
    throw TimeoutException('No result obtained within the timeout');
  }
}

Future<T?> getFirstResultInStream<T>(
  Stream<T> stream,
  Duration timeout,
) async {
  // Creates a Completer to store the first result
  final firstResultCompleter = Completer<T?>();

// Subscribes to the stream
  final subscription = stream.listen((event) {
    // If this is the first result, completes the Completer
    if (firstResultCompleter.isCompleted) return;
    firstResultCompleter.complete(event);
  });

// Starts a timer to cancel the subscription after the timeout
  Timer(timeout, subscription.cancel);

// Returns the Completer's Future. This Future will complete when the first result is received or when the timeout expires.
  return firstResultCompleter.future.timeout(timeout);
}

// This is a reimplementation of BehaviorSubject from RxDart library.
// It is essentially a stream but:
//  1. we cache the latestValue of the stream
//  2. the "latestValue" is re-emitted whenever the stream is listened to
class _StreamController<T> {
  _StreamController({required T initialValue}) : latestValue = initialValue;
  T latestValue;

  final StreamController<T> _controller = StreamController<T>.broadcast();

  Stream<T> get stream {
    if (latestValue != null) {
      return _controller.stream.newStreamWithInitialValue(latestValue!);
    } else {
      return _controller.stream;
    }
  }

  T get value => latestValue;

  void add(T newValue) {
    latestValue = newValue;
    _controller.add(newValue);
  }

  void listen(
    Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    onData(latestValue);
    _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<void> close() {
    return _controller.close();
  }
}

// imediately starts listening to a broadcast stream and
// buffering it in a new single-subscription stream
class _BufferStream<T> {
  _BufferStream.listen(this._inputStream) {
    _controller = StreamController<T>(
      onCancel: () {
        _subscription?.cancel();
      },
      onPause: () {
        _subscription?.pause();
      },
      onResume: () {
        _subscription?.resume();
      },
      onListen: () {}, // inputStream is already listened to
    );

    // immediately start listening to the inputStream
    _subscription = _inputStream.listen(
      (data) {
        hasReceivedValue = true;
        _controller.add(data);
      },
      onError: (e) {
        _controller.addError(e as Object);
      },
      onDone: () {
        _controller.close();
      },
      cancelOnError: false,
    );
  }
  final Stream<T> _inputStream;
  late final StreamSubscription? _subscription;
  late final StreamController<T> _controller;
  late bool hasReceivedValue = false;

  void close() {
    _subscription?.cancel();
    _controller.close();
  }

  Stream<T> get stream async* {
    yield* _controller.stream;
  }
}

// Helper for 'newStreamWithInitialValue' method for streams.
class _NewStreamWithInitialValueTransformer<T>
    extends StreamTransformerBase<T, T> {
  _NewStreamWithInitialValueTransformer(this.initialValue);
  final T initialValue;

  @override
  Stream<T> bind(Stream<T> stream) {
    if (stream.isBroadcast) {
      return _bind(stream).asBroadcastStream();
    } else {
      return _bind(stream);
    }
  }

  Stream<T> _bind(Stream<T> stream) {
    StreamController<T>? controller;
    StreamSubscription<T>? subscription;

    controller = StreamController<T>(
      onListen: () {
        // Emit the initial value
        controller?.add(initialValue);

        subscription = stream.listen(
          controller?.add,
          onError: (Object error) {
            controller?.addError(error);
            controller?.close();
          },
          onDone: controller?.close,
        );
      },
      onPause: ([Future<dynamic>? resumeSignal]) {
        subscription?.pause(resumeSignal);
      },
      onResume: () {
        subscription?.resume();
      },
      onCancel: () {
        return subscription?.cancel();
      },
      sync: true,
    );

    return controller.stream;
  }
}

extension _StreamNewStreamWithInitialValue<T> on Stream<T> {
  Stream<T> newStreamWithInitialValue(T initialValue) {
    return transform(_NewStreamWithInitialValueTransformer(initialValue));
  }
}

// ignore: unused_element
Stream<T> _mergeStreams<T>(List<Stream<T>> streams) {
  final controller = StreamController<T>();
  final subscriptions = <StreamSubscription<T>>[];

  void handleData(T data) {
    if (!controller.isClosed) {
      controller.add(data);
    }
  }

  void handleError(Object error, StackTrace stackTrace) {
    if (!controller.isClosed) {
      controller.addError(error, stackTrace);
    }
  }

  void handleDone() {
    if (subscriptions.every((s) => s.isPaused)) {
      controller.close();
    }
  }

  void subscribeToStream(Stream<T> stream) {
    final s =
        stream.listen(handleData, onError: handleError, onDone: handleDone);
    subscriptions.add(s);
  }

  streams.forEach(subscribeToStream);

  controller.onCancel = () async {
    await Future.wait(subscriptions.map((s) => s.cancel()));
  };

  return controller.stream;
}

// dart is single threaded, but still has task switching.
// this mutex lets a single task through at a time.
class _Mutex {
  final StreamController _controller = StreamController.broadcast();
  int current = 0;
  int issued = 0;

  Future<void> take() async {
    final mine = issued;
    issued++;
    // tasks are executed in the same order they call take()
    while (mine != current) {
      await _controller.stream.first; // wait
    }
  }

  void give() {
    current++;
    _controller.add(null); // release waiting tasks
  }
}

// Create mutexes in a parrallel-safe way,
class _MutexFactory {
  static final _Mutex _global = _Mutex();
  static final Map<String, _Mutex> _all = {};

  static Future<_Mutex> getMutexForKey(String key) async {
    _Mutex? value;
    await _global.take();
    {
      _all[key] ??= _Mutex();
      value = _all[key];
    }
    _global.give();
    return value!;
  }
}

// String _black(String s) {
//   // Use ANSI escape codes
//   return '\x1B[1;30m$s\x1B[0m';
// }

// // ignore: unused_element
// String _green(String s) {
//   // Use ANSI escape codes
//   return '\x1B[1;32m$s\x1B[0m';
// }

// String _magenta(String s) {
//   // Use ANSI escape codes
//   return '\x1B[1;35m$s\x1B[0m';
// }

// String _brown(String s) {
//   // Use ANSI escape codes
//   return '\x1B[1;33m$s\x1B[0m';
// }

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  /// returns first item to satisfy `test`, else null
  T? _firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

extension RemoveWhere<T> on List<T> {
  /// returns true if some items where removed
  bool _removeWhere(bool Function(T) test) {
    final initialLength = length;
    removeWhere(test);
    return length != initialLength;
  }
}

// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

String _hexEncode(List<int> numbers) {
  return numbers
      .map((n) => (n & 0xFF).toRadixString(16).padLeft(2, '0'))
      .join();
}

List<int> _hexDecode(String hex) {
  final numbers = <int>[];
  for (var i = 0; i < hex.length; i += 2) {
    final hexPart = hex.substring(i, i + 2);
    final num = int.parse(hexPart, radix: 16);
    numbers.add(num);
  }
  return numbers;
}

class Guid {
  Guid(String input) : this._internal(_fromString(input));

  Guid._internal(List<int> bytes)
      : _bytes = bytes,
        _hashCode = _calcHashCode(bytes);

  Guid.fromMac(String input) : this._internal(_fromMacString(input));

  Guid.empty() : this._internal(List.filled(16, 0));
  final List<int> _bytes;
  final int _hashCode;

  static List<int> _fromMacString(String input) {
    input = _removeNonHexCharacters(input);
    final bytes = _hexDecode(input);

    if (bytes.length != 6) {
      throw FormatException(
        'Guid.fromString: The guid format is invalid: $input',
      );
    }

    return bytes + List<int>.filled(10, 0);
  }

  static List<int> _fromString(String input) {
    // If input has empty value assign a default value
    if (input.isEmpty) {
      input = '00000000-0000-0000-0000-000000000000';
    }

    input = _removeNonHexCharacters(input);
    final bytes = _hexDecode(input);

    if (bytes.length != 16) {
      throw FormatException(
        'Guid.fromString: The guid format is invalid: $input',
      );
    }

    return bytes;
  }

  static String _removeNonHexCharacters(String sourceString) {
    return String.fromCharCodes(
      sourceString.runes.where(
        (r) =>
            (r >= 48 && r <= 57) || // characters 0 to 9
            (r >= 65 && r <= 70) || // characters A to F
            (r >= 97 && r <= 102), // characters a to f
      ),
    );
  }

  static int _calcHashCode(List<int> bytes) {
    const prime1 = 9007199254740881;
    const prime2 = 8388880508472777;
    var hash = 0;
    for (final value in bytes) {
      hash = (hash * prime1 + value) % prime2;
    }
    return hash;
  }

  @override
  String toString() {
    final one = _hexEncode(_bytes.sublist(0, 4));
    final two = _hexEncode(_bytes.sublist(4, 6));
    final three = _hexEncode(_bytes.sublist(6, 8));
    final four = _hexEncode(_bytes.sublist(8, 10));
    final five = _hexEncode(_bytes.sublist(10, 16));
    return '$one-$two-$three-$four-$five';
  }

  String toMac() {
    final one = _hexEncode(_bytes.sublist(0, 1));
    final two = _hexEncode(_bytes.sublist(1, 2));
    final three = _hexEncode(_bytes.sublist(2, 3));
    final four = _hexEncode(_bytes.sublist(3, 4));
    final five = _hexEncode(_bytes.sublist(4, 5));
    final six = _hexEncode(_bytes.sublist(5, 6));
    return '$one:$two:$three:$four:$five:$six'.toUpperCase();
  }

  List<int> toByteArray() {
    return _bytes;
  }

  @override
  bool operator ==(Object other) => other is Guid && hashCode == other.hashCode;

  @override
  int get hashCode => _hashCode;
}

extension AddOrUpdate<T> on List<T> {
  /// add an item to a list, or update item if it already exists
  void addOrUpdate(T item) {
    final index = indexOf(item);
    if (index != -1) {
      this[index] = item;
    } else {
      add(item);
    }
  }
}

String _black(String s) {
  // Use ANSI escape codes
  return '\x1B[1;30m$s\x1B[0m';
}

// ignore: unused_element
String _green(String s) {
  // Use ANSI escape codes
  return '\x1B[1;32m$s\x1B[0m';
}

String _magenta(String s) {
  // Use ANSI escape codes
  return '\x1B[1;35m$s\x1B[0m';
}

String _brown(String s) {
  // Use ANSI escape codes
  return '\x1B[1;33m$s\x1B[0m';
}
