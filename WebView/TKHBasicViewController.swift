//
//  TKHBasicViewController.swift
//  HelloLife
//
//  Created by Star童话 on 2019/3/24.
//  Copyright © 2019 STAR. All rights reserved.
//

import UIKit

class TKHBasicViewController: UIViewController, CAAnimationDelegate {
    //    MARK: - Property
    var _popController:TKHBasicViewController?
    var _modalController:TKHBasicViewController?
    var _controllerPanel:TKHBackgroundView?
    var _doNotMoveWhenShowKeyborad:Bool = false
    var _isHaveBorder:Bool = true
    var _oldPopRect:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var _upBackImageView:UIImageView?
    var _backgroundView:TKHBackgroundView?
    var _canTapDismissModal:Bool = true
    var _moveHeight:CGFloat = 0
    var _blackPanel = UIView()
    
    //    MARK: Completed Properties
    var backgroundView:TKHBackgroundView {
        get {
            if _backgroundView == nil {
                _backgroundView = TKHBackgroundView.init(frame: self.view.bounds)
                self.view.insertSubview(_backgroundView!, at: 0)
                _backgroundView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            }
            return _backgroundView!
        }
    }

    //    MARK: Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _blackPanel.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        _blackPanel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _blackPanel.alpha = 0;
    }

    //    MARK: View Load Life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //    MARK: Notification Center
    func addObserverWithViewController() {
        NotificationCenter.default.addObserver(self, selector: Selector(("didKeyboardShow:")), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector(("didKeyboardHide")), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    func removeObserverWithViewController() {
        NotificationCenter.default.removeObserver(self)
    }

    //    MARK: Action
    func didKeyboardShow(notify: NSNotification) {
        if _popController != nil || !_doNotMoveWhenShowKeyborad || notify.userInfo == nil {
            return
        }

        let info:Dictionary = notify.userInfo!
        if info[UIResponder.keyboardAnimationDurationUserInfoKey] != nil && info[UIResponder.keyboardFrameEndUserInfoKey] != nil {
            let frameValue:NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            var panelFrame = _controllerPanel!.frame
            let keyboradHeight = frameValue.cgRectValue.size.height < frameValue.cgRectValue.size.width ? frameValue.cgRectValue.size.height : frameValue.cgRectValue.size.width
            let height = panelFrame.origin.y + panelFrame.size.height - (self.view.bounds.size.height - keyboradHeight)
            
            if (height > 0) {
                _moveHeight = height;
                panelFrame.origin.y -= height
                _controllerPanel?.frame = panelFrame
            } else {
                _moveHeight = 0
            }
        }
    }
    func didKeyboardHide() {
        if _moveHeight > 0 && _controllerPanel != nil {
            var frame = _controllerPanel?.frame
            frame?.origin.y += _moveHeight;
            _controllerPanel?.frame = frame!;
        }
    }

    //    MARK: logic
    func getAbsoluteParent(view:UIView?) -> UIView? {
        if view == nil || view?.superview == nil || view?.superview?.superview == nil {
            return view
        }
        if view?.superview?.superview == view?.window {
            return view
        }
        return getAbsoluteParent(view:view?.superview)
    }
    
    func changePanel(frame:CGRect) {
        changePanel(frame: frame, customBackground: false)
    }
    
    func changePanel(frame:CGRect, customBackground:Bool) {
        if _controllerPanel != nil {
            let view = TKHBackgroundView.init(frame: frame)
            _controllerPanel = view
            if customBackground {
                view.shadowColor = nil
            } else {
                if frame.size.width != self.view.window?.frame.size.width {
                    view.shadowColor = UIColor.init(white: 0, alpha: 0.6)
                }
            }
            if frame.size.width != self.view.window?.frame.size.width {
                view.roundRadius = 0
            }
        }
        self._controllerPanel?.frame = frame
    }
    
    //    MARK: Animation
    func popInView(view:UIView) {
        let animTime:CGFloat = 0.2
        let animation:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = CFTimeInterval(animTime)
        animation.delegate = self
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        let values = [CATransform3DMakeScale(0.99, 0.99, 1.0),
                      CATransform3DMakeScale(1.01, 1.01, 1.0),
                      CATransform3DMakeScale(0.99, 0.99, 1.0),
                      CATransform3DMakeScale(1.0, 1.0, 1.0)]
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        view.layer.add(animation, forKey: nil)
        view.alpha = 0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(TimeInterval(animTime))
        view.alpha = 1
        UIView.commitAnimations()
    }

    func popOutView(view:UIView, completion:@escaping (_ finished:Bool) -> Void) {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            view.alpha = 0
        }, completion: completion)
    }
    
    func slideInView(view:UIView) {
        let actualFrame = view.frame
        var animFrame = actualFrame
        animFrame.origin.y = 1024
        _blackPanel.alpha = 0
        view.alpha = 0
        view.frame = animFrame
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            view.frame = actualFrame
            view.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.4) {
            [weak self] in
            self?._blackPanel.alpha = 1
        }
    }
    func slideOutView(view:UIView, completion:@escaping (_ finished:Bool) -> Void) {
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            var rcController = view.frame
            rcController.origin.y = 1024
            view.frame = rcController
            view.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 0.4, animations: {
            [weak self] in
            self?._blackPanel.alpha = 0
        }, completion: completion)
    }

}
