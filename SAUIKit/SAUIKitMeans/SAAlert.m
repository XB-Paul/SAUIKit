//
//  SAAlert.m
//  SAUIKitTool
//
//  Created by 吴潮 on 16/3/25.author by 学宝
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import "SAAlert.h"

#define kDeviceSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kAlertObject_key @"alertObject_key"
#define kAlertMark_key @"alertMark_key"

static inline NSString *alertIdentifierKey(NSInteger index){
    return [NSString stringWithFormat:@"alert-%ld-key",(long)index];
}

static inline NSString *blockIdentifierKey(NSString *title){
    return [NSString stringWithFormat:@"block-%@-key",title];
}

static inline NSString *markIdentifierValue(NSInteger markValue){
    return [NSString stringWithFormat:@"mark-%ld",(long)markValue];
}

@interface SAAlertManager ()<UIAlertViewDelegate,UIActionSheetDelegate>

/**
 *  仍然弹出在视图中的alert集合
 */
@property (nonatomic, strong) NSMutableDictionary *managerDictionary;

@property (nonatomic, assign) NSInteger currentAlertIndex;

/**
 *  根据序列，删除对应的alert
 *
 *  @param index 序列
 */
-(void)removeAlertAtIndex:(NSInteger)index;

@end

@implementation SAAlertManager

+(SAAlertManager *)shareAlertManager{
    static SAAlertManager *alertManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertManager = [[SAAlertManager alloc] init];
        alertManager.currentAlertIndex = 0;
    });
    return alertManager;
}

-(NSMutableDictionary *)managerDictionary{
    if (_managerDictionary == nil) {
        _managerDictionary = [[NSMutableDictionary alloc] init];
    }
    return _managerDictionary;
}

-(void)dismissAllAlert{
    __weak typeof(self)weakSelf = self;
    [self.managerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id alertObject = obj[kAlertObject_key];
        [weakSelf dismissAlertObject:alertObject alertKey:key];
    }];
}

-(void)dismissAlertByMarkValue:(NSInteger)markValue{
    if (self.managerDictionary.count) {
        __weak typeof(self)weakSelf = self;
        [self.managerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([markIdentifierValue(markValue) isEqualToString:obj[kAlertMark_key]]) {
                id alertObject = obj[kAlertObject_key];
                [weakSelf dismissAlertObject:alertObject alertKey:key];
            }
        }];
    }
}

-(BOOL)isExistAlertByMarkValue:(NSInteger)markValue{
    __block BOOL isExist = NO;
    if (self.managerDictionary.count) {
        [self.managerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([markIdentifierValue(markValue) isEqualToString:obj[kAlertMark_key]]) {
                isExist = YES;
                *stop = YES;
            }
        }];
    }
    return isExist;
}

/**
 @brief 将alert对象dismiss掉
 
 @param alertObj alert对象（UIAlertView、UIActionSheet、UIAlertController）
 @param alertKey alert标识key
 */
-(void)dismissAlertObject:(id)alertObj alertKey:(NSString *)alertKey{
    if (alertObj == nil)    return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([alertObj isKindOfClass:[UIAlertView class]] || [alertObj isKindOfClass:[UIActionSheet class]]) {
            [alertObj dismissWithClickedButtonIndex:[alertObj cancelButtonIndex] animated:YES];
        }else if ([alertObj isKindOfClass:[UIAlertController class]]){
            [(UIAlertController *)alertObj dismissViewControllerAnimated:YES completion:NULL];
        }
        [self.managerDictionary removeObjectForKey:alertKey];
    });
}

-(BOOL)isExistAlert{
    return self.managerDictionary.count;
}

-(void)removeAlertAtIndex:(NSInteger)index{
    [self.managerDictionary removeObjectForKey:alertIdentifierKey(index)];
}

