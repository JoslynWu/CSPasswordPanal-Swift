# CSPasswordPanal-Swift
一个优美而方便的密码验证面板。有忘记密码功能。可配置密码位数，已经做好屏幕适配。
本版本为[Swift版](https://github.com/JoslynWu/CSPasswordPanal-Swift.git)。

## Objective-C版入口：[CSPasswordPanal-OC](https://github.com/JoslynWu/CSPasswordPanal.git)

## 效果图
![](/Screenshot/CSPasswordPanal.png)


## 怎么接入
直接将下面文件（在CSPasswordPanal文件夹中）添加（拖入）项目中

```
CSPwdPanalViewController.swift
```

## 怎么用
调用一个类方法即可

```
tatic func showPwdPanal(entryVC: UIViewController, config:((CSPwdPanalViewController) -> Void)? = nil, confirmComplete: @escaping ((String) -> Void), forgetPwd: @escaping (() -> Void));
```

**Example:**

```
使用默认配置：
CSPwdPanalViewController.showPwdPanal(entryVC: self, confirmComplete: { (pwd) in
	print("--->" +  pwd)
}, forgetPwd: {
	print("--->Do find back password logic.")
})
 
自定义配置：
CSPwdPanalViewController.showPwdPanal(entryVC: self, config: {
    $0.normolColor = UIColor.lightGray
}, confirmComplete: { (pwd) in
    print("--->" +  pwd)
}, forgetPwd: {
    print("--->Do find back password logic.")
})
```


## 哪些属性可配置

```
panalTitle: String   // 面板标题。默认为"密码验证"。
pwdNumCount: Int     // 密码位数。默认6位。
normolColor: UIColor // 提交按钮未激活时的颜色。默认#909090
activeColor: UIColor // 提交按钮激活时的颜色。默认#12c286
```

## 怎么Clone

```
git clone --recursive https://github.com/JoslynWu/CSPasswordPanal-Swift.git
```



