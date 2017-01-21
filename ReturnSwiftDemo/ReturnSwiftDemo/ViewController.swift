//
//  ViewController.swift
//  ReturnSwiftDemo
//
//  Created by gongkai on 2017/1/21.
//  Copyright © 2017年 kk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!

    @IBOutlet weak var sendCodeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup return
        let _ = phoneTextField
            .return_delegate
            .next(button: sendCodeBtn)
        
        let _ = codeTextField.return_delegate.next(button: loginBtn)
    }

    @IBAction func onSendCodeClick(_ sender: Any) {
        sendCodeBtn.setTitle("重新获取", for: .normal)
        codeTextField.becomeFirstResponder()
    }

    @IBAction func onLoginClick(_ sender: Any) {
        let alertVC = UIAlertController(title: "已登录", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "知道了", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

}

