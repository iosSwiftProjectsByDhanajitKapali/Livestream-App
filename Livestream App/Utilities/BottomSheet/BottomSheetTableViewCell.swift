//
//  BottomSheetTableViewCell.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 27/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

class BottomSheetTableViewCell: UITableViewCell {

    @IBOutlet var bottomSheetTabelViewCellimageView: UIImageView!
    @IBOutlet var bottomSheetTabelViewCellTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
