//
//  ThreadStudyVC.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/5/24.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit

class ThreadStudyVC: BaseViewController {
    
    var myQueue:DispatchQueue?
    
    deinit {
        NSLog("ThreadStudyVC deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "线程学习"
        self.view.backgroundColor = UIColor.white
        
        for index in 0 ..< 10 {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 10, y: 60 + index * 50, width: 150, height: 44)
            btn.backgroundColor = UIColor.purple
            btn.setTitle("\(index)", for: .normal)
            btn.tag = index + 1000
            btn.addTarget(self, action: #selector(KeyedArchiverVC.actionHandle(_:)), for: .touchUpInside)
            self.view.addSubview(btn)
            
            let tag = btn.tag - 1000
            if tag == 0 {
                btn.setTitle("group-notify", for: .normal)
            } else if tag == 1 {
                btn.setTitle("group-wait", for: .normal)
            } else if tag == 2 {
                btn.setTitle("group enter leave", for: .normal)
            }
        }
        myQueue = DispatchQueue(label: "第二条线程", attributes: .concurrent)
        
    }
    
    // MARK: - Actions
    
    @objc func actionHandle(_ sender: UIButton) {
        let tag = sender.tag - 1000
        if tag == 0 {
            groupNotify()
        } else if tag == 1 {
            groupWait()
        } else if tag == 2 {
            groupEnterLeave()
        } else if tag == 3 {
            
            let group = DispatchGroup()
            group.enter()
            test(group)
            group.notify(queue: .main) {
                print("所有的任务执行完了")
            }
            
        } else if tag == 4 {
            
        } else if tag == 5 {
            
        } else if tag == 6 {
            
        }
    }
    
    func test(_ group: DispatchGroup) {
        sleep(3)
        group.leave()
    }
    
    // MARK: - Private
    private func groupNotify() {
        let group = DispatchGroup()
        myQueue?.async(group: group, qos: .default, flags: [], execute: {
            for _ in 0...10 {
                
                print("耗时任务一")
                
            }
        })
        myQueue?.async(group: group, qos: .default, flags: [], execute: {
            for _ in 0...10 {
                
                print("耗时任务二")
            }
        })
        //执行完上面的两个耗时操作, 回到myQueue队列中执行下一步的任务
        group.notify(queue: myQueue!) {
            print("回到该队列中执行")
        }
        
    }
    
    private func groupWait() {
        let group = DispatchGroup()
        myQueue?.async(group: group, qos: .default, flags: [], execute: {
            for _ in 0...10 {
                
                print("耗时任务一")
            }
        })
        myQueue?.async(group: group, qos: .default, flags: [], execute: {
            for _ in 0...10 {
                
                print("耗时任务二")
                sleep(UInt32(1))
            }
        })
        //等待上面任务执行，会阻塞当前线程，超时就执行下面的，上面的继续执行。可以无限等待 .distantFuture
        let result = group.wait(timeout: .now() + 2.0)
        switch result {
        case .success:
            print("不超时, 上面的两个任务都执行完")
        case .timedOut:
            print("超时了, 上面的任务还没执行完执行这了")
        }
        
        print("接下来的操作")
    }
    
    private func groupEnterLeave() {
        let group = DispatchGroup()
        group.enter()//把该任务添加到组队列中执行
        myQueue?.async(group: group, qos: .default, flags: [], execute: {
            for _ in 0...10 {
                
                print("耗时任务一")
                sleep(1)
            }
            
            group.leave()//执行完之后从组队列中移除
        })
        group.enter()//把该任务添加到组队列中执行
        myQueue?.async(group: group, qos: .default, flags: [], execute: {
            for _ in 0...10 {
                
                print("耗时任务二")
            }
            sleep(2)
            group.leave()//执行完之后从组队列中移除
        })
        
        //当上面所有的任务执行完之后通知
        group.notify(queue: .main) {
            print("所有的任务执行完了")
        }
        
        print("接下来的操作")
    }
}
