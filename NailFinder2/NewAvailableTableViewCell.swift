//
//  NewAvailableTableViewCell.swift
//  NailFinder2
//
//  Created by An Nguyen on 5/1/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit

class NewAvailableTableViewCell: UITableViewCell {

    @IBOutlet weak var howFarLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
