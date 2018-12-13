//
//  Day3.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 03/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day3 {
    
    let input:String = "3"
    
    func showSolutions() {
        let dataFromFile = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
      
        print("\tA: \(a(dataFromFile) )")
        print("\tB: \(b(dataFromFile) )")
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    func a(_ dataIn:[fabricDetails]) -> Int {
        var m = Array<Int>(repeating: 0, count: 1000 * 1000)

        for fab in dataIn {
            for i in fab.leftInset...fab.leftInset + fab.width - 1  {
                for j in fab.topInset...fab.topInset + fab.height - 1 {
                    let pos = 1000 * i + j
                    m[pos] += 1
                }
            }
        }

       return  m.reduce(into: 0) { (val, current) in
            val += current > 1 ? 1 : 0
        }
    }
    
    func b(_ dataIn:[fabricDetails]) -> String  {
        var m = Array<Int>(repeating: 0, count: 1000 * 1000)
        for fab in dataIn {
            for i in fab.leftInset...fab.leftInset + fab.width - 1  {
                for j in fab.topInset...fab.topInset + fab.height - 1 {
                    let pos = 1000 * i + j
                    m[pos] += 1
                    
                }
                
            }
            
        }
        
        
        for fab in dataIn {
            var  find = true
            for i in fab.leftInset...fab.leftInset + fab.width - 1  {
                for j in fab.topInset...fab.topInset + fab.height - 1 {
                    let pos = 1000 * i + j
                    if m[pos] != 1 {
                        find = false
                    }
                }
            }
            if find {
                return fab.id
            }
        }

        return "Not"
    }
    
    func getData() ->[fabricDetails] {
        var final:[fabricDetails] = []
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        
        if let url = resourceURL {
            do {
                let inputString = try String(contentsOf: url, encoding: .utf8).split(separator: "\n")
                var aux = fabricDetails.init()
                for row in inputString  {
                    let stringArray = row.components(separatedBy: CharacterSet.decimalDigits.inverted)
                    aux.id = stringArray[1]
                    aux.leftInset  = Int(stringArray[4]) ?? 0
                    aux.topInset   = Int(stringArray[5]) ?? 0
                    aux.width      = Int(stringArray[7]) ?? 0
                    aux.height     = Int(stringArray[8]) ?? 0
                    final.append(aux)
                }
                
                
            } catch {
                print("Error at reading input file")
            }
        }
        return final
    }
    

    /////////////////////
    struct fabricDetails {
        var id:String      = ""
        var leftInset:Int  = 0
        var topInset:Int   = 0
        var width:Int      = 0
        var height:Int     = 0
    }
    
}
