# URLEnquiry

URLEnquiry is a standalone class to make it easy to obtain MIME type and HTTP headers from an NSURL or NSURLRequest, without downloading the entire URL.

Internally it uses an NSURLSession to query a user-supplied NSURL or NSURLRequest. Once the session receives the first response from the server, the user-supplied response handler is called and the session is cancelled and invalidated.

You do not need to keep a strong reference to an instance of URLEnquiry for the response handler to be called, as the NSURLSession maintains a strong reference to the URLEnquiry instance until the session is invalidated by the URLEnquiry.

##Examples

If you just want to get MIME type and header information:

	let url = NSURL.init(string: "https://google.com/")
	
	let _ = URLEnquiry(url: url!) {
		(mimeType: String?, httpHeaders: [NSObject : AnyObject]?) in
		
		NSLog("mimeType = \(mimeType), httpHeaders = \(httpHeaders)")
	}

If you also want the HTTP status code and error information:

	let url = NSURL.init(string: "https://google.com/")

	let _ = URLEnquiry(url: url!) {
				(mimeType: String?, httpHeaders: [NSObject : AnyObject]?, httpStatusCode: Int?, error: NSError?) in
		
		if (error != nil) {
			NSLog("mimeType = \(mimeType), httpHeaders = \(httpHeaders)")
			NSLog("httpStatusCode = \(httpStatusCode)")
		}	
	}
	
Or, if you want the raw NSURLResponse:

	let url = NSURL.init(string: "https://google.com/")
	let _ = URLEnquiry(url: url!) {
				(response: NSURLResponse?, error: NSError?) in
				
		NSLog("response = \(response), error = \(error)")
	}

There are also equivalent constructors accepting NSURLRequest objects instead of NSURLs. 

##Getting started
URLEnquiry is a standalone Swift file. 

Just add the [URLEnquiry.swift](URLEnquiry/URLEnquiry.swift) file to your Xcode project.