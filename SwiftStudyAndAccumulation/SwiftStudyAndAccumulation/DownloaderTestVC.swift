//
//  DownloaderTestVC.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2018/5/25.
//  Copyright © 2018年 mapbar. All rights reserved.
//

import UIKit

class DownloaderTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "过渡视图"
        self.view.backgroundColor = UIColor.white
        
    }

    @IBAction func buttonClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(DownloaderVC(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
