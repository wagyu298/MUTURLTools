// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <MUTURLTools/NSString+MUTCaseCompareAdditions.h>

SpecBegin(MUTCaseCompareAdditionsSpec)

describe(@"caseInsensitiveHasPrefix method", ^{
    
    it(@"has same string", ^{
        expect([@"abcde" caseInsensitiveHasPrefix:@"abcde"]).to.beTruthy();
    });
    
    it(@"has case insensitive same string", ^{
        expect([@"abcde" caseInsensitiveHasPrefix:@"ABCDE"]).to.beTruthy();
    });
    
    it(@"has prefix", ^{
        expect([@"abcde" caseInsensitiveHasPrefix:@"a"]).to.beTruthy();
    });
    
    it(@"has case insensitive prefix", ^{
        expect([@"abcde" caseInsensitiveHasPrefix:@"A"]).to.beTruthy();
    });
    
    it(@"Does not has prefix", ^{
        expect([@"abcde" caseInsensitiveHasPrefix:@"z"]).to.beFalsy();
    });
    
    it(@"Does not has case insensitive prefix", ^{
        expect([@"abcde" caseInsensitiveHasPrefix:@"Z"]).to.beFalsy();
    });
    
});

describe(@"caseInsensitiveHasSuffix method", ^{
    
    it(@"has same string", ^{
        expect([@"abcde" caseInsensitiveHasSuffix:@"abcde"]).to.beTruthy();
    });
    
    it(@"has case insensitive same string", ^{
        expect([@"abcde" caseInsensitiveHasSuffix:@"ABCDE"]).to.beTruthy();
    });
    
    it(@"has suffix", ^{
        expect([@"abcde" caseInsensitiveHasSuffix:@"e"]).to.beTruthy();
    });
    
    it(@"has case insensitive suffix", ^{
        expect([@"abcde" caseInsensitiveHasSuffix:@"E"]).to.beTruthy();
    });
    
    it(@"Does not has suffix", ^{
        expect([@"abcde" caseInsensitiveHasSuffix:@"z"]).to.beFalsy();
    });
    
    it(@"Does not has case insensitive prefix", ^{
        expect([@"abcde" caseInsensitiveHasSuffix:@"Z"]).to.beFalsy();
    });
    
});

describe(@"caseInsensitiveIsEqualToString method", ^{
    
    it(@"has same string", ^{
        expect([@"abcde" caseInsensitiveIsEqualToString:@"abcde"]).to.beTruthy();
    });
    
    it(@"has case insensitive same string", ^{
        expect([@"abcde" caseInsensitiveIsEqualToString:@"ABCDE"]).to.beTruthy();
    });
    
    it(@"has prefix", ^{
        expect([@"abcde" caseInsensitiveIsEqualToString:@"a"]).to.beFalsy();
    });
    
    it(@"has case insensitive prefix", ^{
        expect([@"abcde" caseInsensitiveIsEqualToString:@"A"]).to.beFalsy();
    });
    
    it(@"has suffix", ^{
        expect([@"abcde" caseInsensitiveIsEqualToString:@"e"]).to.beFalsy();
    });
    
    it(@"has case insensitive suffix", ^{
        expect([@"abcde" caseInsensitiveIsEqualToString:@"E"]).to.beFalsy();
    });
    
    it(@"Does not has suffix", ^{
        expect([@"abcde" caseInsensitiveIsEqualToString:@"z"]).to.beFalsy();
    });
    
    it(@"Does not has case insensitive prefix", ^{
        expect([@"abcde" caseInsensitiveIsEqualToString:@"Z"]).to.beFalsy();
    });
    
});

SpecEnd
