//
//  Battery_MonitorApp.swift
//  Shared
//
//  Created by John Henderson on 1/20/22.
//

import SwiftUI
import SQLite3

class Voltage{
    var id: Int
    var volt01: Double
    var volt02: Double
    var volt03: Double
    var volt04: Double
    var volt05: Double
    var volt06: Double
    var volt07: Double
    var volt08: Double
    var volt09: Double
    var volt10: Double
    var volt11: Double
    var volt12: Double
    var volt13: Double
    var volt14: Double
    var volt15: Double
    var volt16: Double
    
    init(id: Int, volt01: Double, volt02: Double, volt03: Double, volt04: Double, volt05: Double, volt06: Double, volt07: Double, volt08: Double, volt09: Double, volt10: Double, volt11: Double, volt12: Double, volt13: Double, volt14: Double, volt15: Double, volt16: Double) {
        self.id = id
        self.volt01 = volt01
        self.volt02 = volt02
        self.volt03 = volt03
        self.volt04 = volt04
        self.volt05 = volt05
        self.volt06 = volt06
        self.volt07 = volt07
        self.volt08 = volt08
        self.volt09 = volt09
        self.volt10 = volt10
        self.volt11 = volt11
        self.volt12 = volt12
        self.volt13 = volt13
        self.volt14 = volt14
        self.volt15 = volt15
        self.volt16 = volt16
    }
}

class DBHelper {
    var db: OpaquePointer?
    var path : String = "myDB.sqlite"
    var batList = Voltage(id: 1, volt01: 0, volt02: 0, volt03: 0, volt04: 0, volt05: 0, volt06: 0, volt07: 0, volt08: 0, volt09: 0, volt10: 0, volt11: 0, volt12: 0, volt13: 0, volt14: 0, volt15: 0, volt16: 0)
    
