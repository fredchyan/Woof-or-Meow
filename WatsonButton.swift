//
//  WatsonButton.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/30/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import UIKit

class WatsonButton: UIControl {
    var textLabel: UILabel?
    var activityIndicator: UIActivityIndicatorView?
    var actionBlock: ((weakButton: WatsonButton) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func newButton(center: CGPoint, radius: CGFloat) -> WatsonButton {
        var frame = CGRectMake(center.x - radius, center.y - radius, radius * 2.0, radius * 2.0)
        var button = WatsonButton(frame: frame)
        return button
    }
    
    func setupView(){
        clipsToBounds = true
        layer.cornerRadius = frame.height/2
        addTarget(self, action: "touchUpInside", forControlEvents: UIControlEvents.TouchUpInside)
        textLabel = UILabel(frame: self.bounds)
        addSubview(textLabel!)
        let buttonFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 48.0) ?? UIFont.systemFontOfSize(48.0)
        var attributes = [ NSFontAttributeName : buttonFont, NSForegroundColorAttributeName : UIColor.whiteColor() ]
        var text = NSMutableAttributedString(string: "🌟", attributes: attributes)
        var paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.Center
        text.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSMakeRange(0, text.length))
        textLabel!.attributedText = text
        textLabel?.hidden = false
        backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    func touchUpInside() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator!.frame = bounds
            activityIndicator!.color = UIColor(red: 0.995, green: 0.809, blue: 0.095, alpha: 1.000)
            addSubview(activityIndicator!)
        }
        activityIndicator?.alpha = 0.0
        activityIndicator?.startAnimating()
        
        UIView.animateWithDuration(0.5){
            self.textLabel?.alpha = 0.0
            self.activityIndicator?.alpha = 1.0
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.textLabel?.alpha = 0.0
            self.activityIndicator?.alpha = 1.0
        }) { (finished) -> Void in
            self.enabled = false
        }
        if let actionBlock = actionBlock {
            actionBlock(weakButton: self)
        }
    }
    
    func finish() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.textLabel?.alpha = 1.0
            self.activityIndicator!.alpha = 0.0
        }) { (finished) -> Void in
            self.activityIndicator?.stopAnimating()
            self.enabled = true
        }
    }
    
}
