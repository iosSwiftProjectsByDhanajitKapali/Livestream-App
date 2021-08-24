//
//  LiveCommentsTableViewCell.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 19/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

class LiveCommentsTableViewCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userNameTextLabel: UILabel!
    @IBOutlet var userCommentTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension LiveCommentsTableViewCell{
    func populateCell(fromModel : LiveCommentModel){
        self.profileImage.setImage(string: fromModel.userName,
                                   color: .darkGray, circular: false, stroke: false, textAttributes: nil)
        //self.profileImage.contentMode = .scaleAspectFit
        self.userNameTextLabel.text = fromModel.userName
        self.userCommentTextLabel.text = fromModel.userComment
    }
}

private extension LiveCommentsTableViewCell {
    func initialSetup(){
        self.profileImage.makeImageCircular()
    }
}
