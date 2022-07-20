//
//  RTLLanguageDetectionTests.swift
//  RTLLanguageDetectionTests
//
//  Created by Pavel Akhrameev on 7/20/22.
//

import XCTest
import NaturalLanguage

@testable import RTLLanguageDetection

/// Alternative isRTL implementations to compare speed with
public extension String {
    var isRTLbyNL: Bool {
        guard !isEmpty else { return false }

        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self)
        guard let dominantLanguage = recognizer.dominantLanguage else {
            return false
        }
        // I've never got persian here. Please add test string if it exists into 'rtlPersianStrings'
        return [NLLanguage.arabic, NLLanguage.hebrew, NLLanguage.persian, NLLanguage.urdu].contains(dominantLanguage)
    }

    var isRTLbyNSLT: Bool {
        guard !isEmpty else { return false }

        // It's deprecated. Apple suggests to use Natural Language instead.
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.language], options: 0)
        tagger.string = self

        guard let language = tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language, tokenRange: nil,
                                        sentenceRange: nil) else {
            return false
        }
        return ["he", "ar", "fa", "ur"].contains(language.rawValue)
    }
}

class RTLLanguageDetectionTests: XCTestCase {
    private let ltrStrings = [
        "",
        " ",
        "123",
        "English",
        "false",
        "Kleinigkeiten verbessern",
        "細部を修正",
        "Fixing details",
        "Arreglando detalles",
        "Correzione dettagli",
        "세부사항 수정 중",
        "修復細節",
        "Ayrıntılar düzeltiliyor",
        "Dopracowuję szczegóły",
        "Tinh chỉnh chi tiết",
        "Проверяем",
        "Correction des détails",
        "বিস্তারিত ঠিক করা হচ্ছে",
        "विवरण ठीक किया जा रहा है",
        "修复细节",
        "Memperbaiki detail",
    ]

    private let rtlPersianStrings = [
        "رفع جزئیات", // tagged as Urdu
        "کاهش تاری", // fa
        "در حال افزودن پیکسل", // fa
        "تقریباً رو به اتمام است", // fa
    ]

    private let rtlArabicStrings = [
        "إصلاح التفاصيل", // ar
        "تقليل الضباب", // ar
        "إضافة بيكسلات", // ar
        "بالكاد وصلت", // ar
    ]

    private let rtlStrings = [
        "גוט וואָך", // he
        "اَلْعَرَبِيَّةُ", // ar
        "چ", // persian unique letter as ar
        "پ", // persian unique letter as ur
        "گ", // persian unique letter as ar
        "این روزها اخبار بسیاری در مورد ارزهای دیجیتال در اینترنت منتشر می شوند که چکیده خبرها در مورد افزایش قیمت آنهاست. امروز در این پست قصد داریم آموزش استخراج بیت کوین به صورت رایگان با کامپیوتر خانگی را قرار دهیم. یکی از محبوب ترین و مطرح ترین ارزهای دیجیتال، بیت کوین است که استخراج آن ملزم به داشتن سیستم های قدرتمند به تعداد بالاست! به تازگی روش جدیدی در حال همه گیر شدن است که به کمک آن می توان با صرف وقت و تشکیل دادن گروه به استخراج و دریافت رایگان بیت کوین پرداخت",
        // persian poem as ur

        """
        به آرامی آغاز به مردن می‌كنی
        اگر سفر نكنی،
        اگر كتابی نخوانی،
        اگر به اصوات زندگی گوش ندهی،
        اگر از خودت قدردانی نكنی.
        به آرامی آغاز به مردن می‌كنی

        زمانی كه خودباوری را در خودت بكشی،
        وقتی نگذاری دیگران به تو كمك كنند.
        به آرامی آغاز به مردن می‌كنی

        اگر برده‏ عادات خود شوی،
        اگر همیشه از یك راه تكراری بروی،
        اگر روزمرّگی را تغییر ندهی،
        اگر رنگ‏های متفاوت به تن نكنی،
        یا اگر با افراد ناشناس صحبت نكنی.
        تو به آرامی آغاز به مردن می‏كنی

        اگر از شور و حرارت،
        از احساسات سركش،
        و از چیزهایی كه چشمانت را به درخشش وامی‌دارند،
        و ضربان قلبت را تندتر می‌كنند،
        دوری كنی.
        تو به آرامی آغاز به مردن می‌كنی

        اگر هنگامی كه با شغلت‌ یا عشقت شاد نیستی، آن را عوض نكنی،
        اگر برای مطمئن در نامطمئن خطر نكنی،
        اگر ورای رویاها نروی،
        اگر به خودت اجازه ندهی،
        كه حداقل یك بار در تمام زندگیت
        ورای مصلحت‌اندیشی بروی.
        تو به آرامی آغاز به مردن می‌كنی

        امروز زندگی را آغاز كن!
        امروز مخاطره كن!
        امروز كاری كن!
        نگذار كه به آرامی بمیری!
        شادی را فراموش نكن!
        """, // persian poem as ur

        "کوردی", // kurdish as ur
        "رفع جزئیات", // persian as ur
        "اُردُو‌ حُرُوفِ ‌تَہَجِّی", // ur
        "خوش گلیپسیز", // azer as fa
    ]

    func testLTR() {
        for source in ltrStrings {
            XCTAssertTrue(!source.isRTL)
        }
    }

    func testPersian() {
        for source in rtlPersianStrings {
            XCTAssertTrue(source.isRTL)
        }
    }

    func testArabic() {
        for source in rtlArabicStrings {
            XCTAssertTrue(source.isRTL)
        }
    }

    func testAllRtlList() {
        for source in rtlStrings {
            XCTAssertTrue(source.isRTL)
        }
    }

    // MARK: - Speed comparison

    private var allStrings: [String] {
        let part = ltrStrings + rtlArabicStrings + rtlPersianStrings + rtlStrings
        var gathered = part
        for _ in 0..<4 { // Increase it to compare on bigger array size
            gathered.append(contentsOf: gathered)
        }
        return gathered
    }

    func testNLSpeed() {
        measure {
            for source in allStrings {
                _ = source.isRTLbyNL
            }
        }
    }

    func testCFSTSpeed() {
        measure {
            for source in allStrings {
                _ = source.isRTL
            }
        }
    }

    func testNSLTSpeed() {
        measure {
            for source in allStrings {
                _ = source.isRTLbyNSLT
            }
        }
    }
}

