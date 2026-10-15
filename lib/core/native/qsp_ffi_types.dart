/// Native and Dart signatures for the exported QSP C-API.
///
/// Kept apart from `QspFfi` so the binding declarations can be read as one
/// table. Every `Native*` type is the raw C signature and every `Dart*` type is
/// its Dart-side counterpart; `lookupFunction` pairs them.
library;

import 'dart:ffi';

import 'qsp_utf16.dart';

// Native typedefs
typedef NativeQSPInit = Void Function();
typedef NativeQSPTerminate = Void Function();
typedef NativeQSPGetVersion = QSPStringStruct Function();
typedef NativeQSPGetMainDesc = QSPStringStruct Function();
typedef NativeQSPGetVarsDesc = QSPStringStruct Function();

typedef NativeQSPGetActions = Int32 Function(
    Pointer<QSPListItemStruct> items, Int32 bufSize);
typedef NativeQSPSetSelActionIndex = Int8 Function(
    Int32 index, Int32 toRefreshUI);
typedef NativeQSPExecuteSelActionCode = Int8 Function(Int32 toRefreshUI);

typedef NativeQSPGetObjects = Int32 Function(
    Pointer<QSPListItemStruct> items, Int32 bufSize);
typedef NativeQSPSetSelObjectIndex = Int8 Function(
    Int32 index, Int32 toRefreshUI);

typedef NativeQSPExecString = Int8 Function(
    QSPStringStruct str, Int32 toRefreshUI);
typedef NativeQSPLoadGameWorldFromData = Int8 Function(
    Pointer<Uint8> data, Int32 size, Int32 isNewGame);
typedef NativeQSPOpenSavedGameFromData = Int8 Function(
    Pointer<Uint8> data, Int32 size, Int32 toRefreshUI);
typedef NativeQSPSaveGameAsData = Int8 Function(
    Pointer<Uint8> buf, Pointer<Int32> bufSize, Int32 toRefreshUI);
typedef NativeQSPRestartGame = Int8 Function(Int32 toRefreshUI);
typedef NativeQSPGetLastErrorData = QSPErrorInfoStruct Function();

/// Native `int (*)()` callback slot of `QSPSetCallback`. The C `int` return
/// type is [Int32], not [Int64].
typedef NativeQspCallback = Int32 Function();

typedef NativeQSPSetCallback = Void Function(
    Int32, Pointer<NativeFunction<NativeQspCallback>>);
typedef NativeQSPExecCounter = Int8 Function(Int32 toRefreshUI);

typedef NativeQSPGetVarValue = Int32 Function(QSPStringStruct name, Int32 index,
    Pointer<Void> variantRes); // Simplified for primitive lookup

/// Native out-parameter of `QSPGetNumVarValue` is `QSP_BIGINT *`.
///
/// [Int32] is correct only while `QSP_USE_BIGINT` stays undefined, because
/// `native/qsp/qsp/bindings/qsp.h` then declares `typedef int QSP_BIGINT`. If
/// that macro is ever enabled for the native build, this declaration must
/// become [Int64] in the same change or the engine writes past the buffer.
typedef NativeQSPGetNumVarValue = Int8 Function(
    QSPStringStruct name, Int32 index, Pointer<Int32> res);
typedef NativeQSPGetStrVarValue = Int8 Function(
    QSPStringStruct name, Int32 index, Pointer<QSPStringStruct> res);

// Dart typedefs
typedef DartQSPInit = void Function();
typedef DartQSPTerminate = void Function();
typedef DartQSPGetVersion = QSPStringStruct Function();
typedef DartQSPGetMainDesc = QSPStringStruct Function();
typedef DartQSPGetVarsDesc = QSPStringStruct Function();

typedef DartQSPGetActions = int Function(
    Pointer<QSPListItemStruct> items, int bufSize);
typedef DartQSPSetSelActionIndex = int Function(int index, int toRefreshUI);
typedef DartQSPExecuteSelActionCode = int Function(int toRefreshUI);

typedef DartQSPGetObjects = int Function(
    Pointer<QSPListItemStruct> items, int bufSize);
typedef DartQSPSetSelObjectIndex = int Function(int index, int toRefreshUI);

typedef DartQSPExecString = int Function(QSPStringStruct str, int toRefreshUI);
typedef DartQSPLoadGameWorldFromData = int Function(
    Pointer<Uint8> data, int size, int isNewGame);
typedef DartQSPOpenSavedGameFromData = int Function(
    Pointer<Uint8> data, int size, int toRefreshUI);
typedef DartQSPSaveGameAsData = int Function(
    Pointer<Uint8> buf, Pointer<Int32> bufSize, int toRefreshUI);
typedef DartQSPRestartGame = int Function(int toRefreshUI);
typedef DartQSPGetLastErrorData = QSPErrorInfoStruct Function();
typedef DartQSPSetCallback = void Function(
    int, Pointer<NativeFunction<NativeQspCallback>>);
typedef DartQSPExecCounter = int Function(int toRefreshUI);

typedef DartQSPGetNumVarValue = int Function(
    QSPStringStruct name, int index, Pointer<Int32> res);
typedef DartQSPGetStrVarValue = int Function(
    QSPStringStruct name, int index, Pointer<QSPStringStruct> res);
