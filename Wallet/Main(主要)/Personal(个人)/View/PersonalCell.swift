//
//  PersonalCell.swift
//  Wallet
//
//  Created by tam on 2017/8/25.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class PersonalCell: UITableViewCell {

    var dataScore :[String] = [String]()
    
    var personalCallBackBlock:((UIButton)->())?
    
    struct PersonalUX {
        static let iconImageSize:Int = Int(XMAKE(23))
        static let titleFont:UIFont = UIFont.systemFont(ofSize: 15)
        static let leftImageSize:CGSize = CGSize(width: XMAKE(10), height: YMAKE(12))
        static let backgroundHeight:CGFloat = YMAKE(47)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setList(_ data:NSArray,_ icon:NSArray,_ cellTag:Int) {
        let shadowView = UIView()
        shadowView.layer.cornerRadius = 5
        shadowView.backgroundColor =  UIColor.R_UIRGBColor(red: 240, green: 240, blue: 240, alpha: 1)
        shadowView.clipsToBounds = true
        contentView.addSubview(shadowView)
        
        let view = UIView()
        view.layer.cornerRadius = shadowView.layer.cornerRadius
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        contentView.addSubview(view)
        
        for item in 0...data.count - 1 {
            
            let backgroundVw = UIView()
            backgroundVw.frame = CGRect(x: 0 , y: CGFloat(Int(PersonalUX.backgroundHeight) * item) , width: SCREEN_WIDTH , height: PersonalUX.backgroundHeight)
            backgroundVw.tag = item + 1
            view.addSubview(backgroundVw)
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: (icon[item] as? String)!)
            imageView.frame = CGRect(x: 20, y: Int(backgroundVw.frame.size.height/2) - Int(PersonalUX.iconImageSize/2) , width: PersonalUX.iconImageSize, height: PersonalUX.iconImageSize)
            backgroundVw.addSubview(imageView)
            
            let titleLable = UILabel()
            titleLable.text = data[item] as? String
            titleLable.font = PersonalUX.titleFont
            titleLable.frame = CGRect(x: imageView.frame.maxX + XMAKE(15), y: imageView.frame.origin.y, width: 170.0, height:CGFloat(PersonalUX.iconImageSize))
            backgroundVw.addSubview(titleLable)
            
            let layers = CALayer()
            layers.frame = CGRect(x: titleLable.frame.origin.x , y: backgroundVw.frame.size.height, width: SCREEN_WIDTH  ,height:0.5)
            layers.backgroundColor  = UIColor.R_UIColorFromRGB(color: 0xdddddd).cgColor
            backgroundVw.layer.addSublayer(layers)

            let leftImage = UIImageView()
            leftImage.image = UIImage(named: "ic_personal_right")
            view.addSubview(leftImage)
            leftImage.snp.makeConstraints({ (make) in
                make.centerY.equalTo(imageView.snp.centerY)
                make.right.equalTo(view.snp.right).offset(-XMAKE(20))
                make.size.equalTo(PersonalUX.leftImageSize)
            })
            
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: backgroundVw.frame.size.width, height: backgroundVw.frame.size.height)
            button.tag = cellTag + item
            button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
            backgroundVw.addSubview(button)
        }

        let views = viewWithTag(data.count)!
        
        view.frame = CGRect(x: XMAKE(20), y: 0, width: SCREEN_WIDTH - XMAKE(40), height: views.frame.maxY)
        shadowView.frame = CGRect(x: XMAKE(20), y: 0, width: SCREEN_WIDTH - XMAKE(40), height: views.frame.maxY + YMAKE(3))
        
        UserDefaults.standard.set(shadowView.frame.maxY, forKey: "height")
    }

    func onClick(_ sender:UIButton) {
        if self.personalCallBackBlock != nil {
            self.personalCallBackBlock!(sender);
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
