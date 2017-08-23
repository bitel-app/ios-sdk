//
//  OVCTableViewCell.swift
//  Pods
//
//  Created by mohsen shakiba on 3/16/1396 AP.
//
//

import UIKit

class OVCTableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
