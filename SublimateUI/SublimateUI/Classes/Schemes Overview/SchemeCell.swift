//
//  PlainTableViewCell.swift
//  SublimateClient
//
//  Created by i335287 on 29/12/2018.
//  Copyright © 2018 Gabriele. All rights reserved.
//

import UIKit

class SchemeCell: UITableViewCell {

    @IBOutlet var descriptionLabel : UILabel?
    @IBOutlet var accessLabel : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
