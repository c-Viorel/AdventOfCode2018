//
//  Day2.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 02/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation


class Day2 {
    
    let input:String = "2"
    
    func showSolutions() {
        let dataFromFile = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
        print("\tA: \(a(dataFromFile) )")
        print("\tB: \(b(dataFromFile).solution )")
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    func a(_ dataIn:[String]) -> Int {
    
        var twos = 0
        var tres = 0
        var check:[Character:Int] = [:]
        for vector in dataIn {
            check.removeAll()
            for ch in vector {
                if let val = check[ch] {
                    check[ch] = val + 1
                } else {
                    check[ch] = 1
                }
            }
            var t2 = 0
            var t3 = 0
            for (_,val) in check {
                if val == 2 {
                    t2 += 1
                }
                if val == 3 {
                    t3 += 1
                }
            }
            
            
            if t2 == t3 && t2 != 0 {
                twos += 1
                tres += 1
            } else {
                if t2 == 0 && t3 > 0 {
                    tres += 1
                } else if t3 == 0 && t2 > 0 {
                    twos += 1
                }
                
            }
            
        }
        return tres * twos
    }
    
    func b(_ dataIn:[String]) -> (item1:String, item2:String, solution:String)  {
        //        var diff:[Character] = []
        var difLocal = 0
        
        var sol:(item1:String, item2:String, solution:String) = ("","","")
        
        for item in dataIn {
            let secondDates = dataIn.filter { (elem) -> Bool in
                return elem != item
            }
            for second in secondDates {
                difLocal = 0
                var index = 0
                for (c,c1) in zip(item,second) {
                    
                    if c != c1 {
                        difLocal += 1
                    }
                    index += 1
                }
                if difLocal == 1  {
                    sol.item1 = item
                    sol.item2 = second
                    sol.solution = differenceStrings(first: item, second: second)
                }
            }
        }
        return sol
    }
   
    private func differenceStrings(first:String, second:String) -> String{
        var rez = ""
        for (c1,c2) in zip(first,second) {
            if c1 == c2 {
                rez = rez + "\(c1)"
            }
            
        }
        return rez
    }
    
        
        
    
    func getData() ->[String] {
        var dataStrings:[String] = []
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        if let url = resourceURL {
            do {
                let inputString = try String(contentsOf: url, encoding: .utf8)
                inputString.split(separator: "\n").forEach { (nString) in
                    dataStrings.append(String(nString))
                }
            } catch {
                print("Error at reading input file")
            }
        }
        return dataStrings
    }
    
    
}
