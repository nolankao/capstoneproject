//
//  ContentView.swift
//  Shared
//
//  Created by John Henderson on 1/20/22.
//

import SwiftUI
import SwiftUICharts
import SQLite3
import UIKit

var Charttype : Int = 0

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.75))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct RedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0.75, green: 0, blue: 0))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}



func insert1000() {
    let db = DBHelper()
    var i = 0
    while i < 1000
    {
        db.enterValues(volt01: 1.0, volt02: 1.4, volt03: 1.8, volt04: 0.4, volt05: 0.8, volt06: 0.12, volt07: 0.89, volt08: 1.42, volt09: 0.98, volt10: 0.54, volt11: 1.53, volt12: 1.34, volt13: 1.34, volt14: 1.22, volt15: 0.88, volt16: 0.22)
        i = i + 1
    }
}

struct ContentView: View {
    var body: some View {
        let db = DBHelper()
        
        TabView {
            VStack( spacing: 100){
                Button ("  Connect to Device   ") {
                    print("Device is connected")
                }
                .buttonStyle(BlueButton())
                
                Button ("Disconnect from Device") {
                    
                }
                .buttonStyle(RedButton())
            }
            HStack ( spacing: 100) {
                
                Button("Insert Values") {
                    insert1000()
                }
                .buttonStyle(BlueButton())
                
                let currVolt: Voltage = db.lastValues()
                
                let batin01 = currVolt.volt01
                let batin02 = currVolt.volt02
                let batin03 = currVolt.volt03
                let batin04 = currVolt.volt04
                let batin05 = currVolt.volt05
                let batin06 = currVolt.volt06
                let batin07 = currVolt.volt07
                let batin08 = currVolt.volt08
                let batin09 = currVolt.volt09
                let batin10 = currVolt.volt10
                let batin11 = currVolt.volt11
                let batin12 = currVolt.volt12
                let batin13 = currVolt.volt13
                let batin14 = currVolt.volt14
                let batin15 = currVolt.volt15
                let batin16 = currVolt.volt16
                
                BarChartView(data: ChartData(values: [
                ("Battery 01", batin01),
                ("Battery 02", batin02),
                ("Battery 03", batin03),
                ("Battery 04", batin04),
                ("Battery 05", batin05),
                ("Battery 06", batin06),
                ("Battery 07", batin07),
                ("Battery 08", batin08),
                ("Battery 09", batin09),
                ("Battery 10", batin10),
                ("Battery 11", batin11),
                ("Battery 12", batin12),
                ("Battery 13", batin13),
                ("Battery 14", batin14),
                ("Battery 15", batin15),
                ("Battery 16", batin16),
                ]),
                             title: "Battery Voltages (V)",
                             form: ChartForm.extraLarge)
            }//HStack
            let Array01 : [Double] = db.history(column: 1)
            let Array02 : [Double] = db.history(column: 2)
            let Array03 : [Double] = db.history(column: 3)
            let Array04 : [Double] = db.history(column: 4)
            let Array05 : [Double] = db.history(column: 5)
            let Array06 : [Double] = db.history(column: 6)
            let Array07 : [Double] = db.history(column: 7)
            let Array08 : [Double] = db.history(column: 8)
            let Array09 : [Double] = db.history(column: 9)
            let Array10 : [Double] = db.history(column: 10)
            let Array11 : [Double] = db.history(column: 11)
            let Array12 : [Double] = db.history(column: 12)
            let Array13 : [Double] = db.history(column: 13)
            let Array14 : [Double] = db.history(column: 14)
            let Array15 : [Double] = db.history(column: 15)
            let Array16 : [Double] = db.history(column: 16)
            
            LineChartView(data: Array01, title: "Battery 1 History (1 min)", form: ChartForm.extraLarge)
            LineChartView(data: Array02, title: "Battery 2 History (1 min)", form: ChartForm.extraLarge)
            LineChartView(data: Array03, title: "Battery 3 History (1 min)", form: ChartForm.extraLarge)
            LineChartView(data: Array04, title: "Battery 4 History (1 min)", form: ChartForm.extraLarge)
            LineChartView(data: Array05, title: "Battery 5 History (1 min)", form: ChartForm.extraLarge)
            LineChartView(data: Array06, title: "Battery 6 History (1 min)", form: ChartForm.extraLarge)
            LineChartView(data: Array07, title: "Battery 7 History (1 min)", form: ChartForm.extraLarge)
            
            Group {
                LineChartView(data: Array08, title: "Battery 8 History (1 min)", form: ChartForm.extraLarge)
                LineChartView(data: Array09, title: "Battery 9 History (1 min)", form: ChartForm.extraLarge)
                LineChartView(data: Array10, title: "Battery 10 History (1 min)", form: ChartForm.extraLarge)
                LineChartView(data: Array11, title: "Battery 11 History (1 min)", form: ChartForm.extraLarge)
                LineChartView(data: Array12, title: "Battery 12 History (1 min)", form: ChartForm.extraLarge)
                LineChartView(data: Array13, title: "Battery 13 History (1 min)", form: ChartForm.extraLarge)
                LineChartView(data: Array14, title: "Battery 14 History (1 min)", form: ChartForm.extraLarge)
                LineChartView(data: Array15, title: "Battery 15 History (1 min)", form: ChartForm.extraLarge)
                LineChartView(data: Array16, title: "Battery 16 History (1 min)", form: ChartForm.extraLarge)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
