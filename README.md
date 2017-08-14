# CCPAFNNetworking

AFN 与 MBProgressHUD（注意版本号：version：1.0.0） 的组合封装

首先感谢您的 Star，如果在使用中遇见问题，可以issues。

### DEMO 描述：

AFN与MBProgressHUD的组合使用。加载动画都是从度娘上下载的，效果不是很好只用作展示。
demo中 用到的第三方框架:

AFNetworking,MBProgressHUD,MJRefresh,MJExtension,DGActivityIndicatorView

### DEMO GIF：

![Image text](https://github.com/IMCCP/CCPAFNNetworking/blob/master/CCPAFNNetworking/library/CCPNetworing3.gif)

### DEMO中各个方法介绍：

#### 1.MBProgressHUD 中添加两个方法

```
/**
 *  隐藏 HUD
 */

+ (void) dissmissShowView:(UIView *)showView {
    
 if (showView == nil) {
            
showView = (UIView*)[[[UIApplication sharedApplication]delegate]window];
    
}
        
[self hideHUDForView:showView animated:YES];
    
}
```
```
/**
 *  显示 HUD 
 *  @param imageArr   loading 图片数组
 *  @param showView   HUD 展示的View
 *  @param isFull     是否遮盖全屏
 */
    + (instancetype) showHUDWithImageArr:(NSMutableArray *)imageArr andShowView:(UIView *)showView isFullScreen:(BOOL)isFull{
    
    if (showView == nil) {
        
       showView  = (UIView *)[[UIApplication sharedApplication].delegate window];
    }
  
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
//    hud.backgroundView.backgroundColor = [UIColor redColor];
    if (!isFull) {
        hud.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    }

    if (imageArr == nil) {
        return hud;
    } else {
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *imaegCustomView = [[UIImageView alloc] init];
        imaegCustomView.animationImages = imageArr;
        [imaegCustomView setAnimationRepeatCount:0];
        [imaegCustomView setAnimationDuration:(imageArr.count + 1) * 0.075];
        [imaegCustomView startAnimating];
        
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        hud.bezelView.color = [UIColor clearColor];
        
        hud.customView = imaegCustomView;
        
        hud.square = NO;
        
        return hud;
        
    }
}
```
#### 2.MB分类（MBProgressHUD+ADD.h）方法介绍
```
/**
 *  展示信息
 *  @param information 提示文字
 *  @param view        HUD展示的view
 *  @param afterDelay  展示的时间
 */
+ (MBProgressHUD *)showInformation:(NSString *)information toView:(UIView *)view andAfterDelay:(float)afterDelay {

if (view == nil) view = [UIApplication sharedApplication].keyWindow;
 
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    ;

  hud.mode = MBProgressHUDModeText;
    
  hud.label.text = information;
    
  hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
  [hud hideAnimated:YES afterDelay:afterDelay];
    
   return hud;

}
```
```
/**
 *  展示自定义view
 *  @param customview 自定义的view
 *  @param textString 提示文字
 *  @param view       HUD展示的view
 *  @param afterDelay 展示时间
 */
+ (void)showCustomview:(UIView *)customview andTextString:(NSString *)textString toView:(UIView *)view andAfterDelay:(float)afterDelay {

if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
  hud.mode = MBProgressHUDModeCustomView;
    
  hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
  hud.bezelView.color = [UIColor clearColor];
    
  hud.customView = customview;

  hud.square = YES;

  hud.label.text = textString;
    
  hud hideAnimated:YES afterDelay:afterDelay];

}
```

#### 网络请求工具类方法介绍
```
/**
 *  单例 返回网络请求工具类对象
 */
+ (CCPNetworking *)sharedCCPNetworking;

/**
 *  开启网络监测，监听网络状态的改变
 */
+ (void)startMonitoring;

/**
 *  获取网络状态
 */
+ (NetworkStatu)checkNetStatus;

/**
 *  检测是否有网络连接
 */
+ (BOOL) isHaveNetwork;
```
```
/**
 *  post 或者 get 请求方法,block回调
 *  @param httpMethod       网络请求类型
 *  @param url              请求连接，根路径
 *  @param params           参数字典
 *  @param loadingImageArr  loading图片数组
 *  @param showView         HUD 展示view
 *  @param isFull           是否覆盖全屏
 *  @param success          请求成功返回数据
 *  @param fail             请求失败
 *  @param showHUD          是否显示HUD
 */


+(CCPURLSessionTask *)getOrPostWithType:(httpMethod)httpMethod   WithUrl:(NSString *)url params:(NSDictionary *)params loadingImageArr:(NSMutableArray *)loadingImageArr  toShowView:(UIView *)showView isFullScreen:(BOOL)isFull success:(CCPResponseSuccess)success fail:(CCPResponseFail)fail showHUD:(BOOL)showHUD;
```
```
/**
 *  post 或者 get 请求方法,block回调 , DGActivityIndicatorView 为指示器
 *  @param httpMethod       网络请求类型
 *  @param url              请求连接，根路径
 *  @param params           参数字典
 *  @param animationType    DGActivityIndicatorView 类型的指示器样式 33种
 *  @param color            指示器颜色
 *  @param isFull           是否覆盖全屏
 *  @param isSecret           是否加密
 *  @param success          请求成功返回数据
 *  @param fail             请求失败
 *  @param showHUD          是否显示HUD
 */

+(CCPURLSessionTask *)getOrPostWithType:(httpMethod)httpMethod   WithUrl:(NSString *)url params:(NSDictionary *)params animationType:(AnimationType)animationType animationTypeColor:(UIColor *)color isFullScreen:(BOOL)isFull success:(CCPResponseSuccess)success  fail:(CCPResponseFail)fail showHUD:(BOOL)showHUD;
```
```
/**
 *  上传图片方法 支持多张上传和单张上传
 *  @param image      上传的图片数组
 *  @param url        请求连接，根路径
 *  @param filename   图片的名称(如果不传则以当前时间命名)
 *  @param names      上传图片时参数数组 <后台 处理文件的[字段]>
 *  @param params     参数字典
 *  @param loadingImageArr  loading图片数组
 *  @param showView  HUD 展示view
 *  @param isFull     是否覆盖全屏
 *  @param progress   上传进度
 *  @param success    请求成功返回数据
 *  @param fail       请求失败返回数据
 *  @param showHUD    是否显示HUD
 */

+ (CCPURLSessionTask *)uploadWithImages:(NSArray *)imageArr url:(NSString *)url filename:(NSString *)filename names:(NSArray *)nameArr params:(NSDictionary *)params loadingImageArr:(NSMutableArray *)loadingImageArr toShowView:(UIView *)showView isFullScreen:(BOOL)isFull progress:(CCPUploadProgress)progress success:(CCPResponseSuccess)success fail:(CCPResponseFail)fail showHUD:(BOOL)showHUD;
```
```
/**
 *  下载文件方法
 *  @param url           下载地址
 *  @param saveToPath    文件保存的路径,如果不传则保存到Documents目录下，以文件本来的名字命名
 *  loadingImageArr      loading图片数组
 *  @param showView      HUD 展示view
 *  @param isFull        是否覆盖全屏
 *  @param progressBlock 下载进度回调
 *  @param success       下载完成
 *  @param fail          失败
 *  @param showHUD       是否显示HUD
 *  @return              返回请求任务对象，便于操作
 */
+ (CCPURLSessionTask *)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath loadingImageArr:(NSMutableArray *)loadingImageArr progress:(CCPDownloadProgress )progressBlock toShowView:(UIView *)showView isFullScreen:(BOOL)isFull success:(CCPResponseSuccess )success failure:(CCPResponseFail )fail showHUD:(BOOL)showHUD;
```
注：具体方法实现步骤不再在这里进行展示，浪费大家的时间，DEMO中已经做了很多标注，大家可以下载DEMO查阅。

### DEMO 使用示例
```
 [CCPNetworking getOrPostWithType:GET WithUrl:@"http://newsapi.sina.cn/?resource=feed&accessToken=&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=3d91d5d90c90486cde48597325cf846b699ceb53&deviceModel=apple-iphone5&from=6053093012&idfa=7CE5628E-577A-4A0E-B9E5-283217ECA1F1&idfv=10E31C9D-59AE-4547-BDEF-5FF3EA045D86&imei=3d91d5d90c90486cde48597325cf846b699ceb53&location=39.998602%2C116.365189&osVersion=9.3.5&resolution=640x1136&token=61903050f1141245bfb85231b58e84fb586743436ceb50af9f7dfe17714ee6f7&ua=apple-iphone5__SinaNews__5.3__iphone__9.3.5&weiboSuid=&weiboUid=&wm=b207&rand=221&urlSign=3c861405dd&behavior=manual&channel=news_pic&lastTimestamp=1473578882&listCount=20&p=1&pullDirection=down&pullTimes=8&replacedFlag=1&s=20" params:nil loadingImageArr:self.imageArray toShowView:self.view.window isFullScreen:YES success:^(id response) {
       
      
    } fail:^(NSError *error) {
        
    } showHUD:YES];
```


