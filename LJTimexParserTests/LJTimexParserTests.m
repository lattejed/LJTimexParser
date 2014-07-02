//
//  LJTimexParserTests.m
//  LJTimexParserTests
//
//  Created by Matthew Smith on 7/1/14.
//
//

#import <XCTest/XCTest.h>
#import "LJDynamicParser.h"
#import "LJDynamicParserSyntax.h"
#import "LJDynamicParserASTNode.h"

@interface LJTimexParserTests : XCTestCase

@property (strong) NSString* timexGrammar;
@property (strong) NSArray* testStrings;

@end

@implementation LJTimexParserTests

- (void)setUp
{
    [super setUp];
    NSString* filepath = [[NSBundle bundleForClass:[self class]] pathForResource:@"timex" ofType:@"grammar"];
    _timexGrammar = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    filepath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"strings"];
    NSString* testStringsString = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    _testStrings = [testStringsString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test
{
    LJDynamicParser* parser = [[LJDynamicParser alloc] initWithGrammar:_timexGrammar];
    
    LJDynamicParserASTNode* rootNode = [parser parse:@"Next Tuesday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Next Tuesday", @"");

    rootNode = [parser parse:@"Monday - Friday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Monday - Friday", @"");

    
    for (NSString* testString in _testStrings)
    {
        LJDynamicParserASTNode* rootNode = [parser parse:testString ignoreCase:YES];
        XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], testString, @"");
    }
}

@end
