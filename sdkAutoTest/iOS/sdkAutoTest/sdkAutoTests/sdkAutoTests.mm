//
//  sdkAutoTests.m
//  sdkAutoTests
//
//  Created by 孙慕 on 2021/12/15.
//

#import <XCTest/XCTest.h>
#import "VersionStamp.h"

@interface sdkAutoTests : XCTestCase

@end

@implementation sdkAutoTests




- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

-(void)testVersion{
    int versionMajor = GetVersionMajor();
    int versionMinor = GetVersionMinor();
    int versionFix = GetVersionFix();
    
    XCTAssertTrue(versionFix >= 0,"版本号异常");
    XCTAssertTrue(versionMinor >= 0,"版本号异常");
    XCTAssertTrue(versionMajor >= 0,"版本号异常");
    
    NSLog(@"当前sdk 版本号 -- %s",GetVersion());
}

-(void)testAddFun{
    int a = 1;
    int b = 2;
    int res = 0;
    int error_code = add(a, b, &res);
    XCTAssertTrue(error_code == 1,"call error");
    XCTAssertTrue(res == 3,"res error");

    printf("----- testAddFun success ------\n");
}



//-(void)aaaaaccc{
//    int a = 1;
//    int c = 3;
//}
/* test error*/
//-(void)testAddFun2{
//    int a = 1;
//    int b = 2;
//    int res = 0;
//    int error_code = add(a, b, &res);
//    XCTAssertTrue(error_code == 1,"call error");
//    XCTAssertTrue(res == 4,"res error");
//}
@end
