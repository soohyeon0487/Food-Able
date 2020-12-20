//
//  DataModel.swift
//  Food-Able
//
//  Created by 이수현 on 2020/11/10.
//

import MapKit
import Foundation

import SwiftyJSON
import Alamofire

class University : Identifiable {
    let id: Int
    let name: [String] // [ kor, eng, etc ... ]
    let address: [String] // [ kor, eng, etc ... ]
    let region: MKCoordinateRegion
    
    init(id: Int, name: String, address: String, location: (latitude: Double, longitude: Double, delta: Float)) {
        self.id = id
        self.name = name.split(separator: ";").map { String($0) }
        self.address = address.split(separator: ";").map { String($0) }
        self.region = MKCoordinateRegion(center:
                                            CLLocationCoordinate2D(
                                                latitude: CLLocationDegrees(location.latitude),
                                                longitude: CLLocationDegrees(location.longitude)
                                            ),
                                         span: MKCoordinateSpan(
                                            latitudeDelta: CLLocationDegrees(location.delta),
                                            longitudeDelta: CLLocationDegrees(location.delta)
                                         )
        )
    }
    
}

class UnivList: ObservableObject {
    
    let sqlite = SQLiteManager.shared
    
    @Published var selectedUnivIndex: Int
    @Published var isComplete: Bool
    @Published var list: [University] = []
    
    init() {
        self.selectedUnivIndex = 0
        self.isComplete = false
        self.loadDataForServer()
    }
    
    func loadDataForServer() {
        
        // 대학 목록 데이터 버전 체크
        AF.request("http://192.168.0.109:3000/universities/version", method: .get).responseData { res in
            switch res.result {
            case .success:
                if let data = res.data {
                    
                    let newVersion = JSON(data).array![0]["VERSION"].stringValue
                    
                    if newVersion == UserDefaults.standard.string(forKey: "univDataVersion") {
                        
                        self.list = self.sqlite.readUnivData()
                        
                        print("loadDataForServer() : SQLite.readUnivData() - Universities")
                        
                        self.isComplete = true
                        
                    } else {
                        
                        // 대학 목록 조회
                        AF.request("http://192.168.0.109:3000/universities", method: .get).responseData { res in
                            switch res.result {
                            case .success:
                                if let data = res.data {
                                    let data = JSON(data).array!
                                    
                                    data.forEach {
                                        
                                        self.sqlite.insertUnivData(data: $0)
                                        
                                        let id: Int = $0["university_id"].intValue
                                        let name: String = $0["university_name"].stringValue
                                        let address: String = $0["university_address"].stringValue
                                        let latitude: Double = $0["university_latitude"].doubleValue
                                        let longitude: Double = $0["university_longitude"].doubleValue

                                        self.list.append(University(id: id, name: name, address: address, location: (latitude, longitude, 0.025)))
                                    }
                                    
                                    UserDefaults.standard.setValue(newVersion, forKey: "univDataVersion")
                                    
                                    print("loadDataForServer() : SQLite.insertUnivData() - Universities")
                                    
                                    self.isComplete = true
                                }
                            case .failure(_):
                                print("requset error")
                            }
                        }
                    }
                }
            case .failure(_):
                print("requset error")
            }
        }
    }
    
    func getSelectedUnivRegion() -> MKCoordinateRegion {
        return self.list[self.selectedUnivIndex].region
    }
}

class Store : Identifiable {
    var id: Int
    var category: Int
    var name: [String] // [ kor, eng, etc ... ]
    var address: [String] // [ kor, eng, etc ... ]
    var description: [String]
    var phoneNumber: String
    var imagePath: String
    var region: MKCoordinateRegion
    var likes: Int
    var univIndex: Int
    
    init(id: Int, category: Int, name: String, address: String, description: String, phoneNumber: String, imagePath: String, location: (latitude: Double, longitude: Double, delta: Float), likes: Int, univIndex: Int) {
        self.id = id
        self.category = category
        self.name = name.split(separator: ";").map { String($0) }
        self.address = address.split(separator: ";").map { String($0) }
        self.description = description.split(separator: ";").map { String($0) }
        self.phoneNumber = phoneNumber
        self.imagePath = imagePath
        self.region = MKCoordinateRegion(center:
                                            CLLocationCoordinate2D(
                                                latitude: CLLocationDegrees(location.latitude),
                                                longitude: CLLocationDegrees(location.longitude)
                                            ),
                                         span: MKCoordinateSpan(
                                            latitudeDelta: CLLocationDegrees(location.delta),
                                            longitudeDelta: CLLocationDegrees(location.delta)
                                         )
        )
        self.likes = likes
        self.univIndex = univIndex
    }
}

