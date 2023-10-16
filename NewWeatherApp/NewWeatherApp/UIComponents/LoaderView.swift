//
//  LoaderView.swift
//  NewWeatherApp
//
//  Created by Arun on 12/10/23.
//

import Foundation
import UIKit


public extension PDIndicator {
    class func dismiss() {
        DispatchQueue.main.async {shared.indicatorHide()}
    }
    class func show() {
        DispatchQueue.main.async {shared.setup()}
    }
    class func show(withText:String) {
        DispatchQueue.main.async {shared.setup(status: withText)}
    }
}

public class PDIndicator: UIView {
    var activityView: UIActivityIndicatorView?
    private var viewBackground: UIView?
    private var labelStatus: UILabel?
    private var colorBackground    = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    static let shared: PDIndicator = {
        let instance = PDIndicator()
        return instance
    } ()
    
    convenience private init() {
        self.init(frame: UIScreen.main.bounds)
        self.alpha = 0
    }
    
    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setup(status: String? = nil) {
        setupBackground(false)
        indicatorShow()
        setupLabel(status)
        setupSize()
    }
    
    private func setupBackground(_ interaction: Bool) {
        if (viewBackground == nil) {
            let mainWindow = UIApplication.shared.currentUIWindow() ?? UIWindow()
            viewBackground = UIView(frame: self.bounds)
            mainWindow.addSubview(viewBackground ?? UIView())
        }
        viewBackground?.backgroundColor = interaction ? .clear : colorBackground
        viewBackground?.isUserInteractionEnabled = (interaction == false)
    }
    private func setupLabel(_ status: String?) {
        if (labelStatus == nil) {
            labelStatus = UILabel()
            labelStatus?.textAlignment = .center
            labelStatus?.baselineAdjustment = .alignCenters
            labelStatus?.numberOfLines = 0
            labelStatus?.textColor = UIColor.white
            //labelStatus?.font = UIFont(name: UIFont.Nunito.SemiBold, size: 17.0)
            labelStatus?.sizeToFit()
            viewBackground?.addSubview(labelStatus ?? UILabel())
        }
        labelStatus?.text = (status != "") ? status : nil
        labelStatus?.isHidden = (status == nil) ? true : false
    }
    private func setupSize() {
        var width: CGFloat = 120
        var height: CGFloat = 120
        if let text = labelStatus?.text {
            let sizeMax = CGSize(width: 250, height: 250)
            let attributes: [NSAttributedString.Key: Any] = 
            [NSAttributedString.Key.font: labelStatus?.font as Any]
            var rectLabel = text.boundingRect(with: sizeMax, options: 
                    .usesLineFragmentOrigin, attributes: attributes, context: nil)
            width = ceil(rectLabel.size.width) + 60
            height = ceil(rectLabel.size.height) + 120
            if (width < 120) { width = 120 }
            rectLabel.origin.x = (width - rectLabel.size.width) / 2
            rectLabel.origin.y = (height - rectLabel.size.height) / 2 + 45
            labelStatus?.frame = rectLabel
        }
        let mainWindow = UIApplication.shared.currentUIWindow() ?? UIWindow()
        let screen = mainWindow.bounds
        let center = CGPoint(x: screen.size.width/2, y: (screen.size.height)/2 + 50)
        UIView.animate(withDuration: 0.0, delay: 0, options: .allowUserInteraction, animations: {
            self.labelStatus?.center = center
            self.viewBackground?.frame = screen
        }, completion: nil)
    }
  
    private func indicatorShow() {
        if let mainView = viewBackground {
            activityView = UIActivityIndicatorView(style:.large)
            activityView?.center = mainView.center
            mainView.addSubview(activityView!)
            activityView?.startAnimating()
        }
    }
    private func indicatorHide() {
        if (activityView != nil){
            activityView?.stopAnimating()
        }
        viewBackground?.removeFromSuperview()
        viewBackground = nil
        labelStatus = nil
        self.removeFromSuperview()
    }
}
