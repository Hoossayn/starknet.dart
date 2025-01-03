// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated class from Pigeon that represents data sent in messages.
struct AndroidPromptInfos {
  var title: String
  var subtitle: String?
  var description: String?
  var cancelLabel: String
  var confirmationRequired: Bool

  static func fromList(_ list: [Any?]) -> AndroidPromptInfos? {
    let title = list[0] as! String
    let subtitle: String? = nilOrValue(list[1])
    let description: String? = nilOrValue(list[2])
    let cancelLabel = list[3] as! String
    let confirmationRequired = list[4] as! Bool

    return AndroidPromptInfos(
      title: title,
      subtitle: subtitle,
      description: description,
      cancelLabel: cancelLabel,
      confirmationRequired: confirmationRequired
    )
  }

  func toList() -> [Any?] {
    [
      title,
      subtitle,
      description,
      cancelLabel,
      confirmationRequired,
    ]
  }
}

/// Android-specific options for biometric authentication.
///
/// Generated class from Pigeon that represents data sent in messages.
struct AndroidOptions {
  /// Details of the prompt to show to the user.
  var promptInfo: AndroidPromptInfos?
  /// The duration in seconds for which the authentication is valid. If the
  /// user sets it to -1 (default), user must authenticate each time they want
  /// to get or set a secret.
  var authenticationValidityDurationSeconds: Int64
  /// Whether to use the StrongBox hardware-backed keystore.
  /// This feature seems to cause
  /// [crashes](https://github.com/authpass/biometric_storage/issues/76),
  /// enable with caution.
  var enableStrongBox: Bool

  static func fromList(_ list: [Any?]) -> AndroidOptions? {
    var promptInfo: AndroidPromptInfos?
    if let promptInfoList: [Any?] = nilOrValue(list[0]) {
      promptInfo = AndroidPromptInfos.fromList(promptInfoList)
    }
    let authenticationValidityDurationSeconds = list[1] is Int64 ? list[1] as! Int64 :
      Int64(list[1] as! Int32)
    let enableStrongBox = list[2] as! Bool

    return AndroidOptions(
      promptInfo: promptInfo,
      authenticationValidityDurationSeconds: authenticationValidityDurationSeconds,
      enableStrongBox: enableStrongBox
    )
  }

  func toList() -> [Any?] {
    [
      promptInfo?.toList(),
      authenticationValidityDurationSeconds,
      enableStrongBox,
    ]
  }
}

/// Platform-specific options for biometric authentication.
///
/// Generated class from Pigeon that represents data sent in messages.
struct BiometricOptions {
  /// Android-specific options.
  var androidOptions: AndroidOptions?

  static func fromList(_ list: [Any?]) -> BiometricOptions? {
    var androidOptions: AndroidOptions?
    if let androidOptionsList: [Any?] = nilOrValue(list[0]) {
      androidOptions = AndroidOptions.fromList(androidOptionsList)
    }

    return BiometricOptions(
      androidOptions: androidOptions
    )
  }

  func toList() -> [Any?] {
    [
      androidOptions?.toList(),
    ]
  }
}

private class SecureStoreBridgeCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 128:
      return AndroidOptions.fromList(readValue() as! [Any?])
    case 129:
      return AndroidPromptInfos.fromList(readValue() as! [Any?])
    case 130:
      return BiometricOptions.fromList(readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class SecureStoreBridgeCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? AndroidOptions {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? AndroidPromptInfos {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? BiometricOptions {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class SecureStoreBridgeCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    SecureStoreBridgeCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    SecureStoreBridgeCodecWriter(data: data)
  }
}

class SecureStoreBridgeCodec: FlutterStandardMessageCodec {
  static let shared = SecureStoreBridgeCodec(readerWriter: SecureStoreBridgeCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol SecureStoreBridge {
  func storeSecret(key: String, privateKey: FlutterStandardTypedData,
                   biometricOptions: BiometricOptions?,
                   completion: @escaping (Result<Void, Error>) -> Void)
  func removeSecret(key: String, completion: @escaping (Result<Void, Error>) -> Void)
  func getSecret(key: String, biometricOptions: BiometricOptions?,
                 completion: @escaping (Result<FlutterStandardTypedData?, Error>) -> Void)
  func isBiometryAvailable() throws -> Bool
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class SecureStoreBridgeSetup {
  /// The codec used by SecureStoreBridge.
  static var codec: FlutterStandardMessageCodec { SecureStoreBridgeCodec.shared }
  /// Sets up an instance of `SecureStoreBridge` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: SecureStoreBridge?) {
    let storeSecretChannel = FlutterBasicMessageChannel(
      name: "dev.flutter.pigeon.secure_store.SecureStoreBridge.storeSecret",
      binaryMessenger: binaryMessenger,
      codec: codec
    )
    if let api {
      storeSecretChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let privateKeyArg = args[1] as! FlutterStandardTypedData
        let biometricOptionsArg: BiometricOptions? = nilOrValue(args[2])
        api.storeSecret(
          key: keyArg,
          privateKey: privateKeyArg,
          biometricOptions: biometricOptionsArg
        ) { result in
          switch result {
          case .success:
            reply(wrapResult(nil))
          case let .failure(error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      storeSecretChannel.setMessageHandler(nil)
    }
    let removeSecretChannel = FlutterBasicMessageChannel(
      name: "dev.flutter.pigeon.secure_store.SecureStoreBridge.removeSecret",
      binaryMessenger: binaryMessenger,
      codec: codec
    )
    if let api {
      removeSecretChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        api.removeSecret(key: keyArg) { result in
          switch result {
          case .success:
            reply(wrapResult(nil))
          case let .failure(error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      removeSecretChannel.setMessageHandler(nil)
    }
    let getSecretChannel = FlutterBasicMessageChannel(
      name: "dev.flutter.pigeon.secure_store.SecureStoreBridge.getSecret",
      binaryMessenger: binaryMessenger,
      codec: codec
    )
    if let api {
      getSecretChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let biometricOptionsArg: BiometricOptions? = nilOrValue(args[1])
        api.getSecret(key: keyArg, biometricOptions: biometricOptionsArg) { result in
          switch result {
          case let .success(res):
            reply(wrapResult(res))
          case let .failure(error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      getSecretChannel.setMessageHandler(nil)
    }
    let isBiometryAvailableChannel = FlutterBasicMessageChannel(
      name: "dev.flutter.pigeon.secure_store.SecureStoreBridge.isBiometryAvailable",
      binaryMessenger: binaryMessenger,
      codec: codec
    )
    if let api {
      isBiometryAvailableChannel.setMessageHandler { _, reply in
        do {
          let result = try api.isBiometryAvailable()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      isBiometryAvailableChannel.setMessageHandler(nil)
    }
  }
}
