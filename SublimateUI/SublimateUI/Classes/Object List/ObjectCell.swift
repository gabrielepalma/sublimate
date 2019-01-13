//
//  GenericTableViewCell.swift
//  SublimateClient
//
//  Created by i335287 on 29/12/2018.
//  Copyright © 2018 Gabriele. All rights reserved.
//

import UIKit

class ObjectCell: UITableViewCell {

    @IBOutlet var identifierLabel : UILabel?
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var syncStatusLabel : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UITableViewCell {
    func loadCellFromNib(nibName : String) -> UITableViewCell {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UITableViewCell
    }
}
