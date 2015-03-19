//
//  StatusCell.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/19.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {
    
    /// 头像
    @IBOutlet weak var iconImage: UIImageView!
    
    /// 会员图标
    @IBOutlet weak var memberImage: UIImageView!
    
    /// 认证图标
    @IBOutlet weak var vipImage: UIImageView!
    
    /// 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 微博正文
    @IBOutlet weak var contentLabel: UILabel!
    
    var status: Status? {
        
        didSet {
            
            weak var weakSelf = self
            
            nameLabel.text = status!.user!.name
            
            timeLabel.text = status!.created_at
            
            sourceLabel.text = status!.source
            
            contentLabel.text = status!.text
            
            // 头像
            if let iconURL = status!.user!.profile_image_url {
                
                netManager.requestImage(iconURL, { (result, error) -> () in
                    
                    if let image = result as? UIImage {
                        
                        weakSelf?.iconImage.image = image
                    }
                })
            }
            
            // 认证图标
            vipImage.image = status!.user!.verifiedImage
            
            // 会员图标
            memberImage.image = status!.user!.mbImage
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文换行宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 30
        
    }

    let netManager = NetworkManager.sharedManager

}
