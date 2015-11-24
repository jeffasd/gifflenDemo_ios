//
//  ViewController.m
//  test_gifflen_02
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "ViewController.h"
//#import "gifflenlib/gifflen_h.h"
//#import "dibHead.h"

extern      int giffle_Giffle_Init( char * gifName, int w, int h, int numColors, int quality, int frameDelay);
extern      void  giffle_Giffle_Close();
extern      int  giffle_Giffle_AddFrame(int * intPoint);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *filePath = [self backPath:@"Normal"];
    
    NSArray *fileList = [self findGIFImageInNormal:@"jiafei"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *imageDirectory = [path stringByAppendingPathComponent:@"Normal"];
    
    NSMutableArray *_arrayImage = [NSMutableArray array];
    for (NSString *iamgeName in fileList) {
        NSString *fileURL =[imageDirectory stringByAppendingPathComponent:iamgeName];
        //        [UIImage imageWithContentsOfFile:fileURL]
        [_arrayImage addObject:[UIImage imageWithContentsOfFile:fileURL]];
    }
    
    //    NSString *filePath = [self backPath:@"Normal"];
    UIImage *image = _arrayImage[0];
    
    
    int delay = 3;
    int width = image.size.width;
    int height = image.size.height;
    
    
//    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    
//    CFIndex length = CFDataGetLength(bitmapData);
    
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"jpg"];
//    UIImage * img = [[UIImage alloc]initWithContentsOfFile:path];
//    CGImageRef image = [img CGImage];
    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
     int * buffer =  (int *)CFDataGetBytePtr(bitmapData);
    
    CFIndex length = CFDataGetLength(bitmapData);
    
//    CGBitmapContextGetData
    
//    [self RequestImagePixelData1:image];
    
    int * pbuff = RequestImagePixelData(image);
    
    NSString *fileName = [filePath stringByAppendingPathComponent:@"jiafeimao.gif"];
    
    if(giffle_Giffle_Init([fileName cStringUsingEncoding:NSUTF8StringEncoding], width, height, 256, 100, delay)!=0){
        NSLog(@"GifUtil init failed");
        return;
    }
    
    UIImage *image1 = _arrayImage[1];
    int *pbuff1 = RequestImagePixelData(image1);
    
    giffle_Giffle_AddFrame(pbuff);
//    giffle_Giffle_AddFrame(pbuff1);
    giffle_Giffle_Close();
    
    
    //    public void Encode(String fileName,Bitmap[] bitmaps,int delay){
    //        if(bitmaps==null||bitmaps.length==0){
    //            throw new NullPointerException("Bitmaps should have content!!!");
    //        }
    //        int width=bitmaps[0].getWidth();
    //        int height=bitmaps[0].getHeight();
    //
    //        if(Init(fileName,width,height,256,100,delay)!=0){
    //            Log.e(TAG, "GifUtil init failed");
    //            return;
    //        }
    //
    //        for(Bitmap bp:bitmaps){
    //            int pixels[]=new  int[width*height];
    //            bp.getPixels(pixels, 0, width,  0, 0, width, height);
    //            AddFrame(pixels);
    //        }
    //        Close();
    //    }
    
    CFRelease(bitmapData);
//    ViewController后缀为mm可以这样写
//    DIB *dib = new DIB;
//    char *str = "1212";
//    dib->saveBMP(str, YES);
    
}

CGContextRef CreateRGBABitmapContext (CGImageRef inImage){
    CGContextRef context = NULL; CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();  if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space");
        return NULL;
    }
    
//    The number of bits for each component of a pixel is specified by
//        `bitsPerComponent'. The number of bytes per pixel is equal to
//        `(bitsPerComponent * number of components + 7)/8'.
    
    // allocate the bitmap & create context
//    bitmapData = malloc( bitmapByteCount );
    bitmapData = malloc( CGImageGetWidth(inImage) * CGImageGetHeight(inImage) * 4 );
    if (bitmapData == NULL){
        printf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
//    context = CGBitmapContextCreate (bitmapData,
//                                     pixelsWide,
//                                     pixelsHigh,
//                                     8,
//                                     bitmapBytesPerRow,
//                                     colorSpace,
//                                     kCGImageAlphaPremultipliedLast);
    
    NSLog(@"the bit info is %u", CGImageGetBitmapInfo(inImage));
    NSLog(@"the AlphaInfo is %u", CGImageGetAlphaInfo(inImage));
    
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
    
    //error
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNone;
    
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     bitmapInfo);
    
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        //严重crash
        exit(-1);
    }
    
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

    // Return Image Pixel data as an RGBA bitmap
int * RequestImagePixelData(UIImage *inImage) {
        
        CGImageRef img = [inImage CGImage];
        CGSize size = [inImage size];
        CGContextRef cgctx = CreateRGBABitmapContext(img);
        if (cgctx == NULL)
            return NULL;
        
        CGRect rect = {{0,0},{size.width, size.height}};
        CGContextDrawImage(cgctx, rect, img);
    
        int * data = CGBitmapContextGetData (cgctx);
    
    
    
        NSLog(@"the bit info is %u", CGBitmapContextGetBitmapInfo(cgctx));
        NSLog(@"the AlphaInfo is %u", CGBitmapContextGetAlphaInfo(cgctx));
    
        CGContextRelease(cgctx);
        return data;
}

