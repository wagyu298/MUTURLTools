MUTURLTools for Objective-C

[WebHub](https://itunes.apple.com/jp/app/id597069002?mt=8)で使用しているURL文字列を処理するためのモジュールです。

## NSString (MUTCaseCompareAdditions)

Case Insensitiveで文字列比較するカテゴリです。

    - (BOOL)caseInsensitiveHasPrefix:(NSString *)aString;

hasPrefix:のCaseInsensitive版です。

    - (BOOL)caseInsensitiveHasSuffix:(NSString *)aString;

hasSuffix:のCaseInsensitive版です。

    - (BOOL)caseInsensitiveIsEqualToString:(NSString *)aString;

isEqualToString:のCaseInsensitive版です。

## NSString (MUTURLEncodeAdditions)

URLエンコードに関するカテゴリです。

    - (NSString *)encodeURIComponentUsingEncoding:(NSStringEncoding)encoding;
    - (NSString *)encodeURIComponent;

JavaScriptのencodeURIComponent互換メソッドです。

    - (NSString *)decodeURIComponentUsingEncoding:(NSStringEncoding)encoding;
    - (NSString *)decodeURIComponent;

JavaScriptのdecodeURIComponent互換メソッドです。

    - (NSString *)encodeURLSafeUsingEncoding:(NSStringEncoding)encoding;
    - (NSString *)encodeURLSafe;

文字列を安全に（URLとしての意味を変えずに）URLエンコードします。
（マルチバイト文字と " ", "<", ">" をURLエンコードします。）

    - (NSString *)decodeURLSafeUsingEncoding:(NSStringEncoding)encoding;
    - (NSString *)decodeURLSafe;

文字列を安全にURLデコードします。
（URLエンコードされていない%文字を%25にエンコードしてからデコードします。）

    - (NSString *)encodeURLForHumanInput;
    - (NSString *)decodeURLForHumanReadable;

人間が入力した（あまり厳密でない）URLをエンコード／デコードします。

## NSString (MUTPunycodeAdditions)

    - (NSString *)punycodeEncode;
    - (NSString *)punycodeDecode;

RFC 3492に従ってPunycodeをエンコード／デコードします。
Punycodeエンコードされたホスト名のエンコード／デコードにはNSString (MUTIDNAAdditions)を使用してください。


## NSString (MUTIDNAAdditions)

    - (NSString *)idnaToAscii;
    - (NSString *)idnaToUnicode;

RFC 3490に従ってホスト名をエンコード／デコードします。

## NSString (MUTURLQueryAdditions)

URL Queryパラメータ（aaa=bbb&ccc=ddd）をパースするカテゴリです。

    - (NSDictionary *)dictionaryByParsingURLQueryWithEncoding:(NSStringEncoding)encoding;
    - (NSDictionary *)dictionaryByParsingURLQuery;

URL QueryパラメータをNSDictionaryに変換します。

    - (NSArray *)arrayByParsingURLQueryWithEncoding:(NSStringEncoding)encoding;
    - (NSArray *)arrayByParsingURLQuery;

URL QueryパラメータをNSArrayに変換します。
配列の要素は@{@"key":key,@"value":value}形式のNSDictionaryです。
重複するキーを含むパラメータをパースする場合に使用できます。

## NSArray (MUTURLQueryAdditions)

    - (NSString *)stringByComposingURLQueryUsingEncoding:(NSStringEncoding)encoding;
    - (NSString *)stringByComposingURLQuery;

@{@"key":key,@"value":value}形式のNSDictionaryを要素とする配列をURL Queryパラメータ文字列に変換します。

## NSDictionary (MUTURLQueryAdditions)

    - (NSString *)stringByComposingURLQueryUsingEncoding:(NSStringEncoding)encoding;
    - (NSString *)stringByComposingURLQuery;

URL Queryパラメータ文字列に変換します。 

## MUTURLComponents

RFC 3986に従いURL文字列を以下の要素に分解します。

    @property (strong, nonatomic) NSString *scheme;
    @property (strong, nonatomic) NSString *query;
    @property (strong, nonatomic) NSString *fragment;

    @property (strong, nonatomic) NSString *username;
    @property (strong, nonatomic) NSString *password;

    @property (strong, nonatomic) NSString *host;
    @property (strong, nonatomic) NSString *port;
    @property (strong, nonatomic) NSString *path;

    - (NSString *)userinfo;

username@passwordを返します。

    - (NSString *)authority;

userinfo@host:portを返します。

    - (NSString *)hierPart;

authority+pathを返します。

    - (NSString *)urlString;

scheme:hierPart?query#fragmentを返します。

    - (NSURL *)url;

[NSURL URLWithString:[self urlString]]を返します。

    - (id)initWithString:(NSString *)aString;
    + (id)URLComponentsWithString:(NSString *)aString;

initとAutoリリース。

    - (void)parse:(NSString *)aString;

URL文字列をパースしてメンバ変数に結果をセットします。

    - (void)encode;
    - (void)decode;

メンバ変数をURLエンコード／デコードします。
