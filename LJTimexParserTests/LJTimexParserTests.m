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

- (void)passingTests;
{
    LJDynamicParser* parser = [[LJDynamicParser alloc] initWithGrammar:_timexGrammar];
    LJDynamicParserASTNode* rootNode;

    rootNode = [parser parse:@"Next Tuesday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Next Tuesday", @"");
    
    rootNode = [parser parse:@"Tomorrow" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Tomorrow", @"");
    
    rootNode = [parser parse:@"Next week Tuesday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Next week Tuesday", @"");
    
    rootNode = [parser parse:@"On Tuesdays" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"On Tuesday s", @"");
    
    rootNode = [parser parse:@"Every Tuesday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Every Tuesday", @"");
    
    rootNode = [parser parse:@"Every week Monday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Every week Monday", @"");
    
    rootNode = [parser parse:@"Every week on Mondays" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Every week on Monday s", @"");
    
    rootNode = [parser parse:@"Every week on Monday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Every week on Monday", @"");
    
    rootNode = [parser parse:@"On Monday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"On Monday", @"");
    
    rootNode = [parser parse:@"Every other day" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Every other day", @"");
    
    rootNode = [parser parse:@"Every other Tuesday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Every other Tuesday", @"");
    
    rootNode = [parser parse:@"Every other week Monday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Every other week Monday", @"");

    rootNode = [parser parse:@"From Tomorrow to Sunday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"From Tomorrow to Sunday", @"");
    
    rootNode = [parser parse:@"Tomorrow to Sunday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Tomorrow to Sunday", @"");
    
    rootNode = [parser parse:@"Monday until Tuesday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Monday until Tuesday", @"");
    
    rootNode = [parser parse:@"From tomorrow until Tuesday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"From tomorrow until Tuesday", @"");
    
    rootNode = [parser parse:@"Monday - Friday" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Monday - Friday", @"");
}

- (void)failingTests;
{
    LJDynamicParser* parser = [[LJDynamicParser alloc] initWithGrammar:_timexGrammar];
    LJDynamicParserASTNode* rootNode;
    
    rootNode = [parser parse:@"On Jan 1" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"On Jan 1", @"");
    
    rootNode = [parser parse:@"On Tuesday, Jan 1" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"On Tuesday, Jan 1", @"");
    
    rootNode = [parser parse:@"1 / 1 / 14" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"1 / 1 / 14", @"");
    
    rootNode = [parser parse:@"All next week" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"All next week", @"");
    
    rootNode = [parser parse:@"All week" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"All week", @"");
        
    rootNode = [parser parse:@"First tuesday of the month" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"First tuesday of the month", @"");
    
    rootNode = [parser parse:@"Weekdays" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Weekdays", @"");
    
    rootNode = [parser parse:@"Weeknights" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Weeknights", @"");
    
    rootNode = [parser parse:@"Lunch" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Lunch", @"");
    
    rootNode = [parser parse:@"Lunchtime" ignoreCase:YES];
    XCTAssertEqualObjects([[rootNode nodeForRule:@"timex"] literalValue], @"Lunchtime", @"");
}

@end
