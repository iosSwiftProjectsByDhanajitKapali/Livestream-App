//
//  ViewControllerExtensionForUITableView.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 20/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

extension LiveStreamVC{
    func addNewLiveCommentInTableView(comment : LiveCommentModel){
        self.tableViewData.insert(comment, at: 0)
        self.liveCommentsTableView.reloadData()
    }
}

//MARK: - TableView DataSource methods
extension LiveStreamVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = liveCommentsTableView.dequeueReusableCell(withIdentifier: "LiveCommentsTableViewCellID", for: indexPath) as! LiveCommentsTableViewCell
        cell.populateCell(fromModel: tableViewData[indexPath.row])
        cell.contentView.transform = CGAffineTransform (scaleX: -1,y: -1);
        return cell
    }
}
