//
//  SAAlert.h
//  SAUIKitTool
//
//  Created by 吴潮 on 16/3/25. author by 学宝
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  弹出视图的管理对象
 */
@interface SAAlertManager : NSObject

/**
 *  单例出一个对弹出视图的管理对象
 *
 *  @return 管理对象
 */
+(SAAlertManager *)shareAlertManager;


/**
 *  使所有的Alert对象消失
 */
-(void)dismissAllAlert;

/**
 *  使对应markValue的Alert消失
 *
 *  @param markValue 在定义Alert时赋值
 */

-(void)dismissAlertByMarkValue:(NSInteger)markValue;


/**
 *  判断对应的markValue的alert是否存在
 *
 *  @param markValue 与初始化alert时设置的一致
 *
 *  @return 是否存在
 */
-(BOOL)isExistAlertByMarkValue:(NSInteger)markValue;

/**
 *  检测当前是否有Alert存在
 *
 *  @return 是否存在Alert
 */
-(BOOL)isExistAlert;

@end

/**
 *  弹出视图的样式
 */
typedef NS_ENUM(NSInteger, SAAlertStyle) {
    /**
     *  从底部弹出actionSheet
     */
    SAAlertStyleActionSheet = 0,
    /**
     *  从中心弹出Alert
     */
    SAAlertStyleAlert
};

/**
 *  弹出视图action回调block
 */
typedef void(^SAAlertBlock)();

/**
 @author 学宝, 15-12-03 09:12:21
 @brief 弹出对象
 */

@interface SAAlert : NSObject

/**
 @brief 初始化Alert
 
 @param title          标题
 @param message        内容
 @param cancelTitle    结束title
 @param cancelBlock    按下结束按钮时执行的block
 @param otherTitle     其他title
 @param otherBlock     按下对应其他title时执行的block
 @param alertStyle     alert的样式，有Alert和ActionSheet两种
 @param viewController 当前控制器对象（若为空时，将会走iOS8之下的路线，不推荐设置为nil）
 
 @warning 设置不同 button的title  不可以相同
 
 @return alert对象
 
 */
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelBlock:(SAAlertBlock)cancelBlock otherTitle:(NSString *)otherTitle otherBlock:(SAAlertBlock)otherBlock alertStyle:(SAAlertStyle)alertStyle fromViewController:(UIViewController *)viewController;


@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

/**
 *  Alert所包含的textField
 */
@property (nonatomic, readonly) NSArray <UITextField*> *textFieldArray;


/**
 *  标识Alert，在SAAlertManager中可使用这个标识
 *
 *  @param markValue 标签值
 */
-(void)setMarkValue:(NSInteger)markValue;

/**
 *  当初始化的按钮不够时，可调用此方法添加
 *
 *  @param title 按钮的title
 *  @param actionBlock 按钮的block
 *  @warning alert 的title  不可以相同
 */
-(void)addButtonWithTitle:(NSString *)title actionBlock:(SAAlertBlock)actionBlock;

/**
 *  当alert需要textField时，可调用此方法添加
 *
 *  @param textArray 一个作为textField的placeholder的数组
 */
-(void)addTextFieldWithTextArray:(NSArray *)textArray;

/**
 *  当Alert初始化完成，且需要添加的组件已经添加完成，调用此方法
 *
 */
-(void)showAlert;

/**
 *  让alert消失
 *
 *  @param animated    是否动画
 */
- (void)dismissAnimated:(BOOL)animated;


@end
