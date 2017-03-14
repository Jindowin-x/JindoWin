#import <Foundation/Foundation.h>
#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#endif
#import <dispatch/base.h>
//各种常常使用的宏，我进行了收集和整理，以后有人更新都依次放入此文件

///////////////////////////////////////////
// Debugging
///////////////////////////////////////////
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

///////////////////////////////////////////
// Views
///////////////////////////////////////////
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)
#define MIDDLEX(view) (CGRectGetMidX(view.frame))
#define MIDDLEY(view) (CGRectGetMidY(view.frame))
#define GLOBALWIDTH [[UIScreen mainScreen] bounds].size.width
#define GLOBALHEIGHT [[UIScreen mainScreen] bounds].size.height
#define MainWindow [UIApplication sharedApplication].keyWindow
#define CenterSubView(view) view.center = CGPointMake(WIDTH(view.superview)/2,HEIGHT(view.superview)/2)

#define VIEWWITHTAG(_OBJECT, _TAG)  [_OBJECT viewWithTag : _TAG]

///////////////////////////////////////////
// Debug Views
///////////////////////////////////////////
#define PrintStringFromView(view) [NSString stringWithFormat:@"%@ position = %@ archorPoint = %@",view,NSStringFromCGPoint(view.layer.position),NSStringFromCGPoint(view.layer.anchorPoint)]
#define PrintView(view) DLog(@"%@",PrintStringFromView(view));

///////////////////////////////////////////
// Block WeakSelf
///////////////////////////////////////////
#define weak(weakself,self) __weak typeof(self) weakself =(id)self;

///////////////////////////////////////////
// Device & OS
///////////////////////////////////////////

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Is4Inches() ([[UIScreen mainScreen] bounds].size.height == 568.0f)
#define Is3_5Inches() ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS4_7Inches() ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS5_5Inches() ([[UIScreen mainScreen] bounds].size.height == 736.0f)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion]floatValue] == v)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion]floatValue] >v)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion]floatValue] >= v)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion]floatValue]<v)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion]floatValue] <= v)

///////////////////////////////////////////
// Networking
///////////////////////////////////////////
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

///////////////////////////////////////////
// Misc
///////////////////////////////////////////
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define URLIFY(urlString) [NSURL URLWithString:urlString]
#define F(string, args...) [NSString stringWithFormat:string, args]
#define ALERT(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];


///////////////////////////////////////////
// Color
///////////////////////////////////////////
#define RGBColor(r,g,b) RGBAColor(r,g,b,1)
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//CUSTOM
#define UN_RedColor RGBColor(248,94,40)
#define UN_WhiteColor RGBColor(245,245,245)
#define UN_FontBlackColor RGBColor(45,45,45)

#define UN_GreenColor RGBColor(161,209,93)
#define UN_GreenColor_CGColor RGBColor(161,209,93).CGColor


#define UN_LineSeperateColor RGBAColor(200,200,200,0.2);
#define UN_CellLineSeperateColor RGBAColor(200,200,200,0.4);


//tabbar colors
#define UN_Tabbar_SelectedColor UN_RedColor
#define UN_Tabbar_NormalColor UN_FontBlackColor
#define UN_Navigation_FontColor UN_WhiteColor

#define UN_FilterQuan UN_RedColor
#define UN_FilterTejia RGBColor(236, 0, 27)
#define UN_FilterXin RGBColor(30, 212, 18)
#define UN_FilterJian RGBColor(53, 75, 166)
#define UN_FilterYu RGBColor(239, 179, 12)
#define UN_FilterMian RGBColor(184, 0, 109)
#define UN_FilterQuan2 RGBColor(238, 174, 03)

///////////////////////////////////////////
// Font
///////////////////////////////////////////
#define Font(size) [UIFont systemFontOfSize:(size)/1.f]


////////////////////////////////////////////
// Math
////////////////////////////////////////////
#define EXP2(x) ((x)*(x))

///////////////////////////////////////////
// main thread
//////////////////////////////////////////
DISPATCH_INLINE DISPATCH_ALWAYS_INLINE DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void
_dispatch_main(dispatch_block_t block)
{
    if (block) {
        dispatch_async(dispatch_get_main_queue(),block);
    }
}
#undef runInMainThread
#define runInMainThread _dispatch_main

///////////////////////////////////////////
// inline method
//////////////////////////////////////////
#ifdef TARGET_OS_IPHONE
static inline NSString *imagePathByInches(NSString *strName){
    if(IS4_7Inches()){
        return [NSString stringWithFormat:@"%@6",strName];
    }else if(IS5_5Inches()){
        return [NSString stringWithFormat:@"%@6plus",strName];
    }else if(Is4Inches()){
        return [NSString stringWithFormat:@"%@5s",strName];
    }else if (Is3_5Inches()){
        return [NSString stringWithFormat:@"%@5s",strName];
    }
    return strName;
}

