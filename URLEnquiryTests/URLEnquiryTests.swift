//
//  URLEnquiryTests.swift
//  URLEnquiryTests
//
//  Created by User on 12/04/2016.
//
//

import XCTest
@testable import URLEnquiry

class URLEnquiryTests: XCTestCase {
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	private let validURL = NSURL.init(string: "https://github.com/github-user32/URLEnquiry")
	private let validURL_responseMIMEType = "text/html"
	
	private let nonExistentURL = NSURL.init(string: "https://github.com/github-user32/URLEnquiryNonExistent")
	private let nonExistentURL_responseMIMEType = "application/json"
	
	private let nonExistentHostURL = NSURL.init(string: "https://nonexistent12312493495.nonexistent/")
	
	private let invalidSchemeURL = NSURL.init(string: "hsfdttps://github.com/github-user32/URLEnquiry")
	
	private let defaultExpectationTimeout: NSTimeInterval = 10
	
	func testValidURLWithResponseCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
	
		if let url = validURL {
			
			let _ = URLEnquiry(url: url) {
				(response: NSURLResponse?, error: NSError?) in
				
				XCTAssert(response?.MIMEType == self.validURL_responseMIMEType, "Pass")
				
				if let httpResponse = response as? NSHTTPURLResponse {
					XCTAssert(httpResponse.allHeaderFields.count > 0, "Pass")
				} else {
					XCTFail("Expected non-nil HTTP headers")
				}
				
				
				expectation.fulfill()
			}
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
	
	func testValidURLWithHTTPStatusCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
		
		if let url = validURL {
			
			let _ = URLEnquiry(url: url) {
				(mimeType: String?, httpHeaders: [NSObject : AnyObject]?, httpStatusCode: Int?, error: NSError?) in
				
				XCTAssert(mimeType == self.validURL_responseMIMEType, "Pass")
				XCTAssert(httpHeaders?.count > 0, "Pass")
				XCTAssert(httpStatusCode == 200, "Pass")
				XCTAssertNil(error, "Pass")
				
				expectation.fulfill()
			}
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
	
	func testValidURLWithMinimalCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
		
		if let url = validURL {
			
			let _ = URLEnquiry(url: url) {
				(mimeType: String?, httpHeaders: [NSObject : AnyObject]?) in
				
				XCTAssert(mimeType == self.validURL_responseMIMEType, "Pass")
				XCTAssert(httpHeaders?.count > 0, "Pass")
				
				expectation.fulfill()
			}
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
	
	func testNonExistentURLWithHTTPStatusCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
		
		if let url = nonExistentURL {
			
			let _ = URLEnquiry(url: url, urlInfoHandler: { (mimeType: String?, httpHeaders: [NSObject : AnyObject]?, httpStatusCode: Int?, error: NSError?) in
				
				XCTAssert(mimeType == self.nonExistentURL_responseMIMEType, "Pass")
				XCTAssert(httpHeaders?.count > 0, "Pass")
				XCTAssert(httpStatusCode == 404, "Pass")
				XCTAssertNil(error, "Pass")
				
				expectation.fulfill()
			})
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
	
	func testNonExistentURLWithMinimalCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
	
		if let url = nonExistentURL {
			
			let _ = URLEnquiry(url: url, urlInfoHandler: { (mimeType: String?, httpHeaders: [NSObject : AnyObject]?) in
				
				XCTAssertNil(mimeType, "Pass")
				XCTAssertNil(httpHeaders, "Pass")
				
				expectation.fulfill()
			})
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
	
	func testInvalidSchemeURLWithHTTPStatusCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
		
		if let url = invalidSchemeURL {
			
			let _ = URLEnquiry(url: url, urlInfoHandler: { (mimeType: String?, httpHeaders: [NSObject : AnyObject]?, httpStatusCode: Int?, error: NSError?) in
				
				XCTAssertNil(mimeType, "Pass")
				XCTAssertNil(httpHeaders, "Pass")
				XCTAssertNil(httpStatusCode, "Pass")
				XCTAssertNotNil(error, "Pass")
				
				expectation.fulfill()
			})
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
	
	func testInvalidSchemeURLWithMinimalCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
	
		if let url = invalidSchemeURL {
			
			let _ = URLEnquiry(url: url, urlInfoHandler: { (mimeType: String?, httpHeaders: [NSObject : AnyObject]?) in
				
				XCTAssertNil(mimeType, "Pass")
				XCTAssertNil(httpHeaders, "Pass")
				
				expectation.fulfill()
			})
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
	
	
	func testNonExistentHostURLWithHTTPStatusCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
		
		if let url = nonExistentHostURL {
			
			let _ = URLEnquiry(url: url, urlInfoHandler: { (mimeType: String?, httpHeaders: [NSObject : AnyObject]?, httpStatusCode: Int?, error: NSError?) in
				
				XCTAssertNil(mimeType, "Pass")
				XCTAssertNil(httpHeaders, "Pass")
				XCTAssertNil(httpStatusCode, "Pass")
				XCTAssertNotNil(error, "Pass")
				
				expectation.fulfill()
			})
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
	
	func testNonExistentHostURLWithMinimalCompletionHandler() {
		let expectation = self.expectationWithDescription(#function)
		
		if let url = nonExistentHostURL {
			
			let _ = URLEnquiry(url: url, urlInfoHandler: { (mimeType: String?, httpHeaders: [NSObject : AnyObject]?) in
				
				XCTAssertNil(mimeType, "Pass")
				XCTAssertNil(httpHeaders, "Pass")
				
				expectation.fulfill()
			})
		}
		
		self.waitForExpectationsWithTimeout(defaultExpectationTimeout, handler: nil)
	}
}
