//
//  URLEnquiry.swift
//  URLEnquiry
//
//  Created by User on 12/04/2016.
//
//

import Foundation


/// Utility class to make it easy to obtain MIME type and HTTP headers from a URL
///
/// Creates an NSURLSession to query a specified URL. Once a response from the given URL is received, response handler is called and the session is invalidated.
///
/// You do not need to keep a strong reference to an instance of URLEnquiry for the response handler to be called, as
/// the NSURLSession maintains a strong reference to the URLEnquiry instance until the session is invalidated by the URLEnquiry.
class URLEnquiry: NSObject, NSURLSessionDelegate {
	
	private var dataTask: NSURLSessionDataTask? = nil
	private var session: NSURLSession? = nil
	private let completionBlock: (NSURLResponse?, NSError?) -> Void
	
	/// Provide the raw NSURLResponse and NSError results from connecting to the specified URL
	///
	/// If you're just after MIME type information, consider using one of the other convenience initializers.
	init(url: NSURL, urlResponseHandler:(NSURLResponse?, NSError?) -> Void) {
		
		completionBlock = urlResponseHandler
		
		super.init()
		
		dataTask = dataTaskWithRequest(url)
		dataTask!.resume()
	}
	
	/// Provide MIME type and HTTP header information about URL
	///
	/// Note: MIME type and header information may still be provided even in the even of an HTTP error such as 404!
	convenience init(url: NSURL, urlInfoHandler:(mimeType: String?, httpHeaders: [NSObject : AnyObject]?, httpStatusCode: Int?, error: NSError?) -> Void) {
		
		self.init(url: url) { (response: NSURLResponse?, error: NSError?) in
			
			var mimeType: String? = nil
			var headers: [NSObject : AnyObject]? = nil
			var httpStatusCode: Int? = nil
			
			if (error == nil) {
				mimeType = response?.MIMEType
				headers = (response as? NSHTTPURLResponse)?.allHeaderFields
				httpStatusCode = (response as? NSHTTPURLResponse)?.statusCode
			}
			
			urlInfoHandler(mimeType: mimeType, httpHeaders: headers, httpStatusCode: httpStatusCode, error: error)
		}
	}
	
	/// Provide MIME type and HTTP header information about URL only if there were no errors and the HTTP response status code was in the success range 2xx.
	convenience init(url: NSURL, urlInfoHandler:(mimeType: String?, httpHeaders: [NSObject : AnyObject]?) -> Void) {
		
		self.init(url: url) { (response: NSURLResponse?, error: NSError?) in
			
			var mimeType: String? = nil
			var headers: [NSObject : AnyObject]? = nil
			
			if (error == nil) {
				if let httpStatusCode = (response as? NSHTTPURLResponse)?.statusCode {
					
					// Based on https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
					if httpStatusCode >= 200 && httpStatusCode < 300 {
						
						mimeType = response?.MIMEType
						headers = (response as? NSHTTPURLResponse)?.allHeaderFields
					}
				}
			}
			
			urlInfoHandler(mimeType: mimeType, httpHeaders: headers)
		}
	}
	
	/// Filter out errors caused by us explicitly cancelling the URL session.
	private static func errorIsValid(error: NSError?) -> Bool {
		return (error != nil && error?.code != NSURLErrorCancelled)
	}
	
	private func sessionConfiguration() -> NSURLSessionConfiguration {
		return NSURLSessionConfiguration.ephemeralSessionConfiguration()
	}
	
	private func dataTaskWithRequest(url: NSURL) -> NSURLSessionDataTask
	{
		session = NSURLSession.init(configuration: sessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		return session!.dataTaskWithURL(url)
	}
	
	//MARK: NSURLSessionDelegate methods
	
	func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
		completionHandler(NSURLSessionResponseDisposition.Cancel)
	}
	
	func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
	{
		/// Filter out errors caused by us explicitly cancelling the URL session.
		let actualError = self.dynamicType.errorIsValid(error) ? error : nil
		
		completionBlock(task.response, actualError)
		
		session.invalidateAndCancel()
		
		self.session = nil
		dataTask = nil
	}
}

