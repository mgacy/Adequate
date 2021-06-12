// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Error {
    /// Client Error: %d
    internal static func clientError(_ p1: Int) -> String {
      return L10n.tr("Localizable", "error.client_error", p1)
    }
    /// Decoding Error: %@
    internal static func decoding(_ p1: Any) -> String {
      return L10n.tr("Localizable", "error.decoding", String(describing: p1))
    }
    /// Unexpexted Response Format: %@
    internal static func invalidResponse(_ p1: Any) -> String {
      return L10n.tr("Localizable", "error.invalid_response", String(describing: p1))
    }
    /// Malformed Request
    internal static let malformedRequest = L10n.tr("Localizable", "error.malformed_request")
    /// Network Error: %@
    internal static func network(_ p1: Any) -> String {
      return L10n.tr("Localizable", "error.network", String(describing: p1))
    }
    /// Missing Data
    internal static let noData = L10n.tr("Localizable", "error.no_data")
    /// Server Error: %d
    internal static func serverError(_ p1: Int) -> String {
      return L10n.tr("Localizable", "error.server_error", p1)
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

