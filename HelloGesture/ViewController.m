//
//  ViewController.m
//  HelloGesture
//
//  Created by 何旻曄 on 2016/5/16.
//  Copyright © 2016年 MINYEH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic) NSMutableArray * fonts;
@property (nonatomic) NSInteger index;
//字體大小 CGFloat不是物件類似NSInteger以位元去判斷現在該是什麼 32位元 是double
@property (nonatomic) CGFloat currentFontSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //字形初始化
    self.fonts = [NSMutableArray array];
    //尋訪所有字型，但因為字形廠商也有幫忙在做粗體版跟細體版所以要多一個forin去找
    for(NSString *familyName in [UIFont familyNames])
    {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            [self.fonts addObject:fontName];
        }
    }
    
    //字型設定在第零個
    self.index = 0;
    //字型大小預設12
    self.currentFontSize = 12;
    
    
    //建立手勢-滑動（swipe）
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeFont:)];
    //設定往左滑動
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    //更新畫面上的文字
    [self refreshDisplayText];
    
    //一個手勢無法偵測兩個動作，所以要在宣告一個手勢
    //設定往右滑動
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeFont:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.label addGestureRecognizer:leftSwipeGesture];
    [self.label addGestureRecognizer:rightSwipeGesture];
    
    //放大縮小的手勢
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(changeFontSize:)];
    [self.label addGestureRecognizer:pinch];
    
    //雙擊手勢
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chageText:)];
    //需點擊幾下
    tap.numberOfTapsRequired = 2;
    [self.label addGestureRecognizer:tap];
}

-(void)chageText:(UITapGestureRecognizer*) tap
{
    //準備警告視窗
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"請輸入要改寫的文字" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //加文字框在警告視窗
    [alertController addTextFieldWithConfigurationHandler:nil];
    //準備警告視窗的按鈕
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"輸入完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取得警告視窗上的文字框
        UITextField *textField = alertController.textFields[0];
        //將文字框輸入的內容給label
        self.label.text = textField.text;
    }];
    //將按鈕加到視窗上
    [alertController addAction:action];
    //顯示警告視窗
    [self presentViewController:alertController animated:true completion:nil ];
}
-(void)changeFont:(UISwipeGestureRecognizer *)swipe
{
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        //前進到下一個字體
        self.index += 1;
    }
    else
    {
        //退後到上一個字體
        self.index -= 1;
    }
    
    [self refreshDisplayText];
    
    //這裡有個bug要自行解決
        
}

-(void)refreshDisplayText
{
    //從陣列中拿取字型名稱
    NSString *fontname = [self.fonts objectAtIndex:self.index];
    //將字型名稱轉成字體
    UIFont *font = [UIFont fontWithName:fontname size:self.currentFontSize];
    //將字型給label
    self.label.font = font;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeFontSize:(UIPinchGestureRecognizer *)pinch
{
    self.currentFontSize *= pinch.scale;
    //是因為每次放大縮小時都會一直進來這個方法，scale會一直跟著成長，會導致一下子就爆了
    //所以每乘完後都把scale設成1就不會馬上爆開
    pinch.scale = 1.0;
    [self refreshDisplayText];
}

@end