// Return Image Pixel data as an RGBA bitmap
- (int *)RequestImagePixelData1:(UIImage *)inImage
{
    
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    if (cgctx == NULL)
        return NULL;
//       UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    CGRect rect = {{0,0},{size.width, size.height}};
    CGContextDrawImage(cgctx, rect, img);
//            unsigned char *data = CGBitmapContextGetData (cgctx);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
     CGImageRef saveImageRef = CGBitmapContextCreateImage(cgctx);
    UIImage *saveImage = [UIImage imageWithCGImage:saveImageRef];
    
    NSData *imageData = UIImagePNGRepresentation(saveImage);
    NSString *filePath = [self backPath:@"Normal"];
    NSString *fileName = [filePath stringByAppendingPathComponent:@"save.png"];
    [imageData writeToFile:fileName atomically:YES];
//
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, size.width, size.height)];
//    [imageView setImage:[UIImage imageWithContentsOfFile:fileName]];
//    [self.view addSubview:imageView];
    
    
    int * data = CGBitmapContextGetData (cgctx);
    
    //        CGBitmapContextGetBitmapInfo
    
    NSLog(@"the bit info is %u", CGBitmapContextGetBitmapInfo(cgctx));
    
    CGContextRelease(cgctx);
    return data;
}

// void saveiamge(UIImage *inImage)
//{
//    NSData *imageData = UIImagePNGRepresentation(inImage);
//    NSString *filePath = [ViewController backPath:@"Normal"];
//    NSString *fileName = [filePath stringByAppendingPathComponent:@"jiafeimao.gif"];
//    [imageData writeToFile:pathNum atomically:NO];
//}

//返回保存图片的路径
-(NSString *)backPath:(NSString *)directoryName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *imageDirectory = [path stringByAppendingPathComponent:directoryName];
    
    //    [fileManager createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (![fileManager fileExistsAtPath:imageDirectory]) {
        NSLog(@"there is no Directory: %@",imageDirectory);
        [fileManager createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"create Directory: Documents/%@",directoryName);
    }
    NSLog(@"the Directory is exist %@",imageDirectory);
    return imageDirectory;
}

- (NSArray *)findGIFImageInNormal:(NSString *)gifName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *strFile = [documentsDirectory stringByAppendingPathComponent:@"hello/config.plist"];
    //    NSLog(@"strFile: %@", strFile);
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:@"Normal"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPath]) {
        NSLog(@"there is no Directory: %@",strPath);
        //        [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //取得当前目录下的全部文件
    //    NSFileManager *fileManage = [NSFileManager defaultManager];
    //    NSArray *file = [fileManage subpathsOfDirectoryAtPath:strPath error:nil];
    //    NSArray *file = [self getFilenamelistOfType:@"png" fromDirPath:strPath];
    NSArray *file = [self getFilenamelistOfType:@"png" fromDirPath:strPath GIFName:gifName];
    //    NSLog(@"the file is %@", file);
    return file;
    
}

-(NSArray *) getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath GIFName:(NSString *)gifName
{
    NSArray *tempList = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil]
                         pathsMatchingExtensions:[NSArray arrayWithObject:type]];
    NSMutableArray *fileList = [NSMutableArray array];
    for (NSString *fileName in tempList) {
        //       NSString *name = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];
        //        if ([fileName isEqualToString:gifName] ) {
        ////            [fileList removeObject:fileName];
        //            [fileList addObject:fileName];
        //        }
        if ([fileName rangeOfString:gifName].location != NSNotFound) {
            //        if ([fileName rangeOfString:gifName] ) {
            //            [fileList removeObject:fileName];
            [fileList addObject:fileName];
        }
        
        //        NSLog(@"fileName is %@", name);
    }
    tempList = nil;
    
    //    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
    //    NSComparator finderSort = ^(id string1,id string2){
    //
    //        if ([string1 integerValue] > [string2 integerValue]) {
    //            return (NSComparisonResult)NSOrderedDescending;
    //        }else if ([string1 integerValue] < [string2 integerValue]){
    //            return (NSComparisonResult)NSOrderedAscending;
    //        }
    //        else
    //            return (NSComparisonResult)NSOrderedSame;
    //    };
    //
    //    //数组排序：
    //    NSArray *resultArray = [fileList sortedArrayUsingComparator:finderSort];
    //    NSLog(@"第一种排序结果：%@",resultArray);
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray2 = [fileList sortedArrayUsingComparator:sort];
    //    NSLog(@"字符串数组排序结果%@",resultArray2);
    
    
    return resultArray2;
    //    return fileList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/* Program Skeleton
 ----------------
 [select samplefac in range 1..30]
 pic = (unsigned char*) malloc(4*width*height);
 [read image from input file into pic]
	initnet(pic,4*width*height,samplefac,colors);
	learn();
	unbiasnet();
	[write output image header, using writecolourmap(f),
	possibly editing the loops in that function]
	inxbuild();
	[write output image using inxsearch(a,b,g,r)]		*/




























@end
