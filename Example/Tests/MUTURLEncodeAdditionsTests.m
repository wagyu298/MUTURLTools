// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <MUTURLTools/NSString+MUTURLEncodeAdditions.h>

SpecBegin(MUTURLEncodeAdditionsSpec)

describe(@"encodeURIComponet", ^{
    
    it(@"!*'();:@&=+$,/?%#[]-._~ ", ^{
        expect([@"!*'();:@&=+$,/?%#[]-._~ " encodeURIComponent]).to.equal(@"!*'()%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D-._~%20");
    });
    
});

describe(@"encodeURIComponentUsingEncoding", ^{
    
    it(@"utf-8", ^{
        expect([@"あいうえお!*'();:@&=+$,/?%#[]-._~ " encodeURIComponentUsingEncoding:NSUTF8StringEncoding]).to.equal(@"%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A!*'()%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D-._~%20");
    });
    
    it(@"euc-jp", ^{
        expect([@"あいうえお!*'();:@&=+$,/?%#[]-._~ " encodeURIComponentUsingEncoding:NSJapaneseEUCStringEncoding]).to.equal(@"%A4%A2%A4%A4%A4%A6%A4%A8%A4%AA!*'()%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D-._~%20");
    });
    
});

describe(@"decodeURIComponet", ^{
    
    it(@"!*'();:@&=+$,/?%#[]-._~ ", ^{
        expect([@"!*'()%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D-._~%20" decodeURIComponent]).to.equal(@"!*'();:@&=+$,/?%#[]-._~ ");
    });
    
});

describe(@"decodeURIComponentUsingEncoding", ^{
    
    it(@"utf-8", ^{
        expect([@"%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A!*'()%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D-._~%20" decodeURIComponentUsingEncoding:NSUTF8StringEncoding]).to.equal(@"あいうえお!*'();:@&=+$,/?%#[]-._~ ");
    });
    
    it(@"euc-jp", ^{
        expect([@"%A4%A2%A4%A4%A4%A6%A4%A8%A4%AA!*'()%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D-._~%20" decodeURIComponentUsingEncoding:NSJapaneseEUCStringEncoding]).to.equal(@"あいうえお!*'();:@&=+$,/?%#[]-._~ ");
    });
    
});

SpecEnd
