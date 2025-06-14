%hook SCUser

- (BOOL)isSubscriptionGranted {
    NSLog(@"[Bypass v1.1] Checking subscription");
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"forcePremium"] ?: YES;
}

- (void)setIsSubscriptionGranted:(BOOL)value {
    NSLog(@"[Bypass v1.1] Attempt to set subscription: %d", value);
    %orig(YES); // Always override to true
}

%end

%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {

    if ([request.URL.absoluteString containsString:@"verifySubscription"]) {
        NSLog(@"[Bypass v1.1] Intercepted subscription check");
        NSData *fakeData = [@"{\"active\":true}" dataUsingEncoding:NSUTF8StringEncoding];
        NSURLResponse *resp = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:@"application/json" expectedContentLength:fakeData.length textEncodingName:nil];
        completionHandler(fakeData, resp, nil);
        return nil;
    }

    return %orig;
}

%end