//
//  CSPasswordPanal.swift
//  CSPasswordPanalDemo
//
//  Copyright © 2017 joslyn. All rights reserved.
//
// https://github.com/JoslynWu/CSPasswordPanal-Swift.git
//

import UIKit

private let passwordPanalMaxY: CGFloat = 391
private let pwdTextField_w: CGFloat = 238
private let pwdTextField_h: CGFloat = 44

class CSPasswordPanal: UIViewController {
    
    
    // MARK: - ------------------public-------------------
    
    /// 一个优美而方便的密码验证的面板。 调用这一个接口即可。
    ///
    /// - Parameters:
    ///   - entryVC: 入口的控制器。 一般传 self
    ///   - config: 用来配置password面板实例的属性
    ///   - confirmComplete: 确认密码时的回调
    ///   - forgetPwd: 忘记密码的回调
    static func showPwdPanal(entryVC: UIViewController, config:((CSPasswordPanal) -> Void)? = nil, confirmComplete: @escaping ((String) -> Void), forgetPwd: @escaping (() -> Void)) {
        let panal = CSPasswordPanal()
        panal.modalPresentationStyle = .overCurrentContext
        panal.confirmClosure = confirmComplete
        panal.forgetClosure = forgetPwd
        config?(panal)
        entryVC.present(panal, animated: false, completion: nil)
    }
    
    // config
    var panalTitle: String = "密码验证"
    var pwdNumCount: Int = 6
    var normolColor: UIColor = UIColor.cs_colorWithHexString(hex: "#909090")    // 提交按钮未激活时的颜色。默认#909090
    var activeColor: UIColor = UIColor.cs_colorWithHexString(hex: "12c286")     // 提交按钮激活时的颜色。默认#12c286

    
    
    
    // MARK: - ------------------private-------------------
    private var confirmClosure: ((String) -> Void)?
    private var forgetClosure: (() -> Void)?

    private var panalView: UIView!
    private var pwdTextField: UITextField!
    private var confirmBtn: UIButton!
    private var pwdString: String = ""
    private lazy var pwdViews = [UIView]()
    
