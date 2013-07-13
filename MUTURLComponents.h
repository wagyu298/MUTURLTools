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

#import <Foundation/Foundation.h>

@interface MUTURLComponents : NSObject

@property (strong, nonatomic) NSString *scheme;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *fragment;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSString *port;
@property (strong, nonatomic) NSString *path;

// username@password
- (NSString *)userinfo;

// userinfo@host:port
- (NSString *)authority;

// authority+path
- (NSString *)hierPart;

// scheme:hierPart?query#fragment
- (NSString *)urlString;

// [NSURL URLWithString:urlString]
- (NSURL *)url;

- (id)initWithString:(NSString *)aString;
+ (id)URLComponentsWithString:(NSString *)aString;
- (void)parse:(NSString *)aString;

- (void)encode;
- (void)decode;

@end
