import Foundation

public enum AppLocale: Sendable {
    case en
    case zhHant

    public static let current: AppLocale = detect()

    private static func detect() -> AppLocale {
        // Check LC_ALL, LC_MESSAGES, LANG in priority order
        let env = ProcessInfo.processInfo.environment
        let raw = env["LC_ALL"] ?? env["LC_MESSAGES"] ?? env["LANG"] ?? "en_US.UTF-8"
        if raw.hasPrefix("zh_TW") || raw.hasPrefix("zh_Hant") {
            return .zhHant
        }
        return .en
    }
}
