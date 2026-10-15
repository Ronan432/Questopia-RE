/// FFI signatures of the `QSPSetCallback` family used by `QspCallbackBridge`.
///
/// The native declarations live in `native/qsp/qsp/bindings/qsp.h`; the `Dart*`
/// forms are what `lookupFunction` and the registered closures are typed with.
library;

import 'dart:ffi';

import 'qsp_utf16.dart';

typedef NativeStrCallback = Void Function(QSPStringStruct);
typedef NativeStrIntCallback = Void Function(QSPStringStruct, Int32);
typedef NativeIntCallback = Void Function(Int32);
typedef NativeIntBoolCallback = Void Function(Int32, Int8);
typedef NativeBoolCallback = Void Function(Int8);

/// A callback that answers a question in the engine, such as the current
/// playing state of a file.
///
/// The native `QSPSetCallback` signature declares these as `int (*)()`, so the
/// return type is a C `int` and must stay [Int32]. Declaring it as [Int64]
/// happens to work on the 64-bit MSVC and SysV conventions for the callbacks
/// the engine reads anyway, but a callback that actually consumes the returned
/// value (`showMenu`, `isPlayingFile`) would be read from the wrong register
/// half on every ABI where the two differ.
typedef NativeIntResultCallback = Int32 Function();

typedef NativeSetCallback = Void Function(
    Int32, Pointer<NativeFunction<NativeIntResultCallback>>);

typedef DartStrCallback = void Function(QSPStringStruct);
typedef DartStrIntCallback = void Function(QSPStringStruct, int);
typedef DartIntCallback = void Function(int);
typedef DartIntBoolCallback = void Function(int, int);
typedef DartBoolCallback = void Function(int);
typedef DartIntResultCallback = int Function();
typedef DartSetCallback = void Function(
    int, Pointer<NativeFunction<NativeIntResultCallback>>);
