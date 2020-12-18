// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// About
  internal static let about = L10n.tr("Localizable", "about")
  /// Acknowledgements
  internal static let acknowledgements = L10n.tr("Localizable", "acknowledgements")
  /// Alt (Dark)
  internal static let altDarkIcon = L10n.tr("Localizable", "alt_dark_icon")
  /// Alt (Light)
  internal static let altLightIcon = L10n.tr("Localizable", "alt_light_icon")
  /// App Icon
  internal static let appIcon = L10n.tr("Localizable", "app_icon")
  /// Adequate
  internal static let appName = L10n.tr("Localizable", "app_name")
  /// Appearance
  internal static let appearance = L10n.tr("Localizable", "appearance")
  /// Authentication Error: %@
  internal static func authenticationError(_ p1: Any) -> String {
    return L10n.tr("Localizable", "authentication_error", String(describing: p1))
  }
  /// Bad Request
  internal static let badRequest = L10n.tr("Localizable", "bad_request")
  /// Buy
  internal static let buy = L10n.tr("Localizable", "buy")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Daily Notifications
  internal static let dailyNotifications = L10n.tr("Localizable", "daily_notifications")
  /// Data Serialization Error: %@
  internal static func dataSerializationError(_ p1: Any) -> String {
    return L10n.tr("Localizable", "data_serialization_error", String(describing: p1))
  }
  /// Default (Dark)
  internal static let defaultDarkIcon = L10n.tr("Localizable", "default_dark_icon")
  /// Default
  internal static let defaultIcon = L10n.tr("Localizable", "default_icon")
  /// Device is not configured to send email.
  internal static let disabledEmailAlertBody = L10n.tr("Localizable", "disabled_email_alert_body")
  /// Sorry, Adequate is not allowed to change its icon.
  internal static let disabledIconChangeAlertBody = L10n.tr("Localizable", "disabled_icon_change_alert_body")
  /// Notifications are disabled. Please allow Adequate to access notifications in Settings.
  internal static let disabledNotificationAlertBody = L10n.tr("Localizable", "disabled_notification_alert_body")
  /// Dismiss
  internal static let dismiss = L10n.tr("Localizable", "dismiss")
  /// Email
  internal static let email = L10n.tr("Localizable", "email")
  /// There are no deals
  internal static let emptyHistoryMessage = L10n.tr("Localizable", "empty_history_message")
  /// There was no data
  internal static let emptyMessage = L10n.tr("Localizable", "empty_message")
  /// Operation returned neither result not error.
  internal static let emptyOperationHandler = L10n.tr("Localizable", "empty_operation_handler")
  /// Result contained neither data nor error.
  internal static let emptyResult = L10n.tr("Localizable", "empty_result")
  /// Error
  internal static let error = L10n.tr("Localizable", "error")
  /// Forum
  internal static let forum = L10n.tr("Localizable", "forum")
  /// History
  internal static let history = L10n.tr("Localizable", "history")
  /// Unable to decode image
  internal static let imageDecodingFailed = L10n.tr("Localizable", "image_decoding_failed")
  /// JSON Serialization Error: %@
  internal static func jsonSerializationError(_ p1: Any) -> String {
    return L10n.tr("Localizable", "json_serialization_error", String(describing: p1))
  }
  /// LOADING
  internal static let loadingMessage = L10n.tr("Localizable", "loading_message")
  /// Meh
  internal static let meh = L10n.tr("Localizable", "meh")
  /// Unable to initialize client
  internal static let missingClient = L10n.tr("Localizable", "missing_client")
  /// Missing data for %@
  internal static func missingField(_ p1: Any) -> String {
    return L10n.tr("Localizable", "missing_field", String(describing: p1))
  }
  /// Network Error: %@
  internal static func networkError(_ p1: Any) -> String {
    return L10n.tr("Localizable", "network_error", String(describing: p1))
  }
  /// Notifications
  internal static let notifications = L10n.tr("Localizable", "notifications")
  /// Not Now
  internal static let nowNow = L10n.tr("Localizable", "now_now")
  /// Object Serialization Error: %@
  internal static func objectSerializationError(_ p1: Any) -> String {
    return L10n.tr("Localizable", "object_serialization_error", String(describing: p1))
  }
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok")
  /// Privacy Policy
  internal static let privacyPolicy = L10n.tr("Localizable", "privacy_policy")
  /// Retry
  internal static let retry = L10n.tr("Localizable", "retry")
  /// Rate Adequate
  internal static let reviewApp = L10n.tr("Localizable", "review_app")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "settings")
  /// Share
  internal static let share = L10n.tr("Localizable", "share")
  /// Check out this deal
  internal static let sharingActivityText = L10n.tr("Localizable", "sharing_activity_text")
  /// Sold Out
  internal static let soldOut = L10n.tr("Localizable", "sold_out")
  /// Story
  internal static let story = L10n.tr("Localizable", "story")
  /// Support
  internal static let support = L10n.tr("Localizable", "support")
  /// Theme
  internal static let theme = L10n.tr("Localizable", "theme")
  /// Dark
  internal static let themeDark = L10n.tr("Localizable", "theme_dark")
  /// Light
  internal static let themeLight = L10n.tr("Localizable", "theme_light")
  /// System
  internal static let themeSystem = L10n.tr("Localizable", "theme_system")
  /// Twitter
  internal static let twitter = L10n.tr("Localizable", "twitter")
  /// Unknown Error: %@
  internal static func unknownError(_ p1: Any) -> String {
    return L10n.tr("Localizable", "unknown_error", String(describing: p1))
  }
  /// This is an unofficial app. Please direct any issues to the developer, not to Meh.
  internal static let unofficialAppDisclaimer = L10n.tr("Localizable", "unofficial_app_disclaimer")
  /// Web
  internal static let web = L10n.tr("Localizable", "web")
  /// See the crap meh is selling today.
  internal static let welcomeMessage = L10n.tr("Localizable", "welcome_message")
  /// Enable notifications so Adequate can alert you when meh offers a new daily deal.
  internal static let welcomeNotificationsBody = L10n.tr("Localizable", "welcome_notifications_body")
  /// Enable Notifications?
  internal static let welcomeNotificationsTitle = L10n.tr("Localizable", "welcome_notifications_title")
  /// View the current deal on Meh.
  internal static let widgetExtensionDescription = L10n.tr("Localizable", "widget_extension_description")
  /// Current Deal
  internal static let widgetExtensionName = L10n.tr("Localizable", "widget_extension_name")
  /// Some Great New Deal
  internal static let widgetExtensionPlaceholderTitle = L10n.tr("Localizable", "widget_extension_placeholder_title")

  internal enum Accessibility {
    /// Buy
    internal static let buyButton = L10n.tr("Localizable", "accessibility.buy_button")
    /// Show Deal
    internal static let dealButton = L10n.tr("Localizable", "accessibility.deal_button")
    /// Show History
    internal static let historyButton = L10n.tr("Localizable", "accessibility.history_button")
    /// Left Chevron Button
    internal static let leftChevronButton = L10n.tr("Localizable", "accessibility.left_chevron_button")
    /// Right Chevron Button
    internal static let rightChevronButton = L10n.tr("Localizable", "accessibility.right_chevron_button")
    /// Show Settings
    internal static let settingsButton = L10n.tr("Localizable", "accessibility.settings_button")
    /// Share Deal
    internal static let shareButton = L10n.tr("Localizable", "accessibility.share_button")
    /// Show Story
    internal static let storyButton = L10n.tr("Localizable", "accessibility.story_button")
  }

  internal enum Comments {
    /// %d Comment(s)
    internal static func count(_ p1: Int) -> String {
      return L10n.tr("Localizable", "comments.count", p1)
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