#pragma mark-
#pragma mark-UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSMutableDictionary *blockDictionary = self.managerDictionary[alertIdentifierKey(alertView.tag)];
    SAAlertBlock alertBlock = blockDictionary[blockIdentifierKey(buttonTitle)];
    if (alertBlock) {
        alertBlock();
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.managerDictionary removeObjectForKey:alertIdentifierKey(alertView.tag)];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if (alertView.alertViewStyle) {
        return [alertView textFieldAtIndex:0].text.length ? YES : NO;
    }
    return YES;
}

#pragma mark-
#pragma mark-UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSMutableDictionary *blockDictionary = self.managerDictionary[alertIdentifierKey(actionSheet.tag)];
    SAAlertBlock alertBlock = blockDictionary[blockIdentifierKey(buttonTitle)];
    if (alertBlock) {
        alertBlock();
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.managerDictionary removeObjectForKey:alertIdentifierKey(actionSheet.tag)];
}

@end

#define kAlertIdentifierKey @"alertIdentifier_key"

/**弹出视图的类型*/
typedef NS_ENUM(NSInteger, SAAlertObjectType) {
    /**
     UIAlertView创建的样式
     */
    SAAlertObjectAlertViewType,
    /**
     UIActionSheet创建的样式
     */
    SAAlertObjectActionSheetType,
    /**
     UIAlertController创建的Alert样式
     */
    SAAlertObjectAlertControllerType,
    /**
     UIAlertController创建的ActionSheet样式
     */
    SAAlertObjectActionSheetControllerType
};



@interface SAAlert ()<UIAlertViewDelegate,UIActionSheetDelegate>{
}

@property (nonatomic, strong) NSObject *alertObject;

@property (nonatomic, assign) SAAlertObjectType alertObjectType;

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableDictionary *alertDictionary;

@end

@implementation SAAlert

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelBlock:(SAAlertBlock)cancelBlock otherTitle:(NSString *)otherTitle otherBlock:(SAAlertBlock)otherBlock alertStyle:(SAAlertStyle)alertStyle fromViewController:(UIViewController *)viewController{
    self = [super init];
    if (self) {
        _viewController = viewController;
        [SAAlertManager shareAlertManager].currentAlertIndex++;
        self.index = [SAAlertManager shareAlertManager].currentAlertIndex;
        _alertDictionary = [[NSMutableDictionary alloc] init];
        
        NSString *identifierString=[NSString stringWithFormat:@"type_%ld--title_%@--message_%@--cancelTitle_%@--otherTitle_%@--from_%@***identifier",(long)alertStyle,title,message,cancelTitle,otherTitle,[viewController class]];
        [self.alertDictionary setObject:identifierString forKey:kAlertIdentifierKey];
        if (kDeviceSystemVersion<8.0f || self.viewController == nil) {
            if (alertStyle == SAAlertStyleAlert) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:[SAAlertManager shareAlertManager] cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
                alertView.tag = self.index;
                if (cancelBlock && cancelTitle) {
                    [self.alertDictionary setObject:cancelBlock forKey:blockIdentifierKey(cancelTitle)];
                }
                if (otherBlock && otherTitle) {
                    [self.alertDictionary setObject:otherBlock forKey:blockIdentifierKey(otherTitle)];
                }
                self.alertObject = alertView;
                self.alertObjectType = SAAlertObjectAlertViewType;
            }else{
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:[SAAlertManager shareAlertManager] cancelButtonTitle:cancelTitle destructiveButtonTitle:otherTitle otherButtonTitles:nil];
                actionSheet.tag = self.index;
                if (cancelBlock && cancelTitle) {
                    [self.alertDictionary setObject:cancelBlock forKey:blockIdentifierKey(cancelTitle)];
                }
                if (otherBlock && otherTitle) {
                    [self.alertDictionary setObject:otherBlock forKey:blockIdentifierKey(otherTitle)];
                }
                self.alertObject = actionSheet;
                self.alertObjectType = SAAlertObjectActionSheetType;
            }
        }
        else{
            //弹出UIAlertController
            NSInteger currentIndex = self.index;
            if (alertStyle == SAAlertStyleAlert) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                alertController.view.tag = self.index;
                if (cancelTitle) {
                    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        if (cancelBlock) {
                            cancelBlock();
                        }
                        [[SAAlertManager shareAlertManager] removeAlertAtIndex:currentIndex];
                    }];
                    [alertController addAction:cancelAlertAction];
                }
                if (otherTitle) {
                    UIAlertAction *otherAlertAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (otherBlock) {
                            otherBlock();
                        }
                        [[SAAlertManager shareAlertManager] removeAlertAtIndex:currentIndex];
                    }];
                    [alertController addAction:otherAlertAction];
                }
                
                self.alertObject = alertController;
                self.alertObjectType = SAAlertObjectAlertControllerType;
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
                alertController.view.tag = self.index;
                if (cancelTitle) {
                    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        if (cancelBlock) {
                            cancelBlock();
                        }
                        [[SAAlertManager shareAlertManager] removeAlertAtIndex:currentIndex];
                    }];
                    [alertController addAction:cancelAlertAction];
                }
                
                if (otherTitle) {
                    UIAlertAction *otherAlertAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        if (otherBlock) {
                            otherBlock();
                        }
                        [[SAAlertManager shareAlertManager] removeAlertAtIndex:currentIndex];
                    }];
                    [alertController addAction:otherAlertAction];
                }
                
                self.alertObject = alertController;
                self.alertObjectType = SAAlertObjectActionSheetControllerType;
            }
        }
        if (self.alertObject) {
            [self.alertDictionary setObject:self.alertObject forKey:kAlertObject_key];
        }
    }
    return self;
}

