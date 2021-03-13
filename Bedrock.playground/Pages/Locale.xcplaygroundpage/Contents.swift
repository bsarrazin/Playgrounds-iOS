import RxCocoa
import RxSwift

public extension Locale {
    /* Generates an rfc2616 accept language string to be used with rest requests.
     Defaults to current language in current region, current language, english in the current region then english.
     */
    public func rfc2616AcceptLanguage() -> String {
        var langs: [String] = []
        
        langs.append([languageCode, regionCode].compactMap({ $0 }).joined(separator: "-").lowercased())
        
        if let languageCode = languageCode, languageCode.lowercased() != "en" {
            langs.append(languageCode.lowercased() + ";q=0.9")
            langs.append(["en", regionCode].compactMap({ $0 }).joined(separator: "-").lowercased() + ";q=0.8")
        }
        
        if regionCode != nil || langs.isEmpty {
            langs.append("en;q=0.7")
        }
        
        return langs
            .compactMap { $0.isEmpty ? nil : $0 }
            .joined(separator: ",")
    }
}


Locale(identifier: "en_AU").rfc2616AcceptLanguage()
Locale(identifier: "en-AU").rfc2616AcceptLanguage()
Locale(identifier: "en_GB").rfc2616AcceptLanguage()
Locale(identifier: "en-GB").rfc2616AcceptLanguage()
Locale(identifier: "en_US").rfc2616AcceptLanguage()
Locale(identifier: "en-US").rfc2616AcceptLanguage()
