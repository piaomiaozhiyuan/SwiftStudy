//
//  KeyedArchiverVC.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2018/4/25.
//  Copyright © 2018年 mapbar. All rights reserved.
//

import UIKit

/// 模型数组序列化与反序列化
protocol ModelsCodable {
    /// 将遵守Encodable类型的数据json序列化
    static func encodeModelsToJSONArray<T: Codable>(_ items: [T]) -> Data?
    /// 将遵循Decodable模型从json反序列化成模型数组
    static func decodeJsonToModels<T: Codable>() -> ((_ data: Data) -> [T])
}

/// 模型序列化与反序列化
protocol ModelCodable {
    /// 将遵守Encodable类型的数据json序列化
    func encodeModelsToJSONDictionary<T: Codable>(_ item: T) -> Data?
    /// 将遵循Decodable模型从json反序列化成模型
    func decodeJsonToModel<T: Codable>(_ data: Data, _ transform: (_ models: T) -> Void)
}

class KeyedArchiverVC: UIViewController {
    lazy var items: [MBDataStoreMapDataItem] = {
        let items: [MBDataStoreMapDataItem] = [MBDataStoreMapDataItem(withLevel: 4, superId: "cn.base"), MBDataStoreMapDataItem(withLevel: 9, superId: "cn.liaoning")]
        return items
    }()
    
    lazy var item: MBDataStoreMapDataItem = {
        var item: MBDataStoreMapDataItem = MBDataStoreMapDataItem(withLevel: 4, superId: "cn.base")
        return item
    }()
    
    lazy var mbObject: MBDataStoreMapDataItem = {
        var item: MBDataStoreMapDataItem = MBDataStoreMapDataItem(withLevel: 4, superId: "cn.base")
        return item
    }()
    
    var objectData: Data!
    var objectData1: Data!
    
    lazy var name: String = {
        print("我走了")
        return "cat"
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "持久化学习"
        self.view.backgroundColor = UIColor.white
        
        for index in 0 ..< 10 {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 10, y: 60 + index * 50, width: 44, height: 44)
            btn.backgroundColor = UIColor.purple
            btn.setTitle("\(index)", for: .normal)
            btn.tag = index + 1000
            btn.addTarget(self, action: #selector(KeyedArchiverVC.actionHandle(_:)), for: .touchUpInside)
            self.view.addSubview(btn)
        }
    }
    
    @objc func actionHandle(_ sender: UIButton) {
        let tag = sender.tag - 1000
        if tag == 0 {
            if FileManager.default.fileExists(atPath: MBDSFolder.privateDocument) {
                
            } else {
                
                do {
                    
                    try FileManager.default.createDirectory(atPath: MBDSFolder.privateDocument, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    
                }
                
            }
            
        } else if tag == 1 {
            // 实例
            let object = MBObject1(level: 6, superId: "cn.base")
            
            print(object)
            print()
            //JSON化
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                objectData = try encoder.encode(object)
                print(String(data: objectData, encoding: .utf8)!)
                print()
            } catch {
                
            }
            print("name1 = \(self.name)")
            name = "dog"
            
        } else if tag == 2 {
            //反JSON化
            do {
                let newStudent = try JSONDecoder().decode(MBObject1.self, from: objectData)
                print(newStudent)
            } catch {
                
            }
            print("name = \(self.name)")
            
        } else if tag == 3 {
            
            // 实例
            let object = MBDataStoreMapDataItem(withLevel: 6, superId: "cn.base")
            let object1 = MBDataStoreMapDataItem(withLevel: 16, superId: "cn.base.ss")
            let array: [MBDataStoreMapDataItem] = [object, object1]
            
            print(array)
            print()
            //JSON化
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                objectData1 = try encoder.encode(array)
                print(String(data: objectData1, encoding: .utf8)!)
                print()
            } catch {
                
            }
            
        } else if tag == 4 {
            //反JSON化
            do {
                let newStudent = try JSONDecoder().decode([MBDataStoreMapDataItem].self, from: objectData1)
                print(newStudent)
            } catch {
                
            }
            
        } else if tag == 5 {
            // 文件写入
            // 研究一下Data.WritingOptions类型
            do {
                try objectData1!.write(to: URL(fileURLWithPath: MBDSFolder.privateDocument + "/data1.json"),options: Data.WritingOptions.atomic)
            } catch {
                
            }
//            FileManager.default.
            
        } else if tag == 6 {
            
            //方法2
            let data2 = FileManager.default.contents(atPath: MBDSFolder.privateDocument + "/data1.json")
            
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: MBDSFolder.privateDocument + "/data1.json"))
                let newStudent1 = try JSONDecoder().decode([MBDataStoreMapDataItem].self, from: data)
                print(newStudent1)
                
            }catch{
                NSLog("read error")
            }
            
            //反JSON化
            do {
                let newStudent = try JSONDecoder().decode([MBDataStoreMapDataItem].self, from: data2!)
                print(newStudent)
            } catch {
                
            }
        }
    }
}

struct MBObject1: Codable {
    /// 是否增量更新中
    var level: Int = 0
    /// 进度(下载进度)
    var superId: String = "cn"
}

/// 数据商店数据模型
class MBDataStoreMapDataItem: NSObject, Codable {
    /// 闭包：下载进度
    ///
    /// - Parameter identifier: 数据标识
    typealias ProgressClosure = ( _ identifier: String) -> Void
    /// 闭包：数据状态改变
    ///
    /// - Parameter identifier: 数据标识
    typealias StateChangeClosure = (_ identifier: String) -> Void
    
