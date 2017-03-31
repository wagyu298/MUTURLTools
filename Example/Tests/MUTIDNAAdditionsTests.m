// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <MUTURLTools/NSString+MUTIDNAAdditions.h>

SpecBegin(MUTIDNAAdditionsSpec)

describe(@"idnaToAscii method", ^{
    
    it(@"encode ASCII", ^{
        expect([@"example.com" idnaToAscii]).to.equal(@"example.com");
    });
    
    it(@"encode Japanese", ^{
        expect([@"エグザンプル.com" idnaToAscii]).to.equal(@"xn--ickqs6k2dyb.com");
    });
    
});

describe(@"idnaToUnicode method", ^{
    
    it(@"encode ASCII", ^{
        expect([@"example.com" idnaToUnicode]).to.equal(@"example.com");
    });
    
    it(@"encode Japanese", ^{
        expect([@"xn--ickqs6k2dyb.com" idnaToUnicode]).to.equal(@"エグザンプル.com");
    });
    
});

SpecEnd
