//
//  ViewController.swift
//  CSPasswordPanalDemo
//
//  Created by Joslyn Wu on 09/04/2017.
//  Copyright © 2017 joslyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func passwordPanalBtnDidClick(_ sender: UIButton) {
        
        // 默认配置
        CSPasswordPanal.showPwdPanal(entryVC: self, confirmComplete: { (pwd) in
            print("--->" +  pwd)
        }, forgetPwd: {
            print("--->Do find back password logic.")
        })
        
        // 自定义配置
//        CSPasswordPanal.showPwdPanal(entryVC: self, config: {
//            $0.normolColor = UIColor.lightGray
//        }, confirmComplete: { (pwd) in
//            print("--->" +  pwd)
//        }, forgetPwd: {
//            print("--->Do find back password logic.")
//        })
        

    }


}

