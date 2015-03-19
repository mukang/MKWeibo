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
    
    /// 配图视图
    @IBOutlet weak var pictureView: UICollectionView!
    
    /// 配图视图宽度
    @IBOutlet weak var pictureViewWidth: NSLayoutConstraint!
    
    /// 配图视图高度
    @IBOutlet weak var pictureViewHeight: NSLayoutConstraint!
    
    /// 配图视图布局
    @IBOutlet weak var pictureViewLayout: UICollectionViewFlowLayout!
    
    /// 微博数据
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
            
            // 配图
            let pSize = calcPictureViewSize()
            
            pictureViewHeight.constant = pSize.viewSize.height
            
            pictureViewWidth.constant = pSize.viewSize.width
            
            pictureViewLayout.itemSize = pSize.itemSize
        }
    }
    
    ///  计算配图视图大小
    ///
    ///  :returns: 返回图片的大小，和整个视图的大小
    func calcPictureViewSize() -> (itemSize: CGSize, viewSize: CGSize) {
        
        let s: CGFloat = 90
        
        var itemSize = CGSizeMake(s, s)
        
        var viewSize = CGSizeZero
        
        // 配图图片个数
        let count = status!.pic_urls!.count ?? 0
        
        // 如果没有图像
        if count == 0 {
            
            return (itemSize, viewSize)
        }
        
        // 如果有一张，按图像的大小显示
        if count == 1 {
            
            // 拿到被缓存的图像
            let path = netManager.fullImageCachePath(status!.pic_urls![0].thumbnail_pic!)
            
            // 实例化图像，图像有可能实例化失败
            if let image = UIImage(contentsOfFile: path) {
                
                return (image.size, image.size)
                
            } else {
                
                return (itemSize, viewSize)
            }
        }
        
        // 4张图片
        let margin: CGFloat = 10
        
        if count == 4 {
            
            viewSize = CGSizeMake(s * 2 + margin, s * 2 + margin)
            
        } else { // 其他张数
            
            let row = (count - 1) / 3
            
            viewSize = CGSizeMake(s * 3 + margin * 2, (s + margin) * CGFloat(row) + s)
        }
        
        return (itemSize, viewSize)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文换行宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 30
        
    }

    let netManager = NetworkManager.sharedManager

}
