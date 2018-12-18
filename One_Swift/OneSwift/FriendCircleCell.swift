//
//  FriendCircleCell.swift
//  OneSwift
//
//  Created by van on 2018/3/26.
//  Copyright © 2018年 van. All rights reserved.
//

import UIKit

class FriendCircleCell: UITableViewCell {
// MARK: - 属性
    @IBOutlet var headview :UIImageView!
    @IBOutlet var nameLab : UILabel!
    @IBOutlet var contentLab :UILabel!
    @IBOutlet var timeLab :UILabel!
    
    
    
    public func setCellView (dic : Dictionary<String, Any>) {
        nameLab.text = dic["title"] as? String
        contentLab.text = dic["last"] as? String
        timeLab.text = dic[""] as?String
        headview.image = UIImage.init(named: dic["image"] as! String)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
