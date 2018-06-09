//
//  ViewController.swift
//  SwiftStudyAndAccumulation
//
//  Created by admin on 2017/4/1.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit
import AVFoundation

class Student: NSObject {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var array: [[ModuleModel]] = [[]]
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "功能列表"
        
        self.initData()
        
        print("\(NSHomeDirectory())")
        
        let assumedString: String! = "An implicitly unwrapped optionalstring."
        let a = assumedString
        print("\(assumedString)")
        
        self.setupNotifications()
//        tableView.bounces = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            print("safeArea = \(self.view.safeAreaInsets)")
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.0, *) {
            print("KeyWindowsafeArea = \(String(describing: UIApplication.shared.keyWindow?.safeAreaInsets))")
        } else {
            // Fallback on earlier versions
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func initData() {
        var arraySection: [ModuleModel] = []
        
        /**这么写有个问题，viewcontroller返回的时候，不会被销毁；但是这里为了写的方便暂时这么操作。*/
        // 学习CGImage
        let model1: ModuleModel = ModuleModel(vc: CGImageStudyViewController(), title: "CGImageStudyViewController", description: "CGImageStudyViewController功能描述")
        // 验证扩展
        let model2: ModuleModel = ModuleModel(vc: TestExtensionsVC(), title: "TestExtensionsVC", description: "验证扩展功能")
        
        // 线程学习
        let threadStudyVC: ThreadStudyVC = ThreadStudyVC()
        let model3: ModuleModel = ModuleModel(vc: threadStudyVC, title: "ThreadStudyVC", description: "线程学习")
        
        // 滚动列表扩展（既可翻页，也可以任意值偏移）
        
        // 归解档
        let keyedArchiverVC: KeyedArchiverVC = KeyedArchiverVC()
        let model4: ModuleModel = ModuleModel(vc: keyedArchiverVC, title: "KeyedArchiverVC", description: "持久化学习")
        
        // 数组操作
        let arrayStudyVC: ArrayStudyVC = ArrayStudyVC()
        let model5: ModuleModel = ModuleModel(vc: arrayStudyVC, title: "ArrayStudyVC", description: "数组学习")
        
        // 下载器实现
        let downloaderVC: DownloaderTestVC = DownloaderTestVC()
        let model6: ModuleModel = ModuleModel(vc: downloaderVC, title: "DownloaderTestVC", description: "运用URLSession下载数据踩坑之路")
        
        // 指针学习
        let unsafePointerViewController: UnsafePointerViewController = UnsafePointerViewController()
        let model7: ModuleModel = ModuleModel(vc: unsafePointerViewController, title: "UnsafePointerViewController", description: "Swift中的指针问题")
        
        arraySection = [model1, model2, model3, model4, model5, model6, model7]
        
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
        print("excute")
        
        
        
        if self.parent != vc { // 防止连点造成的崩溃
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func setupNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleSecondaryAudio),
                                               name: .AVAudioSessionSilenceSecondaryAudioHint,
                                               object: AVAudioSession.sharedInstance())
    }
    
    @objc func handleSecondaryAudio(notification: Notification) {
        // Determine hint type
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
            let type = AVAudioSessionSilenceSecondaryAudioHintType(rawValue: typeValue) else {
                return
        }
        
        if type == .begin {
            // Other app audio started playing - mute secondary audio
            print("Other app audio started playing - mute secondary audio")
        } else {
            // Other app audio stopped playing - restart secondary audio
            print("Other app audio stopped playing - restart secondary audio")
        }
    }
    
}


/// 模块模型
struct ModuleModel {
    let vc: UIViewController?
    let title: String?
    let description: String?
}



