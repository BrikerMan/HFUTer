//
//  AddSSLPinningTests.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/6.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class AddSSLPinning: BaseTestCase {
    
    var certData: Data!
    
    override func setUp() {
        super.setUp()
        self.certData = try! Data(contentsOf: self.URLForResource("lvwenhancom", withExtension: "cer"))
    }
    
    func testSSLPiningPassed() {
        let expectation = self.expectation(description: "testSSLPiningPassed")
        
        Pita.build(HTTPMethod: .GET, url: "https://lvwenhan.com/")
            .addSSLPinning(LocalCertData: self.certData, SSLValidateErrorCallBack: { () -> Void in
                XCTFail("Under the Man-in-the-middle attack!")
            })
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert((string?.lengthOfBytes(using: String.Encoding.utf8))! > 0)
                
                expectation.fulfill()
        }
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
    func testSSLPiningNotPassed() {
        let expectation = self.expectation(description: "testSSLPiningNotPassed")
        var errorPinning = 0
        
        Pita.build(HTTPMethod: .GET, url: "https://autolayout.club/")
            .addSSLPinning(LocalCertData: self.certData, SSLValidateErrorCallBack: { () -> Void in
                print("Under the Man-in-the-middle attack!")
                errorPinning = 1
                expectation.fulfill()
            })
            .onNetworkError({ (error) -> Void in
                XCTAssertNotNil(error)
                XCTAssert(errorPinning == 1, "Under the Man-in-the-middle attack")
            })
            .responseString { (string, response) -> Void in
                XCTFail("shoud not run callback() after a Man-in-the-middle attack.")
        }
        
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
    func testSSLPiningNil() {
        let expectation = self.expectation(description: "testSSLPiningPassed")
        
        Pita.build(HTTPMethod: .GET, url: "https://lvwenhan.com/")
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert((string?.lengthOfBytes(using: String.Encoding.utf8))! > 0)
                
                expectation.fulfill()
        }
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
}
