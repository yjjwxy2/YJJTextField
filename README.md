## 特点
- [x] 占位文字上浮
- [x] 输入内容错误时，下方显示提示信息
- [x] 输入框右下角显示字数限制
- [x] 显示历史输入记录列表，方便用户输入
- [x] 线型边框，输入时/错误时改变线条颜色

## 预览
![image](https://github.com/yjjwxy2/YJJTextField/blob/master/gif/yjjtextfield.gif)

## 使用
1. 创建
```objc
    YJJTextField *textField = [YJJTextField yjj_textField];
    textField.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    textField.maxLength = 11;
    textField.errorStr = @"字数长度不得超过11位";
    textField.placeholder = @"请输入用户名";
    textField.historyContentKey = @"userName";
    [self.view addSubview:textField];
```
2. 保存历史记录(如果需要)
```objc
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
```

## 反馈
由于本人第一次写东西上传到github，代码质量会存在很多问题，希望各位大佬们在使用时能尽量理解，如果遇到问题或者有什么好的建议请及时联系我：yjjwxy2@163.com 如果你觉得还OK的话，帮忙给个星星吧，十分感谢！