-(NSString *)title{
    return [(id)self.alertObject title];
}

-(void)setTitle:(NSString *)title{
    [(id)self.alertObject setTitle:title];
}

-(NSString *)message{
    switch (self.alertObjectType) {
        case SAAlertObjectAlertViewType:
            return [(UIAlertView *)self.alertObject message];
        case SAAlertObjectAlertControllerType:
        case SAAlertObjectActionSheetControllerType:
            return [(UIAlertController *)self.alertObject message];
        default:
            return nil;
    }
}

-(void)setMessage:(NSString *)message{
    switch (self.alertObjectType) {
        case SAAlertObjectAlertViewType:
            [(UIAlertView *)self.alertObject setMessage:message];
        case SAAlertObjectAlertControllerType:
        case SAAlertObjectActionSheetControllerType:
            [(UIAlertController *)self.alertObject setMessage:message];
        default:
            return;
    }
}

-(void)setMarkValue:(NSInteger)markValue{
    [self.alertDictionary setObject:markIdentifierValue(markValue) forKey:kAlertMark_key];
}

-(void)addButtonWithTitle:(NSString *)title actionBlock:(SAAlertBlock)actionBlock{
    if(self.alertObject == nil)   return;
    
    switch (self.alertObjectType) {
        case SAAlertObjectAlertViewType:
        case SAAlertObjectActionSheetType:{
            if (title) {
                [(id)self.alertObject addButtonWithTitle:title];
            }
            if (title && actionBlock) {
                [self.alertDictionary setObject:actionBlock forKey:blockIdentifierKey(title)];
            }
        }
            break;
        case SAAlertObjectAlertControllerType:
        case SAAlertObjectActionSheetControllerType:{
            NSInteger currentIndex = self.index;
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (actionBlock) {
                    actionBlock();
                }
                [[SAAlertManager shareAlertManager] removeAlertAtIndex:currentIndex];
            }];
            [(UIAlertController *)self.alertObject addAction:alertAction];
        }
            break;
        default:
            break;
    }
}

