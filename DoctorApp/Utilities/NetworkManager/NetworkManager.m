
#import "NetworkManager.h"
#import "TAAESCrypt.h"


@implementation NetworkManager

static NetworkManager *manager;

#pragma mark - Alloc Singleton Class Object
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s",BASE_URL]]];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
        [manager.reachabilityManager startMonitoring];
    });
    
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
 //   [manager.requestSerializer setValue:@"654316f09c36b76a8840220ae818c577c5" forHTTPHeaderField:@"api-key"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"iOS %@",[KRDiscoveryandDetails getOSVersion]] forHTTPHeaderField:@"X-os"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[KRDiscoveryandDetails getDeviceName]] forHTTPHeaderField:@"X-device"];
//    NSLog(@"Ver:%@",[KRDiscoveryandDetails getAppVersion]);
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[KRDiscoveryandDetails getAppVersion]] forHTTPHeaderField:@"X-app-version"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[KRDiscoveryandDetails getAuth]] forHTTPHeaderField:@"X-auth-token"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[KRDiscoveryandDetails getUserId]] forHTTPHeaderField:@"X-userid"];

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    /*
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    manager.securityPolicy = policy;
     */
    
    return manager;
}
- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

+ (id)alloc
{
    @synchronized(self)
    {
        NSAssert(manager == nil, @"Attempted to allocate a second instance of a singleton NetworkManager.");
        manager = [super alloc];
    }
    
    return manager;
}



#pragma mark - PUBLIC METHODS


- (void)requestApiWithName:(NSString *)serviceName
               requestType:(kHTTPMethod)method
                  postData:(id)postData
             callBackBlock:(void (^)(id response,NSError *error))responeBlock
{
    postData = postData?postData:@{};
    if (![self isInternetAvailable])
    {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"internet error" code:-1 userInfo:dictionary];
        responeBlock(nil,error);
        return;
    }
    
    NSLog(@"Request API: %@",postData);
    
    NSError *error;
    NSString *jsonString = @"";
    
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    //NSAssert Statements
    NSAssert(method != kHTTPMethodGET || method != kHTTPMethodPOST || method != kHTTPMethodPUT,
             @"kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.");
    NSAssert(nil != serviceName, @"URLString cannot be nil.");
    
    
    // Add AES authentication ...........
    [manager.requestSerializer setValue:[self encryptRequestString:serviceName] forHTTPHeaderField:kAuthentication];
    NSString *serviceUrl = [NSString stringWithFormat:@"%@",serviceName];
    switch (method) {
        case kHTTPMethodGET:
        {
            
            [manager GET:serviceUrl parameters:postData progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                responeBlock (responseObject, nil);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                responeBlock (nil, error);

            }];
        }
            break;
        case kHTTPMethodPOST:
        {
            
            [manager POST:serviceUrl parameters:postData progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                responeBlock (responseObject, nil);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                responeBlock (nil, error);
                
            }];
        }
            break;
        case kHTTPMethodPUT:
        {
            [manager PUT:serviceUrl parameters:postData success:^(NSURLSessionTask *task, id responseObject) {
                responeBlock (responseObject, nil);

            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"localizedDescription:%@",error.localizedDescription);
                responeBlock (nil, error);
            }];
        }
            break;
            
        case kHTTPMethodDELETE:
        {
            [manager DELETE:serviceUrl
                 parameters:postData
                    success:^(NSURLSessionDataTask *task, id responseObject) {
                        responeBlock (responseObject, nil);
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        responeBlock (nil, error);
                }];
            
        }
            break;
        case kHTTPMethodHEAD:
        {
            [manager HEAD:serviceUrl
               parameters:postData
                  success:^(NSURLSessionDataTask * task) {
                      NSDictionary *dic = @{@"Success" : @"1",
                                            @"Result" : @[],
                                            @"Message" : @"Deleted successfully",
                                            };
                      responeBlock (dic, nil);
                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                      responeBlock (nil, error);
                  }];
            
        }
            break;
            
        case kHTTPMethodPATCH:
        {
            [manager PATCH:serviceUrl
                parameters:postData
                   success:^(NSURLSessionDataTask *task, id responseObject) {
                       responeBlock (responseObject, nil);
                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                       responeBlock (nil, error);
                   }];
            
        }
            break;
        default:
            break;
    }
}

