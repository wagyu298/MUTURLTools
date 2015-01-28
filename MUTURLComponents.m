/*
The MIT License (MIT)

Copyright (c) 2013 Masanori Mikawa.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#import "MUTURLTools.h"

@implementation MUTURLComponents {
    BOOL _haveAuthority;
}

- (id)initWithString:(NSString *)aString
{
    self = [super init];
    if (self) {
        [self parse:aString];
    }
    return self;
}

+ (id)URLComponentsWithString:(NSString *)aString
{
    MUTURLComponents *u = [[MUTURLComponents alloc] initWithString:aString];
    if (u.scheme == nil)
        return nil;
    return u;
}

- (void)parse:(NSString *)aString
{
    int i, j, hier_begin, hier_end, colon;
    const unichar *s;
    NSMutableData *data;
    unichar ch;
    size_t len;

    _scheme = nil;
    _haveAuthority = NO;
    _query = nil;
    _fragment = nil;
    _username = nil;
    _password = nil;
    _host = nil;
    _path = nil;

    len = [aString length];
    s = CFStringGetCharactersPtr((__bridge CFStringRef)aString);
    if (s == NULL) {
        data = [NSMutableData dataWithLength:len * sizeof(unichar)];
        [aString getCharacters:[data mutableBytes]];
        s = [data bytes];
    }
    if (s == NULL)
        return;

    /*
     * RFC3986 syntax is
     * URI       = scheme ":" hier-part [ "?" query ] [ "#" fragment ]
     * hier-part = "//" authority path-abempty
     *             / path-absolute
     *             / path-rootless
     *             / path-empty
     */

    i = j = 0;
    for (; i < len; ++i) {
        ch = s[i];
        if (!((ch >= L'a' && ch <= L'z') || (ch >= L'A' && ch <= L'Z') ||
             (ch >= L'0' && ch <= L'9') || ch == L'+' || ch == L'-' ||
             ch == L'.'))
            break;
    }
    if (s[i++] != ':')
        return;

    _scheme = [aString substringWithRange:NSMakeRange(j, i - j - 1)];

    hier_begin = i;
    hier_end = -1;
    for (; i < len; ++i) {
        ch = s[i];
        if (ch == L'?') {
            hier_end = i;
            j = ++i;
            for (; i < len; ++i) {
                if (s[i] == L'#')
                    break;
            }
            _query = [aString substringWithRange:NSMakeRange(j, i - j)];
            break;

        } else if (ch == L'#') {
            break;
        }
    }

    if (s[i] == L'#') {
        if (hier_end == -1)
            hier_end = i;
        ++i;
        if (i < len) {
            _fragment = [aString substringWithRange:NSMakeRange(i, len - i)];
        }
    }

    if (hier_end == -1)
        hier_end = (int)len;
    if (!(hier_end - hier_begin >= 2 && s[hier_begin] == L'/' &&
          s[hier_begin+1] == L'/')) {
        _path = [aString substringWithRange:NSMakeRange(hier_begin, hier_end - hier_begin)];
        return;
    }
    _haveAuthority = YES;

    hier_begin += 2;
    i = j = hier_begin;
    colon = -1;
    for (;; ++i) {
        if (i >= hier_end) {
            i = j = hier_begin;
            break;
        }

        ch = s[i];
        if (ch == L'@') {
            if (colon != -1) {
                _username = [aString substringWithRange:NSMakeRange(j, colon - j)];
                _password = [aString substringWithRange:NSMakeRange(colon + 1, i - (colon + 1))];
            } else {
                _username = [aString substringWithRange:NSMakeRange(j, i - j)];
            }
            j = ++i;
            break;

        } else if (ch == L':') {
            if (colon == -1)
                colon = i;

        } else if (ch == L'/') {
            i = j = hier_begin;
            break;
        }
    }

    for (;; ++i) {
        if (i >= hier_end || s[i] == L'/') {
            for (int k = i - 1; k >= j; --k) {
                ch = s[k];
                if (ch == L':') {
                    _host = [aString substringWithRange:NSMakeRange(j, k++ - j)];
                    _port = [aString substringWithRange:NSMakeRange(k, i - k)];
                    break;

                } else if (!(ch >= L'0' && ch <= L'9')) {
                    break;
                }
            }

            if (_port == nil)
                _host = [aString substringWithRange:NSMakeRange(j, i - j)];
            _path = [aString substringWithRange:NSMakeRange(i, hier_end - i)];
            break;
        }
    }
}

- (NSString *)userinfo
{
    if (!_username && !_password) {
        return nil;
    }
    NSMutableString *s = [[NSMutableString alloc] init];
    if (_username)
        [s appendString:_username];
    if (_password)
        [s appendFormat:@":%@", _password];
    return s;
}

- (NSString *)authority
{
    NSString *userinfo = self.userinfo;
    if (!userinfo && !_host && !_port)
        return nil;

    NSMutableString *s = [[NSMutableString alloc] init];
    if (userinfo)
        [s appendFormat:@"%@@", userinfo];
    if (_host)
        [s appendString:_host];
    if (_port)
        [s appendFormat:@":%@", _port];
    return s;
}

- (NSString *)hierPart
{
    NSString *authority = self.authority;
    if (!authority && !_haveAuthority && !_path)
        return nil;

    NSMutableString *s = [[NSMutableString alloc] init];
    if (authority || _haveAuthority) {
        [s appendString:@"//"];
        if (authority)
            [s appendString:authority];
    }
    if (_path)
        [s appendString:_path];
    return s;
}

- (NSString *)urlString
{
    NSMutableString *s = [[NSMutableString alloc] init];
    if (_scheme) {
        [s appendString:_scheme];
        [s appendString:@":"];
    }

    NSString *hierPart = self.hierPart;
    if (hierPart)
        [s appendString:hierPart];

    if (_query)
        [s appendFormat:@"?%@", _query];
    if (_fragment)
        [s appendFormat:@"#%@", _fragment];
    return s;
}

- (NSURL *)url
{
    NSURL *url = [NSURL URLWithString:[self urlString]];
    return url;
}

- (NSString *)description
{
#if 0
    return [NSString stringWithFormat:@"scheme=%@, hierPart=%@, query=%@, fragment=%@, userinfo=%@, username=%@, password=%@, authority=%@, host=%@, port=%@, path=%@, urlString=%@, url=%@", _scheme, self.hierPart, _query, _fragment, self.userinfo, _username, _password, self.authority, _host, _port, _path, self.urlString, self.url];
#endif
    return [self urlString];
}

- (void)encode
{
    if (_host)
        _host = [_host idnaToAscii];
    if (_username)
        _username = [_username encodeURLSafe];
    if (_password)
        _password = [_password encodeURLSafe];
    if (_path)
        _path = [_path encodeURLSafe];
    if (_query)
        _query = [_query encodeURLSafe];
    if (_fragment)
        _fragment = [_fragment encodeURLSafe];
}

- (void)decode
{
    if (_host)
        _host = [_host idnaToUnicode];
    if (_username)
        _username = [_username decodeURLSafe];
    if (_password)
        _password = [_password decodeURLSafe];
    if (_path)
        _path = [_path decodeURLSafe];
    if (_query)
        _query = [_query decodeURLSafe];
    if (_fragment)
        _fragment = [_fragment decodeURLSafe];
}

@end