    // MARK: - lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addNotification()
        self.setupUI()
    }
    
    private func setupUI() {
        
        let screen_w: CGFloat = UIScreen.main.bounds.size.width
        
        let panalView_w: CGFloat = 270
        let panalView_h: CGFloat = 220
        let panalView_x = (screen_w - panalView_w) * 0.5
        let panalView_y = passwordPanalMaxY - panalView_h
        let panalView = UIView(frame: CGRect(x: panalView_x, y: panalView_y, width: panalView_w, height: panalView_h))
        self.panalView = panalView
        panalView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        panalView.layer.cornerRadius = 13
        panalView.clipsToBounds = true
        view.addSubview(panalView)
        
        let titleLabel_w: CGFloat = 120
        let titleLabel_h: CGFloat = 24
        let titleLabel_x = (panalView_w - titleLabel_w) * 0.5
        let titleLabel_y: CGFloat = 17.5
        let titleLabel = UILabel(frame: CGRect(x: titleLabel_x, y: titleLabel_y, width: titleLabel_w, height: titleLabel_h))
        titleLabel.text = panalTitle
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.cs_colorWithHexString(hex: "#464646")
        panalView.addSubview(titleLabel)
        
        let cancelBtn_w_h: CGFloat = 24
        let cancelBtn_right: CGFloat = 19.5
        let cancelBtn_x = panalView_w - cancelBtn_right - cancelBtn_w_h
        let cancelBtn_y = titleLabel.center.y - cancelBtn_w_h * 0.5
        let cancelBtn = UIButton.init(frame: CGRect(x: cancelBtn_x, y: cancelBtn_y, width: cancelBtn_w_h, height: cancelBtn_w_h))
        cancelBtn.setImage(self.defaultCancelImage(), for: .normal)
        cancelBtn.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
        panalView.addSubview(cancelBtn)
        
        let pwdTextField_x: CGFloat = (panalView_w - pwdTextField_w) * 0.5
        let pwdTextField_y: CGFloat = 63
        let pwdTextField = UITextField(frame: CGRect(x: pwdTextField_x, y: pwdTextField_y, width: pwdTextField_w, height: pwdTextField_h))
        self.pwdTextField = pwdTextField
        pwdTextField.backgroundColor = UIColor.white
        pwdTextField.layer.borderWidth = 1.0
        pwdTextField.layer.borderColor = UIColor.cs_colorWithHexString(hex: "#e6e6e6").cgColor
        pwdTextField.layer.cornerRadius = 4
        pwdTextField.clipsToBounds = true
        pwdTextField.keyboardType = .numberPad
        pwdTextField.tintColor = UIColor.white
        pwdTextField.becomeFirstResponder()
        panalView.addSubview(pwdTextField)
        
        let forgetBtn_w: CGFloat = 56
        let forgetBtn_h: CGFloat = 18.5
        let forgetBtn_x = panalView_w - pwdTextField_x - forgetBtn_w
        let forgetBtn_y = pwdTextField.frame.maxY + 10
        let forgetBtn = UIButton.init(frame: CGRect(x: forgetBtn_x, y: forgetBtn_y, width: forgetBtn_w, height: forgetBtn_h))
        forgetBtn.setTitle("忘记密码", for: .normal)
        forgetBtn.setTitleColor(UIColor.cs_colorWithHexString(hex: "#909090"), for: .normal)
        forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        forgetBtn.addTarget(self, action: #selector(forgetPwdBtnDidClick(sender:)), for: .touchUpInside)
        panalView.addSubview(forgetBtn)
        

        let confirmBtn_w = pwdTextField_w
        let confirmBtn_h = pwdTextField_h;
        let confirmBtn_x = pwdTextField_x;
        let confirmBtn_y = panalView_h - 20 - confirmBtn_h
        let confirmBtn = UIButton.init(frame: CGRect(x: confirmBtn_x, y: confirmBtn_y, width: confirmBtn_w, height: confirmBtn_h))
        self.confirmBtn = confirmBtn
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.layer.cornerRadius = 4
        confirmBtn.clipsToBounds = true
        confirmBtn.addTarget(self, action: #selector(confirmBtnDidClick(sender:)), for: .touchUpInside)
        self.setConfirmBtnEnabled(false)
        panalView.addSubview(confirmBtn)

        let gridWidth: CGFloat = pwdTextField_w / CGFloat(self.pwdNumCount)
        for index in 1..<pwdNumCount {
            let gridTop: CGFloat = 9
            let lineView = UIView(frame: CGRect(x: CGFloat(index) * gridWidth, y: gridTop, width: 1, height: pwdTextField_h - gridTop * 2))
            lineView.backgroundColor = UIColor.cs_colorWithHexString(hex: "#e6e6e6")
            pwdTextField.addSubview(lineView)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - action
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(panalKeyboardChange(ntf:)), name: NSNotification.Name(rawValue: NSNotification.Name.UIKeyboardWillShow.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(panalKeyboardChange(ntf:)), name: NSNotification.Name(rawValue: Notification.Name.UIKeyboardWillHide.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldChanged(ntf:)), name: NSNotification.Name(rawValue: Notification.Name.UITextFieldTextDidChange.rawValue), object: nil)
    }
    
    private func setConfirmBtnEnabled(_ enabled: Bool) {
        self.confirmBtn.backgroundColor = (enabled ? self.activeColor : self.normolColor);
        self.confirmBtn.isEnabled = enabled;
    }
    
    private func addOnePwd() {
        let viewW: CGFloat = 6
        let count = pwdViews.count
        let everyWidth = pwdTextField_w / CGFloat(self.pwdNumCount)
        let left = (everyWidth - viewW) / 2 + CGFloat(count) * everyWidth
        
        let pwdView = UIView(frame: CGRect(x: left, y: (pwdTextField_h - viewW) * 0.5, width: viewW, height: viewW))
        pwdTextField.addSubview(pwdView)
        pwdView.backgroundColor = UIColor.cs_colorWithHexString(hex: "#464646")
        pwdView.layer.cornerRadius = viewW / 2
        pwdView.clipsToBounds = true
        pwdViews.append(pwdView)
        
        let noSpaceText = pwdTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        pwdString += noSpaceText!
    }
    
    private func defaultCancelImage() -> UIImage {
        let w_h: CGFloat = 12
        UIGraphicsBeginImageContextWithOptions(CGSize(width: w_h, height: w_h), false, 0)
        UIColor.lightGray.setStroke()
        let bzrPath = UIBezierPath()
        bzrPath.lineWidth = 1.0
        bzrPath.move(to: CGPoint.zero)
        bzrPath.addLine(to: CGPoint(x: w_h, y: w_h))
        bzrPath.move(to: CGPoint(x: 0, y: w_h))
        bzrPath.addLine(to: CGPoint(x: w_h, y: 0))
        bzrPath.stroke()
        let cancelImg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return cancelImg
    }
    
    // MARK: - listen
    @objc private func panalKeyboardChange(ntf: Notification) {
        let centerX: CGFloat = UIScreen.main.bounds.size.width * 0.5
        let centerY: CGFloat = UIScreen.main.bounds.size.height * 0.5
        
        if (ntf.name as NSString).isEqual(to: NSNotification.Name.UIKeyboardWillShow.rawValue) {
            view.layer.position = CGPoint.init(x: centerX, y: centerY)
            return
        }
        
        let kbFrame = ntf.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let move = kbFrame.origin.y - passwordPanalMaxY
        
        guard move < 0 else {
            return
        }
        
        view.layer.position = CGPoint(x: centerX, y: centerY - (-move + 30))
    }
    
    @objc private func close(sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func textFieldChanged(ntf: Notification) {
        if (pwdTextField.text! as NSString).isEqual(to: "") {
            let index = pwdViews.count - 1
            if index >= 0 {
                let pwdView = pwdViews[index]
                pwdView.removeFromSuperview()
                pwdViews.removeLast()
                pwdString = (pwdString as NSString).substring(to: pwdString.characters.count - 1)
            }
        } else {
            if self.pwdViews.count < self.pwdNumCount {
                self.addOnePwd();
            }
        }
        
        setConfirmBtnEnabled(self.pwdViews.count == self.pwdNumCount)
        pwdTextField.text = " "
    }
    
    @objc private func forgetPwdBtnDidClick(sender: UIButton) {
        guard (forgetClosure != nil) else {
            return
        }
        forgetClosure?()
        dismiss(animated: false, completion: nil)
    }

    @objc private func confirmBtnDidClick(sender: UIButton) {
        guard sender.isEnabled else {
            return
        }
        confirmClosure?(pwdString)
        dismiss(animated: false, completion: nil)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - ------------------colorTool-------------------
extension UIColor {
    static func cs_colorWithHexString(hex: String, alpha: CGFloat? = 1.0) -> UIColor {
        let hexStr = hex.replacingOccurrences(of: "#", with: "") as NSString
        
        if hexStr.length != 6 && hexStr.length != 3 {
            return UIColor.white
        }
        
        let digits = hexStr.length / 3
        let maxValue: CGFloat = (digits == 1 ? 15.0 : 255.0)
        
        let rString = hexStr.substring(with: NSMakeRange(0, digits))
        let gString = hexStr.substring(with: NSMakeRange(digits, digits))
        let bString = hexStr.substring(with: NSMakeRange(2 * digits, digits))
        
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0;
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor.init(red: CGFloat(r) / maxValue, green: CGFloat(g) / maxValue, blue: CGFloat(b) / maxValue, alpha: alpha!)
    }
}



