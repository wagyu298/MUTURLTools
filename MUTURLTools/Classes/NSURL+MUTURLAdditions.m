/*
 The MIT License (MIT)
 
 Copyright (c) 2014 Masanori Mikawa.
 
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

#import "NSURL+MUTURLAdditions.h"

@implementation NSURL (MUTURLAdditions)

// Based upon http://stackoverflow.com/questions/12310258/reliable-way-to-compare-two-nsurl-or-one-nsurl-and-an-nsstring
- (BOOL)isEqualToURL:(NSURL *)aURL
{
    if ([self isEqual:aURL]) {
        return YES;
    }
    if ([self.scheme caseInsensitiveCompare:aURL.scheme] != NSOrderedSame) {
        return NO;
    }
    
    if ([self.user compare:aURL.user] != NSOrderedSame) {
        return NO;
    }
    if ([self.password compare:aURL.password] != NSOrderedSame) {
        return NO;
    }

    if ([self.scheme caseInsensitiveCompare:aURL.scheme] != NSOrderedSame) {
        return NO;
    }
    if ([self.host caseInsensitiveCompare:aURL.host] != NSOrderedSame) {
        return NO;
    }
    
    // NSURL path is smart about trimming trailing slashes
    // note case-sensitivty here
    if ([self.path compare:aURL.path] != NSOrderedSame) {
        return NO;
    }
    
    // at this point, we've established that the urls are equivalent according to the rfc
    // insofar as scheme, host, and paths match
    
    // according to rfc2616, port's can weakly match if one is missing and the
    // other is default for the scheme, but for now, let's insist on an explicit match
    if ([self.port compare:aURL.port] != NSOrderedSame) {
        return NO;
    }
    
    if ([self.query compare:aURL.query] != NSOrderedSame) {
        return NO;
    }
    
    if ([self.fragment compare:aURL.fragment] != NSOrderedSame) {
        return NO;
    }
    if ([self.parameterString compare:aURL.parameterString] != NSOrderedSame) {
        return NO;
    }
    
    return YES;
}

@end
