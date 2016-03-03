# Return.swift
处理Textfield键盘Return事件,关联到下一个TextField输入事件或者下一个按钮点击事件

#使用

###连续的
```
phoneTextField.return_delegate
  .nextTo(textField: pwdTextField) 
  .nextTo(textField: codeTextField) 
  .next(button: loginBtn)
```

###单一的

```
phoneTextField.return_delegate.next(textField: pwdTextField)
pwdTextField.return_delegate.next(textField: codeTextField)
codeTextField.return_delegate.next(button: loginBtn)
```

> #####next和nextTo方法区别在于，前者返回本身，后者返回下一个TextField的return_delegate

###回调

```
pwdTextField.return_delegate.onReturn { (textField) -> (Bool) in
    //...
}
```

