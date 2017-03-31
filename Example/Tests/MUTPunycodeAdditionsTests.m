// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <MUTURLTools/NSString+MUTPunycodeAdditions.h>


SpecBegin(MUTPunycodeAdditionsSpec)

describe(@"punycodeEncode method", ^{
    
    it(@"encode ASCII", ^{
        expect([@"example.com" punycodeEncode]).to.equal(@"example.com-");
    });
    
    it(@"encode Japanese", ^{
        expect([@"エグザンプル" punycodeEncode]).to.equal(@"ickqs6k2dyb");
    });
    
});

describe(@"punycodeDecode method", ^{
    
    it(@"encode ASCII", ^{
        expect([@"example.com-" punycodeDecode]).to.equal(@"example.com");
    });
    
    it(@"encode Japanese", ^{
        expect([@"ickqs6k2dyb" punycodeDecode]).to.equal(@"エグザンプル");
    });
    
});

SpecEnd
