//
//  String+RTL.swift
//  RTLLanguageDetection
//
//  Created by Pavel Akhrameev on 7/20/22.
//

import Foundation

public extension String {
    var isRTL: Bool {
        guard !isEmpty else { return false }

        let cfString = self as CFString
        let bestLanguage = CFStringTokenizerCopyBestStringLanguage(cfString,
                                                                   CFRange(location: 0,
                                                                           length: CFStringGetLength(cfString)))
        guard let language = bestLanguage as? String else {
            return false
        }
        return ["he", "ar", "fa", "ur"].contains(language)
    }
}
