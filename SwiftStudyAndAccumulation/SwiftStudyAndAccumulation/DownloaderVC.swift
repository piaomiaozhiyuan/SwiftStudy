//
//  DownloaderVC.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2018/5/22.
//  Copyright © 2018年 mapbar. All rights reserved.
//

import UIKit

class DownloaderVC: UIViewController {
    
    /**flg*/
    /// 允许蜂窝网络的标识
    var allowsCellularAccess: Bool = false
    
    var downloadTask: URLSessionDownloadTask!
    var resumeData: Data?
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0
//        progressView.progressTintColor
        progressView.backgroundColor = UIColor.lightGray
        return progressView
    }()
    
    var downloadSession1: URLSession?
    
    var downloadSession: URLSession {
        if downloadSession1 != nil {
            return downloadSession1!
        } else {
            return createSession()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "运用URLSession下载数据"
        self.view.backgroundColor = UIColor.white
        
        
        
        
        let librarydir: String = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        print("librarydir = \(librarydir)")
        
        var validHeight: CGFloat = self.view.bounds.size.height - 88 - 100
        if #available(iOS 11.0, *) {
            validHeight = validHeight - self.view.safeAreaInsets.bottom
        }
        
        var newlineIndex: Int? = nil
        var needNewline: Bool = false
        let viewWidth: Int = Int(self.view.bounds.size.width)
        let interval: Int = 10
        let buttonWidth: Int = (viewWidth - 3 * interval) / 2
        var buttonTitles: [String] = ["开始下载", "暂停下载", "挂起", "恢复", "取消", "序列化resumeData", "不允许蜂窝下载", "当前任务列表", "session置nil"]
        
        for index in 0 ..< 13 {
            let btn = UIButton(type: .custom)
            if !needNewline {
                needNewline = CGFloat(index * 60) + 44 > validHeight
                newlineIndex = index
            }
            let columns = needNewline ? 1 : 0
            let row: Int = (needNewline && newlineIndex != nil && newlineIndex! != 0) ? index % newlineIndex! : index
                
            btn.frame = CGRect(x: interval + columns * (interval + buttonWidth) ,
                               y: 88 + row * 60,
                               width: buttonWidth, height: 44)
            btn.backgroundColor = UIColor.purple
            if index >= buttonTitles.count {
                btn.setTitle("\(index)", for: .normal)
            } else {
                btn.setTitle("\(buttonTitles[index])", for: .normal)
            }
            
            btn.tag = index + 1000
            btn.addTarget(self, action: #selector(ArrayStudyVC.actionHandle(_:)), for: .touchUpInside)
            self.view.addSubview(btn)
        }
        
        progressView.frame = CGRect(x: 10.0, y: 88.0 + validHeight + 10.0, width: self.view.frame.size.width - 20.0, height: 5.0)
        self.view.addSubview(progressView)
    }
    
    func createSession() -> URLSession {
        let config: URLSessionConfiguration = URLSessionConfiguration.background(withIdentifier: Bundle.main.bundleIdentifier ?? "com.SwiftStudy" + "downloadSession" )
        //        let config: URLSessionConfiguration = URLSessionConfiguration.default
        //        config.timeoutIntervalForResource = 3
        // 因为tcp的数据是分段获取的，这个timeoutIntervalForRequest可以理解是两段数据之间的间隔
        config.timeoutIntervalForRequest = 3
        config.allowsCellularAccess = false
        
        let queue = OperationQueue()
        queue.name = "shujuxiazai"
        queue.maxConcurrentOperationCount = 1
        
        let downloadSession = URLSession(configuration: config, delegate: self, delegateQueue: queue)
        self.downloadSession1 = downloadSession
        return downloadSession
    }
    
    deinit {
        print("对象被销毁了\(#function)")
    }
    
    // MARK: - Action
    
    @objc func actionHandle(_ sender: UIButton) {
        print("\(sender.titleLabel?.text ?? "")按钮被点击")
        let tag = sender.tag - 1000
        if tag == 0 {
            excuteDownload()
        } else if tag == 1 {
            pauseDownload()
        } else if tag == 2 {
            suspend()
        } else if tag == 3 {
            resume()
        } else if tag == 4 {
            cancel()
        } else if tag == 5 {
            serializationResumeData()
        } else if tag == 6 {
            sender.isSelected = !sender.isSelected
            sender.backgroundColor = !sender.isSelected ? UIColor.purple : UIColor.green
            let title: String = !sender.isSelected ? "不允许蜂窝下载" : "允许蜂窝下载"
            sender.setTitle("\(title)", for: .normal)
            switchEnableCellular(sender.isSelected)
        } else if tag == 7 {
            readDownloadTask()
        } else if tag == 8 {
            downloadSession.finishTasksAndInvalidate()
        }
    }

}

