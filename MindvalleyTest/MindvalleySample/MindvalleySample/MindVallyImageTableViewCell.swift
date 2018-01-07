//
//  MindVallyImageTableViewCell.swift
//  MindvalleySample
//
//  Created by Divyam Shukla on 1/7/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

import UIKit

class MindVallyImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var label: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
