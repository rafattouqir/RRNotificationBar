//
//  RRNotificationBar.swift
//  RRNotificationBar
//
//  Created by RAFAT TOUQIR RAFSUN on 2/6/17.
//  Copyright © 2017 RAFAT TOUQIR RAFSUN. All rights reserved.
//

import UIKit


open class RRNotificationBar{
    
    lazy var rrNotificationView:RRNotificationView = {
        let notificationView = RRNotificationView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(notificationViewDidTapped))
        notificationView.addGestureRecognizer(tapGesture)
        return notificationView
    }()
    var topConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
    let window:UIWindow = {
        
        guard let window = UIApplication.shared.keyWindow else{
            
            //we should get keywindow,otherwise generate it
            let window = UIWindow(frame:UIScreen.main.bounds)
            window.makeKeyAndVisible()
            return window
        }
        
        return window
    }()
    
    enum NotificationVisibility{
        case showing,hiding,hidden
    }
    
    public var padding:CGFloat = 8
    let height:CGFloat = 60
    public var notificationViewCornerRadius:CGFloat = 12
    let isStatusBarHidden = true
    var notificationVisibility:NotificationVisibility = .hidden
    public var animationDuration:Double = 0.7
    public var dismissDelay:Double = 2.0
    var tapBlock:(()->())?
    
    public init() {
        //        guard let rrNotificationView = rrNotificationView else { return }
        rrNotificationView.viewHolder.layer.cornerRadius = notificationViewCornerRadius
        rrNotificationView.viewHolder.clipsToBounds = true
        
        rrNotificationView.buttonClose.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        
        
        window.addSubview(rrNotificationView)
        window.addConstraintsWithFormat(format: "H:|-\(padding)-[v0]-\(padding)-|", views: rrNotificationView)
        
        topConstraint = NSLayoutConstraint(item: rrNotificationView, attribute: .top, relatedBy: .equal, toItem:window , attribute: .top, multiplier: 1.0, constant: -(self.height))
        window.addConstraint(topConstraint)
        self.window.layoutIfNeeded()
    }
    
    @objc func dismiss(){
        hide()
        
    }
    @objc func notificationViewDidTapped(gesture:UITapGestureRecognizer){
        
        //Exclude the dismiss button, otherwise execute notification bar tap
        guard let view = gesture.view,let filteredView = view.hitTest(gesture.location(in: view),with:nil),
        filteredView !== rrNotificationView.buttonClose else { return }
        
        
        self.tapBlock?()
        self.hide()
    }
    
    
    /**
     Shows a notification just like `iOS 10`.
     
     - Parameter title:   The string to show notification title.
     - Parameter message: The string to show notification message.
     - Parameter time: The string to show notification time, default is `now`.
     - Parameter onTap: On tap block which will be triggered when user has tapped on the notification bar.
     
     */
    public func show(title:String = "",message:String = "",time:String = "",onTap:(()->())? = nil) {
        
        //        guard let rrNotificationView = rrNotificationView else { return }
        
        rrNotificationView.labelTitle.text = title
        rrNotificationView.labelSubTitle.text = message
        rrNotificationView.labelTime.text = time.isEmpty ? "now" : time
        tapBlock = onTap
        UIApplication.shared.isStatusBarHidden = isStatusBarHidden
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveEaseOut,.allowUserInteraction], animations: { [unowned self] in
            self.notificationVisibility = .showing
            self.topConstraint.constant = 0 + self.padding
            self.window.layoutIfNeeded()
            }, completion: { isCompleted in
                DispatchQueue.main.asyncAfter(deadline: .now() + self.dismissDelay, execute: { //[unowned self] in
                    guard let strongSelf = Optional(self) else { return }
                    if strongSelf.notificationVisibility != .hiding || strongSelf.notificationVisibility != .hidden{
                        strongSelf.hide()
                    }
                })
        })
        
    }
    public func hide() {
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: [.curveEaseIn,.allowUserInteraction], animations: { [weak self] in
            guard let strongSelf = self
                else { return }
            
            strongSelf.notificationVisibility = .hiding
            strongSelf.topConstraint.constant = -(strongSelf.rrNotificationView.bounds.height + (2*strongSelf.padding))
            strongSelf.window.layoutIfNeeded()
            }, completion: { isCompleted in
                self.notificationVisibility = .hidden
                UIApplication.shared.isStatusBarHidden = !(self.isStatusBarHidden)
                self.rrNotificationView.removeFromSuperview()
        })
        
    }
    
}