extension DownloaderVC {
    func excuteDownload() {
        
//        let url: URL? = URL(string: "http://127.0.0.1/dataStore/shipin.mp4")
        let url: URL? = URL(string: "http://sw.bos.baidu.com/sw-search-sp/software/50045684f7da6/QQ_mac_5.4.1.dmg")
        
        if let url = url {
            var request = URLRequest(url: url)
            
//            request.httpMethod = "HEAD"
//            let task = session.dataTask(with: request)
            
            let task = downloadSession.downloadTask(with: request)
            task.resume()
            downloadTask = task
        }
    }
    
    func pauseDownload() {
        if let downloadTask = downloadTask,
            (downloadTask.state == .running || downloadTask.state == .suspended) {
            downloadTask.cancel { (resumedata) in }
        }
    }
    
    func suspend() {
        assert(downloadTask.state == .running, "state = \(downloadTask.state) -- \(downloadTask)")
        if let downloadTask = downloadTask,
        (downloadTask.state == .running) {
            downloadTask.suspend()
        }
    }
    
    func resume() {
        /**
         两种情况
         1、数据已经取消，但有resumeData的情况，后续还需要查看.tmp文件是否存在
         2、挂起的任务
         */
        
        if downloadTask != nil {
            if let resumeData = resumeData, !resumeData.isEmpty {
//            let data: Data = Data()
                let resumeTask = downloadSession.downloadTask(withResumeData: resumeData)
                downloadTask = resumeTask
                if downloadTask.state == .suspended {
                    downloadTask.resume()
                }
                
                self.resumeData = nil
            } else if downloadTask.state == .suspended {
                
                if downloadTask.state == .suspended {
                    downloadTask.resume()
                }
            }
        } else {
            excuteDownload()
        }
    }
    
    /// 取消
    func cancel() {
        if let downloadTask = downloadTask,
            (downloadTask.state == .running || downloadTask.state == .suspended) {
            downloadTask.cancel()
        }
    }
    
    /// 序列化数据
    func serializationResumeData() {
        if let resumeData = resumeData {
            _ = isResumeDataFileHaveExist(resumeData)
        }
    }
    
    /// 切换允许蜂窝网络的处理
    ///
    /// - Parameter isSelected: 是否允许蜂窝网络
    func switchEnableCellular(_ isSelected: Bool) {
        self.downloadSession.configuration.allowsCellularAccess = isSelected
        print("\n允许蜂窝下载的情况 == \(self.downloadSession.configuration.allowsCellularAccess ? "已经允许" : "不允许")")
        self.downloadTask.cancel(){[weak self] resumeData in
            print("\n\n\n\n111111111111111\n")
            if let strongSelf = self {
                strongSelf.allowsCellularAccess = true
            }
        }
    }
    
    func readDownloadTask() {
        self.downloadSession.getTasksWithCompletionHandler {(dataTasks, uploadTasks, downloadTasks) in

            downloadTasks.forEach(){ (_downloadTask) in
                print("\n----------\n state = \(_downloadTask.state.rawValue) \ndownloadTask = \(_downloadTask)")
            }
        }
    }
    
    
    /// 检查缓存文件是否还存在
    ///
    /// - Parameter data: data
    /// - Returns: 缓存文件是否还存在。 true：存在；false：不存在
    fileprivate func isResumeDataFileHaveExist(_ data: Data) -> Bool {
        
        var resumeDictionaryObject: AnyObject?
        do { // 序列化。
            resumeDictionaryObject = try PropertyListSerialization.propertyList(from: data, options:[], format: nil) as AnyObject?
        } catch {
            
            return false
        }
        
        guard resumeDictionaryObject != nil && resumeDictionaryObject! is NSDictionary else {
            
            return false
        }
        
        if let resumeDictionary: NSDictionary = resumeDictionaryObject as? NSDictionary {
            NSLog("%@", "缓存文件的字典是：\(resumeDictionary)")
            
            if let currentRequestData = resumeDictionary["NSURLSessionResumeCurrentRequest"] as? Data {
                
                if let currentRequest = NSKeyedUnarchiver.unarchiveObject(with: currentRequestData) {
                    
                    NSLog("%@", "NSURLSessionResumeCurrentRequest = \(currentRequest)")
                }
            }
            
            if let originalRequestData = resumeDictionary["NSURLSessionResumeOriginalRequest"] as? Data {
                
                if let originalRequest = NSKeyedUnarchiver.unarchiveObject(with: originalRequestData) {
                    
                    NSLog("%@", "NSURLSessionResumeOriginalRequest = \(originalRequest)")
                }
            }
            
            // 检查tmp文件是否存在
            if let localFilePath = self.getURLSessionResumePath(withResumeDictionary: resumeDictionary) {
                
                return FileManager.default.fileExists(atPath: localFilePath)
            } else {
                
                return false
            }
        } else {
            return false
        }
    }

