// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Common {
    /// 
    internal static let blank = L10n.tr("Localizable", "Common.Blank")
  }

  internal enum Error {
    internal enum Unknown {
      /// 不明なエラーが発生しました
      internal static let description = L10n.tr("Localizable", "Error.Unknown.Description")
    }
  }

  internal enum ReloadableErrorView {
    internal enum Button {
      /// 再読み込み
      internal static let title = L10n.tr("Localizable", "ReloadableErrorView.Button.Title")
    }
  }

  internal enum RepositoryDetail {
    internal enum DetailLabel {
      /// %@ / ☆ %@
      internal static func text(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "RepositoryDetail.DetailLabel.Text", String(describing: p1), String(describing: p2))
      }
    }
  }

  internal enum RepositorySearch {
    internal enum DetailLabel {
      /// %@ / ☆ %@
      internal static func text(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "RepositorySearch.DetailLabel.Text", String(describing: p1), String(describing: p2))
      }
    }
    internal enum OwnerNameLabel {
      /// %@ /
      internal static func text(_ p1: Any) -> String {
        return L10n.tr("Localizable", "RepositorySearch.OwnerNameLabel.Text", String(describing: p1))
      }
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
