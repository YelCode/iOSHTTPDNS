#  设计：
>  首先，本地保存一份初始的DNS Json文件
> 

## 使用

### 直接替换IP
```
NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location != NSNotFound) { 
    	 NSString *ip = [[CustomDNSManager sharedClient] requestIPWithHost:originHostString];
    }
```
### 以下只拦截请求，不修改请求
> 若要修改，修改RichURLSessionProtocol中的canonicalRequestForRequest方法

### 全局拦截
> 不包含单独的session和AFN

```
 -(BOOL)application:(UIApplication *)application 
 didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[NSURLProtocol registerClass:[RichURLSessionProtocol class]];
}
```

### UIWebView拦截
> 期间的接口请求也会被拦截
> 页面初始化时

```
- (void)viewDidLoad {
    [super viewDidLoad];
    [NSURLProtocol registerClass:[RichURLSessionProtocol class]];
}
```

> 页面销毁

```
- (void)dealloc {
    
    [NSURLProtocol unregisterClass:[RichURLSessionProtocol class]];
}
```

### AFN拦截或者NSURLSessionConfiguration
> 

```
	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSArray *protocolClasses = @[[RichURLSessionProtocol class]];
	config.protocolClasses = protocolClasses;
	AFHTTPSessionManager *manage = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
```

### WKWebview
- [Github:NSURLProtocol-WebKitSupport] (https://github.com/Yeatse/NSURLProtocol-WebKitSupport)

##  参考文献：
- [可能是最全的iOS端HttpDns集成方案] (https://www.jianshu.com/p/cd4c1bf1fd5f)
- [NSURLPtotocol无法拦截AFN ,WKWebView](https://www.jianshu.com/p/30d5565a3c8c)