    /// 获取resumeDictionary中tmp文件的地址
    ///
    /// - Parameter resumeDictionary: 缓存数据字典
    /// - Returns: resumeDictionary中tmp文件的地址
    func getURLSessionResumePath(withResumeDictionary resumeDictionary: NSDictionary) -> String? {
        
        var localFilePathString: String? = nil
        
        if let localFilePath = resumeDictionary.object(forKey: "NSURLSessionResumeInfoLocalPath") as? String {
            // 8.0 的使用NSURLSessionResumeInfoLocalPath
            localFilePathString = localFilePath
        } else {
            //
            if let resumeInfoTempFileName = resumeDictionary.object(forKey: "NSURLSessionResumeInfoTempFileName") as? String {
                
                /// 获得tmp沙盒的路径
                let tmpFile = NSTemporaryDirectory() as NSString
                /// 获取文本文件路径
                let tempFileName = tmpFile.appendingPathComponent(resumeInfoTempFileName)
                
                localFilePathString = tempFileName
            }
        }
        return localFilePathString
    }

    
}


extension DownloaderVC: URLSessionDownloadDelegate {
    /**URLSessionDelegate began*/
    // Tells the URL session that the session has been invalidated.
    /**
     If you invalidate a session by calling its finishTasksAndInvalidate() method, the session waits until after the final task in the session finishes or fails before calling this delegate method. If you call the invalidateAndCancel() method, the session calls this delegate method immediately.
     如果通过调用其方法使会话失效，则会话将一直等待，直到会话中的最终任务完成或失败，然后再调用此委托方法。如果您调用该方法，会话将立即调用该委托方法。[finishTasksAndInvalidate] [invalidateAndCancel]
     */
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("\n\(#function) --- \(#line)")
    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        print("\n\(#function) --- \(#line)")
    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("\n\(#function) --- \(#line)")
    }
    
    /**URLSessionDelegate end*/
    
    /**URLSessionTaskDelegate began*/
//    @available(iOS 11.0, *)
//    /*optional public*/ func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void) {
//        print("\n\(#function) --- \(#line)")
//        print("taskresponse = \(String(describing: task.response))")
//        completionHandler(.continueLoading, request)
//    }
//
//
//    @available(iOS 11.0, *)
//    /*optional public*/ func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
//        print("\n\(#function) --- \(#line)")
//    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
        print("\n\(#function) --- \(#line)")
    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        print("\n\(#function) --- \(#line)")
    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
        print("\n\(#function) --- \(#line)")
    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("\n\(#function) --- \(#line)")
    }
    
    
//    @available(iOS 10.0, *)
//    /*optional public*/ func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
//        print("\n\(#function) --- \(#line)")
//        print("线程 == \(Thread.current)")
//    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("\n\(#function) --- \(#line)")
        print("线程 == \(Thread.current)")
        print("\n\n\n\n222222\n")
        
//        session.finishTasksAndInvalidate()
        
        if let error = error as NSError? {
            // 考虑失败的逻辑
            print("error == \(error) --- code = \(error.code) --- domin = \(error.domain)")
            
            /**
             一、NSURLErrorDomain 和url有关的错误
             1、resume的时候，resumedata有问题的情况    -3003
             2、调用取消的情况      -999
             3、请求超时的情况      -1001
             */
            
            if error.userInfo.keys.contains(NSURLSessionDownloadTaskResumeData) {
                self.resumeData  = error.userInfo[NSURLSessionDownloadTaskResumeData] as? Data
                if allowsCellularAccess {
                    resume()
                    allowsCellularAccess = false
                }
            }
        } else {
            print("下载成功")
        }
    }
    
    /**URLSessionTaskDelegate end*/
    
//    /**URLSessionDataDelegate began*/
//
//    @available(iOS 7.0, *)
//    /*optional public*/ func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
//        print("\n\(#function) --- \(#line)")
//    }
//
//
//    @available(iOS 7.0, *)
//    /*optional public*/ func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
//        print("\n\(#function) --- \(#line)")
//    }
//
//
//    @available(iOS 9.0, *)
//    /*optional public*/ func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
//        print("\n\(#function) --- \(#line)")
//    }
//
//
//    @available(iOS 7.0, *)
//    /*optional public*/ func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        print("\n\(#function) --- \(#line)")
//    }
//
//
//    @available(iOS 7.0, *)
//    /*optional public*/ func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
//        print("\n\(#function) --- \(#line)")
//    }
    /**URLSessionDataDelegate end*/
    
    @available(iOS 7.0, *)
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("\n\(#function) --- \(#line)")
        print("线程 == \(Thread.current)")
        NSLog("保存的路径 == \(location)")
    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("\n\(#function) --- \(#line)")
        print("线程 == \(Thread.current)")
        let progress: Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("progress =  \(progress)")
        DispatchQueue.main.async {
            self.progressView.progress = progress
        }
    }
    
    
    @available(iOS 7.0, *)
    /*optional public*/ func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("\n\(#function) --- \(#line)")
        print("线程 == \(Thread.current)")
    }
}

//extension URLSession {
//    static let ex: URLSession = {
//
//    }()
//}

