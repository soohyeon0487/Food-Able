//
//  SQLiteManager.swift
//  Food-Able
//
//  Created by Soohyeon Lee on 2020/12/20.
//

import Foundation
import SwiftyJSON
import SQLite3

class SQLiteManager {
    
    static let shared = SQLiteManager()
    
    var db: OpaquePointer?
    var path: String = "db.sqlite"
    
    init() {
        self.db = createSQLite()
        
        if !UserDefaults.standard.bool(forKey: "isCreatedTableForUniversities") {
            self.createTableForUniversities()
        }
        if !UserDefaults.standard.bool(forKey: "isCreatedTableForStores") {
            self.createTableForStores()
        }
    }
    
    // DB 연결
    func createSQLite() -> OpaquePointer? {
        
        var db: OpaquePointer? = nil
        
        do {
            let fileURL = try! FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            .appendingPathComponent(self.path)
            
            if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
                print("SQLite Connection OK")
                return db
            }
        }
        
        print("SQLite Error")
        
        return nil
    }
    
    // DB 연결 해제
    func closeSQLite(pointer: OpaquePointer?) {
        if pointer != nil {
            sqlite3_close(pointer!)
        }
        
        print("SQLite Close")
    }
    
    /// UNIVERSITIES
    
    // 대학 목록 테이블 생성
    func createTableForUniversities(){
        
        let query = "CREATE TABLE IF NOT EXISTS 'universities' ('university_id' int(11) NOT NULL, 'university_name' varchar(255) NOT NULL DEFAULT 'none', 'university_address' varchar(255) NOT NULL DEFAULT 'none', 'university_latitude' double NOT NULL DEFAULT '37.553', 'university_longitude' double NOT NULL DEFAULT '126.973', PRIMARY KEY ('university_id'))"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Create Universities Table SuccessFully \(String(describing: db))")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Create Universities Table step fail :  \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n create Universities Table sqlite3_prepare Fail ! :\(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        
        UserDefaults.standard.setValue(true, forKey: "isCreatedTableForUniversities")
    }
    
    // 대학 목록 추가
    func insertUnivData(data: JSON) {
        
        let query = "Insert into universities Values (?, ?, ?, ?, ?)"
        
        var statement : OpaquePointer? = nil
        
        do {
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                //insert는 read와 다르게 컬럼의 순서의 시작을 1 부터 한다.
                //따라서 id가 없기 때문에 2로 시작한다.
                sqlite3_bind_int(statement, 1, data["university_id"].int32Value)
                sqlite3_bind_text(statement, 2, NSString(string: data["university_name"].stringValue).utf8String , -1, nil)
                sqlite3_bind_text(statement, 3, NSString(string: data["university_address"].stringValue).utf8String , -1, nil)
                sqlite3_bind_double(statement, 4, data["university_latitude"].doubleValue)
                sqlite3_bind_double(statement, 5, data["university_longitude"].doubleValue)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Insert data in Universities SuccessFully : \(String(describing: db))")
                }
                else{
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("\n Insert data in Universities sqlite3 step fail! : \(errorMessage)")
                }
            }
            else{
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Insert data in Universities prepare fail! : \(errorMessage)")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    // 대학 목록 조회
    func readUnivData() -> [University] {
        
        var result: [University] = []
        
        let query = "Select * From universities;"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let id: Int = Int(sqlite3_column_int(statement, 0))
                let name: String = String(cString: sqlite3_column_text(statement, 1))
                let address: String = String(cString: sqlite3_column_text(statement, 2))
                let latitude: Double = sqlite3_column_double(statement, 3)
                let longitude: Double = sqlite3_column_double(statement, 4)
                
                result.append(University(id: id, name: name, address: address, location: (latitude, longitude, 0.025)))
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n Read data in Universities prepare fail! : \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        
        return result
    }
    
    /// STORES
    
    // 가게 목록 테이블 생성
    func createTableForStores(){
        
        let query = "CREATE TABLE IF NOT EXISTS 'stores' ('store_id' int(11) NOT NULL, 'store_category' int(11) NOT NULL DEFAULT '0', 'store_name' varchar(255) NOT NULL DEFAULT 'none', 'store_address' varchar(255) NOT NULL DEFAULT 'none', 'store_description' varchar(255) NOT NULL DEFAULT 'none', 'store_phoneNumber' varchar(16) NOT NULL DEFAULT 'none', 'store_imagePath' varchar(100) NOT NULL DEFAULT 'store_image_none', 'store_latitude' float NOT NULL DEFAULT '37.553', 'store_longitude' float NOT NULL DEFAULT '126.973', 'store_likes' int(11) NOT NULL DEFAULT '0', 'store_university_id' int(11) DEFAULT NULL, PRIMARY KEY (`store_id`,`store_university_id`))"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Create Stores Table SuccessFully \(String(describing: db))")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Create Stores Table step fail :  \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n create Stores Table sqlite3_prepare Fail ! :\(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        
        UserDefaults.standard.setValue(true, forKey: "isCreatedTableForStores")
    }
    
    // 가게 목록 추가
    func insertStoreData(data: JSON) {
        
        let query = "Insert into stores Values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        
        var statement : OpaquePointer? = nil
        do {
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                //insert는 read와 다르게 컬럼의 순서의 시작을 1 부터 한다.
                //따라서 id가 없기 때문에 2로 시작한다.
                sqlite3_bind_int(statement, 1, data["store_id"].int32Value)
                sqlite3_bind_int(statement, 2, data["store_category"].int32Value)
                sqlite3_bind_text(statement, 3, NSString(string: data["store_name"].stringValue).utf8String , -1, nil)
                sqlite3_bind_text(statement, 4, NSString(string: data["store_address"].stringValue).utf8String , -1, nil)
                sqlite3_bind_text(statement, 5, NSString(string: data["store_description"].stringValue).utf8String , -1, nil)
                sqlite3_bind_text(statement, 6, NSString(string: data["store_phoneNumber"].stringValue).utf8String , -1, nil)
                sqlite3_bind_text(statement, 7, NSString(string: data["store_imagePath"].stringValue).utf8String , -1, nil)
                sqlite3_bind_double(statement, 8, data["store_latitude"].doubleValue)
                sqlite3_bind_double(statement, 9, data["store_longitude"].doubleValue)
                sqlite3_bind_int(statement, 10, data["store_likes"].int32Value)
                sqlite3_bind_int(statement, 11, data["store_university_id"].int32Value)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Insert data in Stores SuccessFully : \(String(describing: db))")
                }
                else{
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("\n Insert data in Stores sqlite3 step fail! : \(errorMessage)")
                }
            }
            else{
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Insert data in Stores prepare fail! : \(errorMessage)")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    
    // 가게 목록 조회
    func readStoreData() -> [Store] {
        
        var result: [Store] = []
        
        let query = "Select * From stores;"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let id: Int = Int(sqlite3_column_int(statement, 0))
                let category: Int = Int(sqlite3_column_int(statement, 1))
                let name: String = String(cString: sqlite3_column_text(statement, 2))
                let address: String = String(cString: sqlite3_column_text(statement, 3))
                let description: String = String(cString: sqlite3_column_text(statement, 4))
                let phoneNumber: String = String(cString: sqlite3_column_text(statement, 5))
                let imagePath: String = String(cString: sqlite3_column_text(statement, 6))
                let latitude: Double = sqlite3_column_double(statement, 7)
                let longitude: Double = sqlite3_column_double(statement, 8)
                let likes: Int = Int(sqlite3_column_int(statement, 9))
                let univIndex: Int = Int(sqlite3_column_int(statement, 10))
                
                result.append(Store(id: id, category: category, name: name, address: address, description: description, phoneNumber: phoneNumber, imagePath: imagePath, location: (latitude: latitude, longitude: longitude, delta: 0.01), likes: likes, univIndex: univIndex))
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n Read data in Stores prepare fail! : \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        
        return result
    }
    
    
    /// 공통 작업
    
    // 테이블 데이터 삭제
    func cleanTable(tableName: String) {
        
        let query = "Delete From \(tableName);"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Delete data in \(tableName) SuccessFully : \(String(describing: db))")
            }
            else{
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Delete data in \(tableName) prepare fail! : \(errorMessage)")
            }
            
        }
        else{
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n Delete data in \(tableName) prepare fail! : \(errorMessage)")
        }
        sqlite3_finalize(statement)
    }
    
}
