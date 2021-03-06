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
        if tableViewData.count > 0{
            liveCommentsTableView.isHidden = false
        }
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

//MARK: - TableView Delegate methods
extension LiveStreamVC : UITableViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if tableViewData.count <= 5 {
            goToLatestCommentButton.isHidden = true
        }else{
            self.goToLatestCommentButton.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.goToLatestCommentButton.isHidden = true
        }
    }
}