    // MARK: - Propeties
    
    /// 闭包：下载进度更新
    var downloadProgressClosure: ProgressClosure?
    /// 闭包：安装进度更新
    var installProgressClosure: ProgressClosure?
    /// 闭包：数据状态改变
    var stateChangeClosure: StateChangeClosure?
    
    /// 是否增量更新中
    var isIncreamentalUpdate: Bool = false
    /// 进度(下载进度)
    var downloadProgress: Float = 0
    /// 数据状态
    var state: MBMapDataItemState = .none
    
    /// 数据标识
    fileprivate(set) var dataId: String = ""
    /// 数据版本
    fileprivate(set) var versionDescription: String = ""
    //    /// 数据下载相关信息数组
    //    var fileInfo: [MBDataStoreMapDataFileInfo] = []
    /// 数组：子节点数据(城市数据)
    fileprivate(set) var subnote: [MBDataStoreMapDataItem] = []
    
    /// 数据等级：1：省级；2：市级
    fileprivate(set) var level: Int = 0
    /// 当前数据上一等级的标识， 当level == 1 superId == nil 当level == 2 取此值才有意义
    fileprivate(set) var superId: String?
    
    /// 用于展示的数据大小（全部数据的大小）
    private(set) var displaySize: String = ""
    /// 用于展示的数据名称
    private(set) var displayName: String = ""
    /// 用于展示的数据大小（增量更新大小）
    private(set) var displayIncreamentalUpdateSize: String = ""
    
    /// 数据大小：全部数据的大小
    fileprivate var size: Int = 0
    /// 数据大小：增量更新数据大小
    fileprivate var increamentalUpdateSize: Int = 0
    /// 数据名称
    fileprivate var name: String = ""
    
    // MARK: - Initialization
    private override init() {
        super.init()
    }
    
    /// 便利构造器
    ///
    /// - Parameter: item:navicore的数据模型，level：等级（1：省级；2：市级）
    convenience init(withLevel level: Int, superId: String?) {
        self.init()
        self.dataId = "item.itemId"
        self.name = "item.name"
        self.versionDescription = "item.descrip"
        self.level = level
        self.superId = superId
        // TODO: 数据更新的时候需要考虑
        self.state = .downloaded
        //        self.fileInfo =
        self.size = 99
        self.increamentalUpdateSize = 99
        
        /// 用于展示的数据大小（全部数据大小）
        displaySize = "99"
    }
    
    // MARK: -
    
    enum CodingKeys: String, CodingKey {
        case dataId
        case name
        case state
        case versionDescription
        case level
        case subnote
        case size
        case increamentalUpdateSize
        case downloadProgress
        case isIncreamentalUpdate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dataId, forKey: .dataId)
        try container.encode(name, forKey: .name)
        try container.encode(state, forKey: .state)
        try container.encode(versionDescription, forKey: .versionDescription)
        try container.encode(level, forKey: .level)
        try container.encode(subnote, forKey: .subnote)
        try container.encode(size, forKey: .size)
        try container.encode(increamentalUpdateSize, forKey: .increamentalUpdateSize)
        try container.encode(downloadProgress, forKey: .downloadProgress)
        try container.encode(isIncreamentalUpdate, forKey: .isIncreamentalUpdate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        dataId = try container.decode(String.self, forKey: .dataId)
        name = try container.decode(String.self, forKey: .name)
        state = try container.decode(MBMapDataItemState.self, forKey: .state)
        versionDescription = try container.decode(String.self, forKey: .versionDescription)
        level = try container.decode(Int.self, forKey: .level)
        subnote = try container.decode([MBDataStoreMapDataItem].self, forKey: .subnote)
        size = try container.decode(Int.self, forKey: .size)
        increamentalUpdateSize = try container.decode(Int.self, forKey: .increamentalUpdateSize)
        downloadProgress = try container.decode(Float.self, forKey: .downloadProgress)
        isIncreamentalUpdate = try container.decode(Bool.self, forKey: .isIncreamentalUpdate)
    }
}

/// 数据状态
enum MBMapDataItemState: Int, Codable {
    /// 正常状态
    case none = 0
    /// 等待状态
    case waiting
    /// 下载中（这里没有区分下载中，还是更新中），需要判断增量更新请使用isIncreamentalUpdate
    case downloading
    /// 下载完成
    case downloaded
    /// 需要更新
    case needUpdate
    /// 上个版本未下完数据更新
    case needUpdateNotFinish
    /// 更新/下载暂停（更新与下载暂停不区分）
    case pause
    /// 非人为暂停
    case notArtificialPause
    /// 下载失败
    case downloadError
    /// 安装中
    case installing
    /// 安装完成
    case installed
    /// 安装失败
    case installError
}

typealias MBDSFolder = String
extension MBDSFolder {
    
    static let librarydir: String = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    /// 数据商店：文件路径Library/ Private Documents（用户保存数据商店的一些数据）
    static let privateDocument: String = librarydir + "/Private Documents"
    static let userConfig: String = privateDocument + "/data/userdata/datastore/006000000/config"
    /// 数据商店：search_index.json的路径
    static let searchIndexJson: String = userConfig + "/search_index.json"
    /// dataStore.json的路径
    static let dataStoreJson: String = userConfig + "/datastore.json"
    /// local_data.json的路径
    static let localDataJson: String = userConfig + "/local_data.json"
    /// data_update_task的路径
    static let dataUpdateTaskJson: String = userConfig + "/data_update_task.json"
}
