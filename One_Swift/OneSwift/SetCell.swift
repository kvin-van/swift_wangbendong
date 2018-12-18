//
//  SetCell.swift
//  OneSwift
//
//  Created by van on 2017/9/20.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit

class SetCell: UITableViewCell {
// MARK: - 属性
    @IBOutlet var nameLab:UILabel!
    @IBOutlet var lastLab:UILabel!
    
    @IBOutlet var headImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func setCellView (dic : Dictionary<String, Any>) {
        nameLab.text = dic["title"] as? String
        lastLab.text = dic["last"] as? String
        headImageView.image = UIImage.init(named: dic["image"] as! String)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
