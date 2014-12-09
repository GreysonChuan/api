---
title: Home
---

# mPOS api 1.0.5 Reference 

The mPOS api allows app developers to launch the POGO mPOS app from within their own apps and do payment / void transactions with it.

**Guide:**

--------------------

1. Set up return URL for ffastpay to return to your app on completion of a transaction at ffastpay:	

	1. Go to Project Target > Info 
	2. Add URL Types 
	   Identifier: <YourAppBundleID> e.g. com.ffastpay.mpos.URLSchemeDemo 
	   URL Scheme: <YourAppURLScheme> e.g. DemoMSMPos (This will be passed as part of the return URL in the request parameters) 

	--------------------
	   
2. Implement the handleOpenURL method in your AppDelegate. 

	1. When this method is called in your app, the ffastpay url scheme is passed to ffastpay app delegate.
	2. Post a notification for the receipt of response data from ffastpay.

	<pre><code>
	- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
	{
		NSString *query = [url query];
			NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:query, @"msg"
								   , nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVED_RESULT" object:self userInfo:resultDic];
		
		return YES;
	}
	</code></pre><br/>
	  
	--------------------

3. Call your application's openURL method with ffastpay's URL and parameters to launch a ffastpay transaction:

	<pre><code>
	- (IBAction)sendData:(id)sender {
		[self closeKeyboard:sender];

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self makeURL]]];
	}
	</code></pre>
		
	1. Sale Transaction Request Parameters
	
	   Request Parameters:

	   No | Name         | Mandatory(M) / Optional(O) | Type | Length | Description
	   -- | ----         | -------------------------- | ---- | ------ | -----------
	   1  | return_url   | M                          | AN   |        | Your app URL Scheme
	   2  | pwd          | M                          | AN   |        | Password for FDMS mPOS
	   3  | return_key   | M                          | AN   |        | Unique key for order identification
	   4  | type         | M                          | A    | 1      | S: Sale
	   5  | amount       | M                          | N    | 10     | For sale / except GST & Service
	   6  | tip_amount   | O                          | N    | 10     | Tip amount
	   7  | reference_no | O                          | AN   |        | Reference number in mPOS app
	   8  | any others   | O                          |      |        | Any other key & value pair to return


	   URL: msmpos://?  
	   params: return_url=&pwd=&return_key=&type=S&amount=&tip_amount=&reference_no=&  

	   Note that the return_url needs to be URL-encoded

	   Example:  
	   Request URL : msmpos://?return_url=DemoMSMPos%3A%2F%2Fmcpayment%3F&return_key=INV14110021&reference_no=INV14110021&type=S&amount=0.20&pwd=1234 

	2. Void Transaction Request Parameters  
	   URL: msmpos://?  
	   params: return_url=&pwd=&return_key=&type=V&receipt_no=&  


	   Request Parameters:

	   No | Name         | Mandatory(M) / Optional(O) | Type | Length | Description
	   -- | ----         | -------------------------- | ---- | ------ | -----------
	   1  | return_url	 | M                          | AN   |        | Your app URL Scheme
	   2  | pwd          | M                          | AN   |        | Password for FDMS mPOS
	   3  | return_key   | M                          | AN   |        | Unique key for order identification
	   4  | type         | M                          | A    | 1      | V: Void
	   5  | receipt_no   | M                          | N    | 14     | Receipt number of transaction to void
	   6  | any others   | O                          |      |        | Any other key & value pair to return

	   Note that the return_url needs to be URL-encoded

	   Example:  
	   Request URL : msmpos://?return_url=DemoMSMPos%3A%2F%2Fmcpayment%3F&return_key=INV14110021&receipt_no=20141204000001&type=V&pwd=1234 
	   
	--------------------

4. Add a notification observer to receive the response results from ffastpay 

	<pre><code>
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setResult:) name:@"RECEIVED_RESULT" object:nil];
	</code></pre>

	1. Sale Transaction Response Data 

	   Returned as NSDictionary:

	   No | Name           | Mandatory(M) / Optional(O) | Type | Length | Description / Value
	   -- | ----           | -------------------------- | ---- | ------ | -------------------
	   1  | return_key	   | M                          | AN   |        | Unique key for order identification
	   2  | result_code    | M                          | A    | 4      | 0000: Succeed <br/> Others: Failed	
	   3  | result_message | M                          | A    |        | SUCCEED / Failed Message
	   4  | type           | M                          | A    | 1      | S: Sale
	   5  | receipt_no     | M                          | AN   | 14     |
	   6  | sales_amount   | M                          | N    |        |
	   7  | tip_amount     | M                          | N    | 10     |
	   8  | gst_amount     | M                          | N    | 10     |
	   9  | service_amount | M                          | N    | 10     |
	   10 | total_amount   | M                          | N    | 10     | sales_amount + tip_amount + gst_amount + service_amount
	   11 | any others     | O                          |      |        | Any other key & value pairs

	2. Void Transaction Response Data

	   Returned as NSDictionary:

	   No | Name           | Mandatory(M) / Optional(O) | Type | Length | Description / Value
	   -- | ----           | -------------------------- | ---- | ------ | -------------------
	   1  | return_key	   | M                          | AN   |        | Unique key for order identification
	   2  | result_code    | M                          | A    | 4      | 0000: Succeed <br/> Others: Failed	
	   3  | result_message | M                          | A    |        | SUCCEED / Failed Message
	   4  | type           | M                          | A    | 1      | V: Void
	   5  | receipt_no     | M                          | AN   | 14     | For void
	   6  | any others     | O                          |      |        | Any other key & value pairs






 



  