#endif

////////////////////////////////////////////
// NOTIFICATIONS
////////////////////////////////////////////
static NSString *UN_DidSelectTabControllernotification = @"UN_DidSelectTabControllernotification";

static NSString *UN_MainAddressDidChangeNotification = @"UN_MainAddressDidChangeNotification";

static NSString *UN_LocationDidGetPoiListNotification = @"UN_LocationDidGetPoiListNotification";

static NSString *UN_LocationDidRequestUpdateNotification = @"UN_LocationDidRequestUpdateNotification";

static NSString *UN_OrderDidSendToPayClientBackNotification = @"UN_OrderDidSendToPayClientBackNotification";
////////////////////////////////////////////
// static value
////////////////////////////////////////////
static float UN_TabbarHeight = 44.f;
static float UN_NarbarHeight = 64.f;

////////////////////////////////////////////
// static inline
////////////////////////////////////////////
static inline UIImage *imageWithColorInRect(UIColor *color,CGRect rect){
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *imge = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imge;
}

static inline NSString* UUID(){
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil,puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL,uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


typedef NS_ENUM(NSUInteger, OrderPaymentType) {
    OrderPaymentTypeNone = 1 << 0,
    OrderPaymentTypeAli = 1 << 1,
    OrderPaymentTypeWechat = 1 << 2,
};

typedef NS_ENUM(NSUInteger, LocationUpdateStatus) {
    LocationUpdateStatusNone        = 1 << 1,
    LocationUpdateStatusError       = 1 << 2,
    LocationUpdateStatusUpdating    = 1 << 3,
    LocationUpdateStatusDone        = 1 << 4,
};

////////////////////////////////////////////
// 支付宝支付相关
////////////////////////////////////////////

static NSString *Alipay_Appid = @"2016032901251995";
static NSString *Alipay_ParterID = @"2088121625250897";
static NSString *Alipay_SellerID = @"2088121625250897";
static NSString *Alipay_Service = @"mobile.securitypay.pay";
static NSString *Alipay_InputCharset = @"utf-8";
//static NSString *Alipay_PrivateKey = @"az78mci9cz9696evvvjqzk2064cgk7qn";
static NSString *Alipay_PrivateKey = @"MIICWwIBAAKBgQDE8Oieo5AiGNrx7se+4zigFL6fd/F7KINQsWgJhYvksqP2lL4cyubudWZbicVneHn1is1V8uXIqR0fUZjXZ0iK90DJyx+5OrBJrlH/pZO1pCpp7EulzZSAJZ6NBK3yxuI6rrmDIybyM5YtNszQmjHo4wQt8ZA/0SkPA7LNI3/WMwIDAQABAoGAcilMTxl1Za6OzIukEk1Y98LOtVYsDz5u0InmSw61Bz9euIOEqOAdecFoMkvsuIwn9mQdn2MMPIN7tDnypXrjm1Yp11xDMUIf9ML/iI63iLsYSB9CMUdvUgl7cRImak9Udz8pHkbFy+mSvc8BGMe2B/+yz2qSLzKSK6w6Io3QBVECQQDqAhBtMcDCVOs837hkIQOiA2s6DqQnb3oMjWXJyoc5HUrXpnMBZIYB7UABLXRLaswyECuQEY1BfjpUEdbUWH0HAkEA13MPM+Pu610IvCmEjGTwVhvQZ7GRQFxMKR80zeo5GMSp14e9O/H6qoF7oATmRMkit6VZQl19vSTMUGLvRkE+dQJAC4L+e+CusuCqkdwPnh1hqF6yr7B4stfxER0DnOGxtUWToPg3QCJJ1V5uf6BU0ED4up3BBt1WLZqgE/KsttWDkQJADsv7LlAoN4fzMqETVmUUUIWmgYijdi0gme5nvQCqHTZch83txDExSwaLjAjqG61Ish4sDC/Jk/T0B01UK5oNhQJAUlkt+mZbqQ8uhFkg8EkAp/hhUlECPEia/YVXlxrrcXzxABTkPSHmM8THUAMhnXX1A4ixVn9eKt6aKm4W+uDulQ==";
//支付类型，1：商品购买。(不传情况下的默认值)
static NSString *Alipay_PaymentType = @"1";
//如果这里修改了schema 那么对应的 URLType也需要修改
static NSString *Alipay_AppSchema = @"jindouyunwaimaialipay";





