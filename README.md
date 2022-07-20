# RTLLanguageDetection
`CFStringTokenizerCopyBestStringLanguage` showed the best performance for language determination

## CFStringTokenizer

`CFStringTokenizer` was released with `iOS 3.0` and still is the best option to detect right-to-left language fast.

### Apple's documnentation issue

That's what written in **Discussion** section in [documentation](https://developer.apple.com/documentation/corefoundation/1542136-cfstringtokenizercopybeststringl):

```
The result is not guaranteed to be accurate. Typically, the function requires 200-400 characters to reliably guess the language of a string.
CFStringTokenizer recognizes the following languages:
ar (Arabic), bg (Bulgarian), cs (Czech), da (Danish), de (German), el (Greek), en (English), es (Spanish), fi (Finnish), fr (French), he (Hebrew), hr (Croatian), hu (Hungarian), is (Icelandic), it (Italian), ja (Japanese), ko (Korean), nb (Norwegian Bokmål), nl (Dutch), pl (Polish), pt (Portuguese), ro (Romanian), ru (Russian), sk (Slovak), sv (Swedish), th (Thai), tr (Turkish), uk (Ukrainian), zh-Hans (Simplified Chinese), zh-Hant (Traditional Chinese).
```

## NSLinguisticTagger

`NSLinguisticTagger` was implemented with `iOS 5.0` and deprecated in `iOS 14.0`. It returned the same language for all strings in tests.
Works much longer.

## NLLanguageRecognizer

`NLLanguageRecognizer` was released in iOS `12.0`. It is a recommended way to determine language as Apple says, but it is slower even than `NSLinguisticTagger`.

And, *surprise-surprise*, 🙃 I've found no case when it determines **Persian** correctly. It returns **Arabic** or **Urdu**. Both solutions mentioned above worked better for **Persian**.

# Tip 1
**Maldivian** language is not determined by all three ways.

# Tip 2
Interface allows to return `nil` language when it was not determined.
All three ways can return undocumented `und` language - that also means that language was not detected. Two ways to say the same. Oh, Apple.
