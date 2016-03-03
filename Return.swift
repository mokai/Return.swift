//
//  Return.swift
//  https://github.com/mokai/Return.swift
//
//  Created by kk on 16/3/3.
//  Copyright © 2016年 kk. All rights reserved.
//
//
//  处理TextFiled键盘上的Return事件，关联到下一个TextField输入事件或者Button点击事件上
//

import UIKit

private var kDelegate = "ReturnDelegate"
extension UITextField {
    /**
    创建代理，如果是第一次访问则创建，并设置self.delegate，所以会把之前的delegate覆盖，如果有的话。
    **/
    var return_delegate: ReturnTextFieldDelegate {
        get{
            if let delegate = objc_getAssociatedObject(self, &kDelegate) as? ReturnTextFieldDelegate {
                return delegate
            } else {
                let delegate = ReturnTextFieldDelegate()
                self.return_delegate = delegate
                return delegate
            }
        }
        set{
            objc_setAssociatedObject(self, kDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.delegate = newValue
        }
    }
}

/**
 扩展TextFieldDelegate
**/
class ReturnTextFieldDelegate: NSObject, UITextFieldDelegate {
    private var nexts: Array<UIView> = []
    private var onReturn: ((textField: UITextField) -> (Bool))?
    private var onEndEditing: ((textField: UITextField) -> Void)?
    
    /**
     下一个接收TextField
     与next方法不同的是nextTo返回下一个接收TextField的return_delegate
     
     - parameter textField:
     
     - returns:下一个接收TextField的return_delegate
     */
    func nextTo(textField textField: UITextField) -> ReturnTextFieldDelegate {
        self.nexts.append(textField)
        return textField.return_delegate
    }
    
    /**
     下一个接收TextField
     */
    func next(textField textField: UITextField) -> ReturnTextFieldDelegate {
        self.nexts.append(textField)
        return self
    }
    
    /**
     下一个接收按钮
     */
    func next(button button: UIButton) -> Self {
        self.nexts.append(button)
        return self
    }
    
    /**
     下一个接收TextView
     */
    func next(textView textView: UITextField) -> Self {
        self.nexts.append(textView)
        return self
    }
    
    
    /**
     当按下Return时触发回调
     需要注意的是如果回调中有becomeFirstResponder操作，应该返回false。
     - parameter action: 回调
     
     - returns:
     */
    func onReturn(action: (textField: UITextField) -> (Bool)) -> Self {
        self.onReturn = action
        return self
    }
    
    func onEndEditing(action: (textField: UITextField) -> Void) -> Self {
        self.onEndEditing = action
        return self
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //处理响应
        var returnValue = true
        for control in self.nexts {
            if let nextTextField = control as? UITextField {
                textField.resignFirstResponder()
                nextTextField.becomeFirstResponder()
                returnValue =  false //必须返回false
            }
            else if let nextTextView = control as? UITextView {
                textField.resignFirstResponder()
                nextTextView.becomeFirstResponder()
                returnValue =  false
            }
            else if let button = control as? UIButton where button.enabled { //当按钮处于激活状态下才可发送事件
                button.sendActionsForControlEvents(.TouchUpInside)
            }
        }
        
        //回调
        if let onReturn = self.onReturn where !onReturn(textField: textField) {
            returnValue = false
        }
        return returnValue
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let onEndEditing = self.onEndEditing {
            onEndEditing(textField: textField)
        }
    }
}