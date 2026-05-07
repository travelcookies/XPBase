import Foundation
import UIKit

/// 语言管理器（XP命名空间版本）
/// 用于管理应用的多语言切换功能，支持中文和英文两种语言
///
/// 使用示例：
/// ```swift
/// // 获取当前语言
/// let currentLanguage = XPLanguageManager.shared.language
/// 
/// // 判断当前是否为中文环境
/// let isChinese = XPLanguageManager.localeIsChinese()
/// 
/// // 获取当前语言设置（从UserDefaults读取）
/// let savedLanguage = XPLanguageManager.currentLanguage()
/// 
/// // 保存语言设置
/// XPLanguageManager.saveLanguage(chooseLanguage: .English)
/// 
/// // 切换语言（带完成回调）
/// XPLanguageManager.shared.changeLanguage(to: .Chinese) {
///     print("语言切换完成")
/// }
/// 
/// // 显示语言选择器
/// XPLanguageManager.shared.showLanguageSelector(in: self)
/// 
/// // 使用本地化字符串
/// let title = "Hello".localized() // 根据当前语言返回对应翻译
/// let englishTitle = "Hello".localized(with: .English) // 强制使用英文
/// ```
public class XPLanguageManager: NSObject {
    fileprivate static let kChooseLanguageKey = "XPChooseLanguage"
    
    public static let shared = XPLanguageManager()
    
    public var language: Language
    
    override private init() {
        language = XPLanguageManager.localeIsChinese() ? .Chinese : .English
        super.init()
    }
    
    public enum Language: String {
        case Chinese = "zh-Hans"
        case English = "en"
        
        public var code: String {
            return rawValue
        }
        
        public var headerCode: String {
            switch self {
            case .Chinese:
                return "zh-CN"
            case .English:
                return "en-US"
            }
        }
    }
    
    public static func localeIsChinese() -> Bool {
        if let lang = Locale.preferredLanguages.first {
            return lang.hasPrefix("zh")
        }
        return false
    }
    
    public static func saveLanguage(chooseLanguage: Language) {
        UserDefaults.standard.set(chooseLanguage.rawValue, forKey: XPLanguageManager.kChooseLanguageKey)
        UserDefaults.standard.synchronize()
    }
    
    public static func currentLanguage() -> Language {
        let langString = UserDefaults.standard.string(forKey: kChooseLanguageKey)
        guard let desLangString = langString, let language = Language(rawValue: desLangString) else {
            return .Chinese
        }
        return language
    }
}

extension XPLanguageManager {
    public func changeLanguage(to language: Language, completion: (() -> Void)? = nil) {
        self.language = language
        XPLanguageManager.saveLanguage(chooseLanguage: language)
        completion?()
    }
    
    public func showLanguageSelector(in controller: UIViewController) {
        let alert = UIAlertController(title: "Select Language".localized(), message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "English", style: .default) { [weak self] _ in
            self?.changeLanguage(to: .English)
            self?.restartApplication()
        })
        
        alert.addAction(UIAlertAction(title: "中文", style: .default) { [weak self] _ in
            self?.changeLanguage(to: .Chinese)
            self?.restartApplication()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel))
        
        controller.present(alert, animated: true)
    }
    
    private func restartApplication() {
        if let window = UIApplication.shared.windows.first {
            if let rootViewController = window.rootViewController {
                let newRoot = type(of: rootViewController).init()
                window.rootViewController = newRoot
                window.makeKeyAndVisible()
            }
        }
    }
}

private var bundleByLanguageCode: [String: Bundle] = [:]

extension XPLanguageManager.Language {
    public var bundle: Bundle? {
        if let bundle = bundleByLanguageCode[code] {
            return bundle
        } else {
            let mainBundle = Bundle.main
            if let path = mainBundle.path(forResource: code, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                bundleByLanguageCode[code] = bundle
                return bundle
            } else {
                return nil
            }
        }
    }
}

extension String {
    public func localized(with language: XPLanguageManager.Language? = nil) -> String {
        let targetLanguage = language ?? XPLanguageManager.shared.language
        
        if let bundle = targetLanguage.bundle {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        } else {
            return NSLocalizedString(self, comment: "")
        }
    }
}