-(void)requestApiWithMultiPart:(NSString *)serviceName
                      postData:(NSDictionary*)postData
                    imageArray:(NSMutableArray*)imagesArray
                 callBackBlock:(void (^)(id response,NSError *error))responeBlock {
    
    if (![self isInternetAvailable])
    {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"internet error" code:-1 userInfo:dictionary];
        responeBlock(nil,error);
        return;
    }
    
    NSLog(@"Request API: %@",serviceName);
    NSLog(@"Request Body: %@", postData);
    
    [manager.requestSerializer setValue:[self encryptRequestString:serviceName] forHTTPHeaderField:kAuthentication];
    NSString *serviceUrl = [NSString stringWithFormat:@"%@",serviceName];
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:serviceUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i=0;i<[imagesArray count];i++)
        {
            NSString *imageName=[NSString stringWithFormat:@"image%d",i+1];
            NSString *fileName=[NSString stringWithFormat:@"image%d.jpeg",i+1];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(([imagesArray objectAtIndex:i]), .8) name:imageName fileName:fileName mimeType:@"image/jpeg"];
        }
        [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:nil] name:@"json"];
    } error:nil];
    
    
    NSURLSessionUploadTask *uploadTask = [self
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //[progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          responeBlock (nil, error);

                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          responeBlock (responseObject, nil);
                      }
                  }];
    [uploadTask resume];
}
-(void)requestApiWithMultiPart:(NSString *)serviceName
                      postData:(NSDictionary*)postData
                    imageArray:(NSMutableArray*)imagesArray
                    videoArray:(NSMutableArray*)videosArray
                 callBackBlock:(void (^)(id response,NSError *error))responeBlock {
    
    if (![self isInternetAvailable])
    {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"internet error" code:-1 userInfo:dictionary];
        responeBlock(nil,error);
        return;
    }
        
    [manager.requestSerializer setValue:[self encryptRequestString:serviceName] forHTTPHeaderField:kAuthentication];
    NSString *serviceUrl = [NSString stringWithFormat:@"%@",serviceName];
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:serviceUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for(int i=0;i<[imagesArray count];i++)
        {
            NSString *imageName=[NSString stringWithFormat:@"image%d",i+1];
            NSString *fileName=[NSString stringWithFormat:@"image%d.jpeg",i+1];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(([imagesArray objectAtIndex:i]), .8) name:imageName fileName:fileName mimeType:@"image/jpeg"];
        }
        
        for(int i=0;i<[videosArray count];i++)
        {
            NSString *fileName=[NSString stringWithFormat:@"video%d",i+1];
            NSString *videoName=[NSString stringWithFormat:@"video%d",i+1];
            [formData appendPartWithFileData:[videosArray objectAtIndex:i] name:videoName fileName:fileName mimeType:@"video/mp4"];
        }
        
        [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:nil] name:@"json"];
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self
                                          uploadTaskWithStreamedRequest:request
                                          progress:^(NSProgress * _Nonnull uploadProgress) {
                                              
                                              // This is not called back on the main queue.
                                              // You are responsible for dispatching to the main queue for UI updates
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  //Update the progress view
                                                  //[progressView setProgress:uploadProgress.fractionCompleted];
                                              });
                                          }
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              if (error) {
                                                  NSLog(@"Error: %@", error);
                                                  responeBlock (nil, error);
                                                  
                                              } else {
                                                  NSLog(@"%@ %@", response, responseObject);
                                                  responeBlock (responseObject, nil);
                                              }
                                          }];
    [uploadTask resume];
}

- (void)cancelAllRequests {
    
    //Cancel all requests i.e. all task in tasks
    for (NSURLSessionTask *task in self.tasks) {
        [task cancel];
    }
}

- (void)cancelRequestWithURLString:(NSString *)URLString {
    
    NSAssert(nil != URLString, @"URLString cannot be nil.");

    //Cancel all requests i.e. all task in tasks
    NSURL *serviceUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@",URLString]];
    for (NSURLSessionTask *task in self.tasks) {
        
        if ([task.originalRequest.URL isEqual:serviceUrl]) {
            [task cancel];
            break;
        }
    }
}

- (NSUInteger)numberOfRequestsInManager {
    
    return [self.tasks count];
}

#pragma mark ---- Encrypt Request
-(NSString *)encryptRequestString:(NSString *)requestStr
{
    NSString *plainTextStr=[requestStr stringByAppendingString:[NSString stringWithFormat:@"_%f",[self getCurrentTimeStamp]]];
    NSString *encyptedStrng=[TAAESCrypt encrypt:plainTextStr password:kEncryptionKey];
    return encyptedStrng;
}
#pragma mark getCurrentTimeStamp
-(NSTimeInterval )getCurrentTimeStamp
{
    NSTimeInterval timeInterval=[[NSDate date] timeIntervalSince1970];
    return timeInterval;
}

- (BOOL)isConnectedToWiFi {
    
    static int wifiCheckCount = 1;
    BOOL success = NO;
    if(self.reachabilityManager.isReachableViaWiFi){
        success = YES;
    }
    else if(wifiCheckCount > 3){
        success = NO;
    }
    else{
        ++wifiCheckCount;
        [self isConnectedToWiFi];
    }
    return success;
}

-(BOOL)isInternetAvailable
{
    BOOL isInternetAvailable = false;
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
            isInternetAvailable = FALSE;
            break;
        case ReachableViaWWAN:
            isInternetAvailable = TRUE;
            break;
        case ReachableViaWiFi:
            isInternetAvailable = TRUE;
            break;
    }
    [internetReach stopNotifier];
    return isInternetAvailable;
}

@end
