//
//  ViewController.swift
//  SwiftStudyAndAccumulation
//
//  Created by admin on 2017/4/1.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var array: Array<Array<ModuleModel>> = [[]]
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "功能列表"
        self.initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func initData() {
        var arraySection: Array<ModuleModel> = []
        
        // 学习CGImage
        let model: ModuleModel = ModuleModel(vc: CGImageStudyViewController(), title: "CGImageStudyViewController", description: "CGImageStudyViewController功能描述")
            
        arraySection.append(model)
        
        array.append(arraySection)
    }

    // MARK: - tableViewDelegate tableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID: String = "ViewControllerCell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = array[indexPath.section][indexPath.row].title
        cell?.detailTextLabel?.text = array[indexPath.section][indexPath.row].description
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        excutePushVC(WithVC: array[indexPath.section][indexPath.row].vc)
    }
    
    // MARK: - 执行页面跳转
    func excutePushVC(WithVC VC: UIViewController?) {
        guard let vc = VC else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


/// 模块模型
struct ModuleModel {
    let vc: UIViewController?
    let title: String?
    let description: String?
}