-(void)addTextFieldWithTextArray:(NSArray *)textArray{
    if (textArray.count == 0 ||  self.alertObject == nil || self.alertObjectType == SAAlertObjectActionSheetType)    return;
    
    switch (self.alertObjectType) {
        case SAAlertObjectAlertViewType:
            if (textArray.count == 1) {
                [(UIAlertView *)self.alertObject setAlertViewStyle:UIAlertViewStylePlainTextInput];
                UITextField *textField = [(UIAlertView *)self.alertObject textFieldAtIndex:0];
                textField.placeholder = textArray.firstObject;
            }else{
                [(UIAlertView *)self.alertObject setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
                UITextField *textField1 = [(UIAlertView *)self.alertObject textFieldAtIndex:0];
                textField1.placeholder = textArray.firstObject;
                UITextField *textField2 = [(UIAlertView *)self.alertObject textFieldAtIndex:1];
                textField2.secureTextEntry = NO;
                textField2.placeholder = textArray.lastObject;
            }
            break;
            
        case SAAlertObjectAlertControllerType:
        case SAAlertObjectActionSheetControllerType:{
            [textArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]]) {
                    [(UIAlertController *)self.alertObject addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = obj;
                    }];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

-(NSArray * )textFieldArray{
    if (self.alertObject == nil || self.alertObjectType == SAAlertObjectActionSheetType)  return nil;
    
    if (self.alertObjectType == SAAlertObjectAlertViewType) {
        if ([(UIAlertView *)self.alertObject alertViewStyle] == UIAlertViewStyleLoginAndPasswordInput) {
            return @[[(UIAlertView *)self.alertObject textFieldAtIndex:0],[(UIAlertView *)self.alertObject textFieldAtIndex:1]];
        }else{
            return @[[(UIAlertView *)self.alertObject textFieldAtIndex:0]];
        }
    }else{
        return [(UIAlertController *)self.alertObject textFields];
    }
}

-(BOOL)isExistSameAlert{
    NSArray *existAlertArray = [[SAAlertManager shareAlertManager].managerDictionary allValues];
    NSString *currentAlertIdentifier = self.alertDictionary[kAlertIdentifierKey];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%@ == %@",kAlertIdentifierKey,currentAlertIdentifier];
    NSArray *sameAlertArray=[existAlertArray filteredArrayUsingPredicate:pred];
    return sameAlertArray.count ? YES : NO;
}

-(void)showAlert{
    if (self.alertObject == nil || [self isExistSameAlert])    return;
    
    [[SAAlertManager shareAlertManager].managerDictionary setObject:self.alertDictionary forKey:alertIdentifierKey(self.index)];
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (self.alertObjectType) {
            case SAAlertObjectAlertViewType:{
                UIAlertView *alertView = (UIAlertView *)self.alertObject;
                if (alertView.delegate == nil) {
                    alertView.delegate = [SAAlertManager shareAlertManager];
                }
                [ alertView show];
            }
                break;
                
            case SAAlertObjectActionSheetType:{
                UIActionSheet *actionSheet = (UIActionSheet *)self.alertObject;
                if (actionSheet.delegate == nil) {
                    actionSheet.delegate = [SAAlertManager shareAlertManager];
                }
                [actionSheet showInView:self.viewController.view];
            }
                break;
                
            case SAAlertObjectAlertControllerType:
            case SAAlertObjectActionSheetControllerType:{
                [self.viewController presentViewController:(UIAlertController *)self.alertObject animated:YES completion:NULL];
            }
                break;
            default:
                break;
        }
    });
}

-(void)dismissAnimated:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (self.alertObjectType) {
            case SAAlertObjectAlertViewType:
            case SAAlertObjectActionSheetType:{
                [(id)self.alertObject setDelegate:nil];
                [(id)self.alertObject dismissWithClickedButtonIndex:[(id)self.alertObject cancelButtonIndex] animated:animated];
                
            }
                break;
                
            case SAAlertObjectAlertControllerType:
            case SAAlertObjectActionSheetControllerType:{
                [(UIAlertController *)self.alertObject dismissViewControllerAnimated:animated completion:NULL];
            }
                break;
            default:
                break;
        }
    });
}




@end