//MARK: - RRNotificationView is the view that is shown in RRNotificationBar
class RRNotificationView:UIView{
    
    
    let imageViewWidth:CGFloat = 30
    let buttonCloseHeight:CGFloat = 20
    var isDropShadowEnabled = true
    
    let viewHolder:UIView = {
        let view = UIView()
        return view
    }()
    let viewHolderTop:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        return view
    }()
    let viewHolderBottom:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        
        if let lastIcon = getAppIconName{
            let icon = UIImage(named: lastIcon)
            imageView.image = icon
        }
        
        imageView.layer.cornerRadius = self.imageViewWidth * 0.2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let labelApp:UILabel = {
        let label = UILabel()
        label.text = getAppName
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        return label
    }()
    let labelTime:UILabel = {
        let label = UILabel()
        label.text = ""
        //        label.backgroundColor = .green
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightUltraLight)
        return label
    }()
    
    
    
    let labelTitle:UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        //        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        return label
    }()
    let labelSubTitle:UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        //        label.backgroundColor = .green
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        return label
    }()
    
    
    
    class DarkView:UIView{
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = bounds.height/2
        }
    }
    
    class var getAppName:String?{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    class var getAppIconName:String?{
        if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,let lastIcon = iconFiles.lastObject as? String{
            return lastIcon
        }else{
            return nil
        }
    }
    
    let buttonClose:UIButton = {
        
        let button = UIButton()
//        button.backgroundColor = .red
        let darkView = DarkView()
        darkView.isUserInteractionEnabled = false
        darkView.backgroundColor = .lightGray
        button.addSubview(darkView)
        button.addConstraint(NSLayoutConstraint(item: darkView, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 0.1, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: darkView, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1.0, constant: 0))
        //        button.addConstraintsWithFormat(format: "H:[v0(30)]", views: darkView)
        button.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: darkView)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isDropShadowEnabled{
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        }
    }
    func addDefaultShadowConfig(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
    }
    
    func setupViews(){
        
        if isDropShadowEnabled{
            addDefaultShadowConfig()
        }
        
        viewHolder.addSubview(viewHolderTop)
        viewHolderTop.addSubview(imageView)
        viewHolderTop.addSubview(labelApp)
        viewHolderTop.addSubview(labelTime)
        
        
        viewHolderTop.addConstraintsWithFormat(format: "H:|-8-[v0(\(imageViewWidth))]-8-[v1]-(>=8)-[v2]-8-|", views: imageView,labelApp,labelTime,options:[.alignAllCenterY])
        viewHolderTop.addConstraintsWithFormat(format: "V:|-8-[v0(\(imageViewWidth))]-(8)-|", views: imageView)
        
        
        
        viewHolder.addSubview(viewHolderBottom)
        
        viewHolderBottom.addSubview(labelTitle)
        viewHolderBottom.addSubview(labelSubTitle)
        viewHolderBottom.addSubview(buttonClose)
        
        
        
        viewHolderBottom.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: labelTitle)
        viewHolderBottom.addConstraintsWithFormat(format: "V:|-4-[v0]-4-[v1]-0-[v2(\(buttonCloseHeight))]-0-|", views: labelTitle,labelSubTitle,buttonClose,options:[.alignAllLeading,.alignAllTrailing])
        
        
        
        viewHolder.addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: viewHolderTop)
        viewHolder.addConstraintsWithFormat(format: "V:|-0-[v0]-0-[v1]-0-|", views: viewHolderTop,viewHolderBottom,options:[.alignAllLeading,.alignAllTrailing])
        
        
        
        addSubview(viewHolder)
        
        viewHolder.boundInside(superView: self)
        
    }
    
}





//MARK:- VFL Extensions
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView... , options: NSLayoutFormatOptions = NSLayoutFormatOptions()) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: nil, views: viewsDictionary))
    }
    
    
    func boundInside(superView: UIView,inset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(inset.left)-[subview]-\(inset.right)-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics:nil, views:["subview":self]))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(inset.top)-[subview]-\(inset.bottom)-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics:nil, views:["subview":self]))
        
    }
    
}
