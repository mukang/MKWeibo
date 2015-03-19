//
//  HomeViewController.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/13.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    // 微博数据
    var statusesData: StatusesData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        
    }

    ///  加载微博数据
    func loadData() {
        
        weak var weakSelf = self
        
        // 添加遮盖
        SVProgressHUD.show()
        
        StatusesData.loadStatusesData { (data, error) -> () in
            
            if error != nil {
                
                SVProgressHUD.showInfoWithStatus("您的网络不给力！")
                
                return
            }
            
            // 让遮盖消失
            SVProgressHUD.dismiss()
            
            if data != nil {
                
                // 刷新表格数据
                weakSelf?.statusesData = data
                
                weakSelf?.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - Table view data source

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusesData?.statuses?.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! StatusCell
        
        let status = statusesData!.statuses![indexPath.row]
        
        cell.status = status
        
        return cell
    }
    
}