    init() {
        self.db = createDB()
        self.createTable()
        //self.enterValues(volt01: 0, volt02: 0, volt03: 0, volt04: 0, volt05: 0, volt06: 0, volt07: 0, volt08: 0, volt09: 0, volt10: 0, volt11: 0, volt12: 0, volt13: 0, volt14: 0, volt15: 0, volt16: 0)
        //self.lastValues()
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is an error creating DB")
            return nil
        }
        else {
            print("Database has been created in path \(path)")
            return db
        }
    }
    
    func createTable() {
        let query = "CREATE TABLE IF NOT EXISTS Voltages(id INTEGER PRIMARY KEY AUTOINCREMENT, voltage01 REAL, voltage02 REAL, voltage03 REAL, voltage04 REAL, voltage05 REAL, voltage06 REAL, voltage07 REAL, voltage08 REAL, voltage09 REAL, voltage10 REAL, voltage11 REAL, voltage12 REAL, voltage13 REAL, voltage14 REAL, voltage15 REAL, voltage16 REAL);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            }
            else {
                print("Table creation failed")
            }
        }
        else{
            print("Preparation Failed")
        }
    }
    
    func enterValues(volt01 : Double, volt02 : Double, volt03 : Double, volt04 : Double, volt05 : Double, volt06 : Double, volt07: Double, volt08 : Double, volt09 : Double, volt10 : Double, volt11 : Double, volt12 : Double, volt13 : Double, volt14 : Double, volt15 : Double, volt16 : Double) {
        var statement: OpaquePointer?
        
        let insertQuery = "INSERT INTO VOLTAGES (voltage01, voltage02, voltage03, voltage04, voltage05, voltage06, voltage07, voltage08, voltage09, voltage10, voltage11, voltage12, voltage13, voltage14, voltage15, voltage16) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) != SQLITE_OK {
            print("Error binding query")
            return
        }
        
        
        
        //REMEMBER TO MAKE THESE INTO INPUTS FOR THIS FUNCTION
        /*var volt01 = 1.8
        var volt02 = 1.1
        var volt03 = 1.1
        var volt04 = 1.1
        var volt05 = 1.1
        var volt06 = 1.1
        var volt07 = 1.1
        var volt08 = 1.1
        var volt09 = 1.1
        var volt10 = 1.1
        var volt11 = 1.1
        var volt12 = 1.1
        var volt13 = 1.1
        var volt14 = 1.1
        var volt15 = 1.1
        var volt16 = 1.1*/
        //REMEMBER TO MAKE THESE INTO INPUTS FOR THIS FUNCTION
        
        if sqlite3_bind_double(statement, 1, volt01) != SQLITE_OK {
            print("Error binding volt01")
        }
        
        if sqlite3_bind_double(statement, 2, volt02) != SQLITE_OK {
            print("Error binding volt02")
        }
        
        if sqlite3_bind_double(statement, 3, volt03) != SQLITE_OK {
            print("Error binding volt03")
        }
        
        if sqlite3_bind_double(statement, 4, volt04) != SQLITE_OK {
            print("Error binding volt04")
        }
        
        if sqlite3_bind_double(statement, 5, volt05) != SQLITE_OK {
            print("Error binding volt05")
        }
        
        if sqlite3_bind_double(statement, 6, volt06) != SQLITE_OK {
            print("Error binding volt06")
        }
        
        if sqlite3_bind_double(statement, 7, volt07) != SQLITE_OK {
            print("Error binding volt07")
        }
        
        if sqlite3_bind_double(statement, 8, volt08) != SQLITE_OK {
            print("Error binding volt08")
        }
        
        if sqlite3_bind_double(statement, 9, volt09) != SQLITE_OK {
            print("Error binding volt09")
        }
        
        if sqlite3_bind_double(statement, 10, volt10) != SQLITE_OK {
            print("Error binding volt10")
        }
        
        if sqlite3_bind_double(statement, 11, volt11) != SQLITE_OK {
            print("Error binding volt11")
        }
        
        if sqlite3_bind_double(statement, 12, volt12) != SQLITE_OK {
            print("Error binding volt12")
        }
        
        if sqlite3_bind_double(statement, 13, volt13) != SQLITE_OK {
            print("Error binding volt13")
        }
        
        if sqlite3_bind_double(statement, 14, volt14) != SQLITE_OK {
            print("Error binding volt14")
        }
        
        if sqlite3_bind_double(statement, 15, volt15) != SQLITE_OK {
            print("Error binding volt15")
        }
        
        if sqlite3_bind_double(statement, 16, volt16) != SQLITE_OK {
            print("Error binding volt16")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure inserting voltages: \(errmsg)")
            return
        }
        
        print("voltages saved successfully")
    }
    
    func lastValues() -> Voltage {
        let queryString = "SELECT * FROM Voltages ORDER BY id DESC LIMIT 1"
        var statement : OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure inserting voltages: \(errmsg)")
            //return
        }
        while(sqlite3_step(statement) == SQLITE_ROW) {
            let id = sqlite3_column_int(statement, 0)
            let lastvoltage01 = sqlite3_column_double(statement, 1)
            let lastvoltage02 = sqlite3_column_double(statement, 2)
            let lastvoltage03 = sqlite3_column_double(statement, 3)
            let lastvoltage04 = sqlite3_column_double(statement, 4)
            let lastvoltage05 = sqlite3_column_double(statement, 5)
            let lastvoltage06 = sqlite3_column_double(statement, 6)
            let lastvoltage07 = sqlite3_column_double(statement, 7)
            let lastvoltage08 = sqlite3_column_double(statement, 8)
            let lastvoltage09 = sqlite3_column_double(statement, 9)
            let lastvoltage10 = sqlite3_column_double(statement, 10)
            let lastvoltage11 = sqlite3_column_double(statement, 11)
            let lastvoltage12 = sqlite3_column_double(statement, 12)
            let lastvoltage13 = sqlite3_column_double(statement, 13)
            let lastvoltage14 = sqlite3_column_double(statement, 14)
            let lastvoltage15 = sqlite3_column_double(statement, 15)
            let lastvoltage16 = sqlite3_column_double(statement, 16)
            
            
            batList.volt01 = Double(lastvoltage01)
            batList.volt02 = Double(lastvoltage02)
            batList.volt03 = Double(lastvoltage03)
            batList.volt04 = Double(lastvoltage04)
            batList.volt05 = Double(lastvoltage05)
            batList.volt06 = Double(lastvoltage06)
            batList.volt07 = Double(lastvoltage07)
            batList.volt08 = Double(lastvoltage08)
            batList.volt09 = Double(lastvoltage09)
            batList.volt10 = Double(lastvoltage10)
            batList.volt11 = Double(lastvoltage11)
            batList.volt12 = Double(lastvoltage12)
            batList.volt13 = Double(lastvoltage13)
            batList.volt14 = Double(lastvoltage14)
            batList.volt15 = Double(lastvoltage15)
            batList.volt16 = Double(lastvoltage16)
            
            print(id, lastvoltage01, lastvoltage02, lastvoltage03, lastvoltage04, lastvoltage05, lastvoltage06, lastvoltage07, lastvoltage08, lastvoltage09, lastvoltage10, lastvoltage11, lastvoltage12, lastvoltage13, lastvoltage14, lastvoltage15, lastvoltage16)
        }
        return batList
    }
    func history(column: Int) -> [Double] {
        var i = 0
        
        let queryString = "SELECT  * FROM Voltages ORDER BY id DESC LIMIT 12000"
        
        var statement : OpaquePointer?
        var historyArr = [Double]()
        historyArr.removeAll()
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure inserting voltages: \(errmsg)")
            //return
        }
        while(sqlite3_step(statement) == SQLITE_ROW) {
            let id = sqlite3_column_int(statement, 0)
            let lastvoltage01 = sqlite3_column_double(statement, 1)
            let lastvoltage02 = sqlite3_column_double(statement, 2)
            let lastvoltage03 = sqlite3_column_double(statement, 3)
            let lastvoltage04 = sqlite3_column_double(statement, 4)
            let lastvoltage05 = sqlite3_column_double(statement, 5)
            let lastvoltage06 = sqlite3_column_double(statement, 6)
            let lastvoltage07 = sqlite3_column_double(statement, 7)
            let lastvoltage08 = sqlite3_column_double(statement, 8)
            let lastvoltage09 = sqlite3_column_double(statement, 9)
            let lastvoltage10 = sqlite3_column_double(statement, 10)
            let lastvoltage11 = sqlite3_column_double(statement, 11)
            let lastvoltage12 = sqlite3_column_double(statement, 12)
            let lastvoltage13 = sqlite3_column_double(statement, 13)
            let lastvoltage14 = sqlite3_column_double(statement, 14)
            let lastvoltage15 = sqlite3_column_double(statement, 15)
            let lastvoltage16 = sqlite3_column_double(statement, 16)
            
            if column == 1 {
                historyArr.append(lastvoltage01)
            }
            
            if column == 2 {
                historyArr.append(lastvoltage02)
            }
            
            if column == 3 {
                historyArr.append(lastvoltage03)
            }
            
            if column == 4 {
                historyArr.append(lastvoltage04)
            }
            
            if column == 5 {
                historyArr.append(lastvoltage05)
            }
            
            if column == 6 {
                historyArr.append(lastvoltage06)
            }
            
            if column == 7 {
                historyArr.append(lastvoltage07)
            }
            
            if column == 8 {
                historyArr.append(lastvoltage08)
            }
            
            if column == 9 {
                historyArr.append(lastvoltage09)
            }
            
            if column == 10 {
                historyArr.append(lastvoltage10)
            }
            
            if column == 11 {
                historyArr.append(lastvoltage11)
            }
            
            if column == 12 {
                historyArr.append(lastvoltage12)
            }
            
            if column == 13 {
                historyArr.append(lastvoltage13)
            }
            
            if column == 14 {
                historyArr.append(lastvoltage14)
            }
            
            if column == 15 {
                historyArr.append(lastvoltage15)
            }
            
            if column == 16 {
                historyArr.append(lastvoltage16)
            }
            
            i = i + 1
            
            print(id, lastvoltage01, lastvoltage02, lastvoltage03, lastvoltage04, lastvoltage05, lastvoltage06, lastvoltage07, lastvoltage08, lastvoltage09, lastvoltage10, lastvoltage11, lastvoltage12, lastvoltage13, lastvoltage14, lastvoltage15, lastvoltage16)
            
        }
        
        return historyArr
    }
}

@main
struct Battery_MonitorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
