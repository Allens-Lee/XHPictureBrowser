# XHPictureBrowser

组成部分：
  一、四个属性
    1、touchImgView：点中的图片视图
    
    2、touchIndex：点中的图片视图(touchImgView)在图片视图数组(imageViews)中的下标(必须一致)。当touchImageView或imageViews为空时，或者imageViews的count小于imageUrls的count时，会根据此参数确定默认选中的图片视图。
    
    3、imageViews：图片视图数组。当imageViews的count大于imageUrls的count时，从index=0开始；当imageViews的count小于imageUrls的count且touchImgView包含在imageViews图片视图数组中时，会根据touchImgView对应的touchIndex确定index的对应起始值。
    
    4、imageUrls：图片链接数组(包括网络url和本地url)。始终从index=0开始。
    
  二、两个方法
  
    1、- (void)showIn:(UIViewController *)viewController;
    
      以mode方式缩放显示。单击缩小dismiss，双击放大图片，长按保存图片。
      
    2、- (void)showPushBy:(UIViewController *)viewController;
    
      以push方式push到下一个页面显示。单击渐隐隐藏导航栏、状态栏，双击放大图片，长按保存图片。
      
使用用例：

一、点击查看一个图片的大图。

    XHPictureBrowser *browser = [[XHPictureBrowser alloc]init];
    
    browser.touchImgView = imageView; 
    
    [browser showIn:self];
    
二、点击同属一个父视图的图片。

    XHPictureBrowser *browser = [[XHPictureBrowser alloc]init];
    
    browser.touchIndex = 3;
    
    browser.imageViews = _imageViews;
    
    [browser showIn:self];
    
    或
    
    XHPictureBrowser *browser = [[XHPictureBrowser alloc]init];
    
    browser.touchImgView = imageView; 
    
    browser.imageViews = _imageViews;
    
    [browser showIn:self];
    
    如果在父视图中的图片视图显示的缩略图，在图片浏览器中想显示原图，只需要使用imageUrls提供原图链接就可以了。即：browser.imageUrls = imageUrls;
    
三、在一个tableView中，单击其中一个单元格中的图片，查看整个tableView中的图片。如QQ、微信聊天页面中。

    XHPictureBrowser *browser = [[XHPictureBrowser alloc]init];
    
    browser.touchImgView = cell.imgView;      //点中的单元格的图片视图
    
    browser.touchIndex = index;               //点中的单元格的图片视图在整个tableView的所有含有图片视图的单元格数组中的index
    
    browser.imageViews = imageViews;          //tableView中Visible中的含有图片视图的单元格的图片视图数组
    
    browser.imageUrls = _imageUrls;           //tableView的DataSource中图片类型model中的imageUrl组成的数组
    
    [browser showIn:self];
    
四、只有纯model数据，以push方式显示图片浏览器。如UC浏览器中的图片新闻。

    XHPictureBrowser *browser = [[XHPictureBrowser alloc]init];
    
    browser.imageUrls = @[@"http://f.hiphotos.baidu.com/image/pic/item/a71ea8d3fd1f41348a8ca392211f95cad0c85ea6.jpg"];
    
    [browser showPushBy:self];
		
    
