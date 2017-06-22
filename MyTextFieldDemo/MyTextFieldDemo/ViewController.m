//
//  ViewController.m
//  MyTextFieldDemo
//
//  Created by arges on 2017/6/19.
//  Copyright © 2017年 ArgesYao. All rights reserved.
//

#import "ViewController.h"
#import "YJJTextField.h"

@interface ViewController ()

/** 输入框数组 */
@property (nonatomic,strong) NSArray *textFieldArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


- (void)setupUI
{
    YJJTextField *userNameField = [YJJTextField yjj_textField];
    userNameField.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    userNameField.maxLength = 11;
    userNameField.errorStr = @"字数长度不得超过11位";
    userNameField.placeholder = @"请输入用户名";
    userNameField.historyContentKey = @"userName";
    [self.view addSubview:userNameField];
    
    YJJTextField *passwordField = [YJJTextField yjj_textField];
    passwordField.frame = CGRectMake(0, 160, self.view.frame.size.width, 80);
    passwordField.maxLength = 6;
    passwordField.errorStr = @"密码长度不得超过6位";
    passwordField.placeholder = @"请输入密码";
    passwordField.historyContentKey = @"password";
    passwordField.leftImageName = @"password_login";
    passwordField.showHistoryList = NO;
    [self.view addSubview:passwordField];
    
    self.textFieldArr = @[userNameField,passwordField];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-90,self.view.frame.size.width, 40)];
    saveButton.backgroundColor = [UIColor purpleColor];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitle:@"保存输入记录" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40,self.view.frame.size.width, 40)];
    deleteButton.backgroundColor = [UIColor redColor];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTitle:@"删除历史记录" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
}

- (void)saveClick
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *originalDic = [defaults objectForKey:@"historyContent"];
    if (originalDic == nil) {  // 如果系统中没有记录
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (YJJTextField *textField in self.textFieldArr) {
            // 用数组存放输入的内容，并作为保存字典的Value，Key为用户在创建时自己指定
            NSArray *array = [NSArray arrayWithObject:textField.textField.text];
            [dic setObject:array forKey:textField.historyContentKey];
        }
        [defaults setObject:dic forKey:@"historyContent"];
    }else{
        __block NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (YJJTextField *textField in self.textFieldArr) {
            // 遍历所有TextField，取出当前文本框的Key和内容
            NSString *currentKey = textField.historyContentKey;
            NSString *currentText = textField.textField.text;
            
            __block NSMutableArray *contentArray;
            
            // 遍历已经存在的记录
            [originalDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *obj, BOOL * _Nonnull stop) {
                contentArray = [NSMutableArray arrayWithArray:obj];
                if ([key isEqualToString:currentKey]) {  // 如果当前Key和字典中的Key相同，则添加Value
                    [contentArray addObject:currentText];
                    // 去除重复的记录
                    NSSet *set = [NSSet setWithArray:contentArray];
                    contentArray = (NSMutableArray *)set.allObjects;
                    [newDic setObject:contentArray forKey:currentKey];
                    *stop = YES;
                }
            }];
        }
        [defaults setObject:newDic forKey:@"historyContent"];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteClick
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"historyContent"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (YJJTextField *textField in self.textFieldArr) {
        
        [textField setPlaceHolderLabelHidden:YES];
        [textField dismissTheHistoryContentTableView];
    }
    [self.view endEditing:YES];
}

@end