class StoreList: ObservableObject {
    
    let sqlite = SQLiteManager.shared
    
    @Published var selectedFoodCategoryIndex: Int
    @Published var isComplete: Bool
    @Published var list: [Store] = []
    @Published var currentList: [Store] = []
    
    init() {
        self.selectedFoodCategoryIndex = 0
        self.isComplete = false
        loadDataForServer()
    }
    
    func loadDataForServer() {
        
        // 가게 목록 데이터 버전 체크
        AF.request("http://192.168.0.109:3000/stores/version", method: .get).responseData { res in
            switch res.result {
            case .success:
                if let data = res.data {
                    
                    let newVersion = JSON(data).array![0]["VERSION"].stringValue
                    
                    if newVersion == UserDefaults.standard.string(forKey: "storeDataVersion") {
                        
                        self.list = self.sqlite.readStoreData()
                        self.currentList = self.list
                        
                        print("loadDataForServer() : SQLite.readStoreData() - Stores")
                        print("self.list", self.list)
                        print("self.currentList", self.currentList)
                        
                        self.isComplete = true
                        
                    } else {
                        
                        // 가게 목록 조회
                        AF.request("http://192.168.0.109:3000/stores", method: .get).responseData { res in
                            switch res.result {
                            case .success:
                                if let data = res.data {
                                    let data = JSON(data).array!
                                    
                                    data.forEach {
                                        
                                        self.sqlite.insertStoreData(data: $0)
                                        
                                        let id: Int = $0["store_id"].intValue
                                        let category: Int = $0["store_category"].intValue
                                        let name: String = $0["store_name"].stringValue
                                        let address: String = $0["store_address"].stringValue
                                        let description: String = $0["store_description"].stringValue
                                        let phoneNumber: String = $0["store_phoneNumber"].stringValue
                                        let imagePath: String = $0["store_imagePath"].stringValue
                                        let latitude: Double = $0["store_latitude"].doubleValue
                                        let longitude: Double = $0["store_longitude"].doubleValue
                                        let likes: Int = $0["store_likes"].intValue
                                        let univIndex: Int = $0["store_university_id"].intValue

                                        self.list.append(Store(id: id, category: category, name: name, address: address, description: description, phoneNumber: phoneNumber, imagePath: imagePath, location: (latitude: latitude, longitude: longitude, delta: 0.01), likes: likes, univIndex: univIndex))
                                        
                                    }
                                    
                                    self.currentList = self.list
                                    
                                    UserDefaults.standard.setValue(newVersion, forKey: "storeDataVersion")
                                    
                                    print("loadDataForServer() : SQLite.insertStoreData() - Stores")
                                    
                                    self.isComplete = true
                                }
                            case .failure(_):
                                print("requset error")
                            }
                        }
                    }
                }
            case .failure(_):
                print("requset error")
            }
        }
    }
    
    
    func filteringStoreList(univ: Int) {
        switch (univ: univ, category: self.selectedFoodCategoryIndex) {
        case (0, 0):
            self.currentList = self.list
        case (0, _):
            self.currentList = self.list.filter {
                $0.category == self.selectedFoodCategoryIndex
            }
        case (_, 0):
            self.currentList = self.list.filter {
                $0.univIndex == univ
            }
        default:
            self.currentList = self.list.filter {
                ($0.univIndex == univ) && ($0.category == self.selectedFoodCategoryIndex)
            }
        }
    }
}

class Food : Identifiable {
    var storeID: Int
    var foodID: Int
    var name: [String] // [ kor, eng, etc ... ]
    var description: [String]
    var price: Int
    var allergyCheckList: [Bool]
    var isHALAL: Bool
    var likes: Int
    
    init(storeID: Int, foodID: Int, name: String, description: String, price: Int, allergyCheckList: String, isHALAL: Bool, likes: Int) {
        self.storeID = storeID
        self.foodID = foodID
        self.name = name.split(separator: ";").map { String($0) }
        self.description = description.split(separator: ";").map { String($0) }
        self.price = price
        self.allergyCheckList = allergyCheckList.split(separator: ";").map { Int($0) == 1 ? true : false }
        self.isHALAL = isHALAL
        self.likes = likes
    }
}
