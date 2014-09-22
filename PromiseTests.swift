//
//  BummerTests.swift
//  BummerTests
//
//  Created by Jason A Raede on 7/4/14.
//  Copyright (c) 2014 Bummerang. All rights reserved.
//

import XCTest

class PromiseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleResolve() {
        var deferred = Promise<Array<String>>.defer()
        


        deferred.then({(val:Array<String>) in
            XCTAssertTrue(val[0] == "foo")
            })
        deferred.resolve(["foo"])
    }
    


    func testSimpleFail() {
        var deferred = Promise<Boolean>.defer()
        
        deferred.fail({(val:NSError) in
            XCTAssertTrue(val.domain == "Test")
            XCTAssertTrue(val.code == 5)
            })
        deferred.reject(NSError.errorWithDomain("Test", code: 5, userInfo:nil))
    }

    func testMultipleResolve() {
        var deferred = Promise<String>.defer()
        
        deferred.then({(val:String) in
            XCTAssertTrue(val == "foo")
            })
        
        
        
        deferred.resolve("foo")
        
        deferred.then({(val:String) in
            XCTAssertTrue(val as String == "foo")
            })
    }

    func testMultipleFail() {
        var deferred = Promise<NSInteger>.defer()
        
        deferred.fail({(val:NSError) in
            XCTAssertTrue(val.domain == "foo")
            })
        
        
        
        deferred.reject(NSError.errorWithDomain("foo", code:5, userInfo:nil))
        
        deferred.fail({(val:NSError) in
            XCTAssertTrue(val.code == 5)
            })
    }
    
}

