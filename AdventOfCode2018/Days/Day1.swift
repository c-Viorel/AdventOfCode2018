//
//  Day1.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 01/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation


class Day1 {

    let input:String = "1"

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
    
    
    func a(_ dataIn:[Int]) -> Int {
//        var s = 0
//        for number in dataIn {
//            s += number
//        }
//        return s
        return dataIn.reduce(0, +)
    }
    
    func b(_ dataIn:[Int]) -> Int  {
        var seen:[Int:Bool] = [:]
        var frequency       = 0
        while true {
            for delta in dataIn {
                frequency += delta
                if let s = seen[frequency] , s == true {
                    return frequency
                }
                seen[frequency] = true
            }
        }
    }

    func getData() ->[Int] {
        var numbers:[Int] = []
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        if let url = resourceURL {
            do {
                let inputString = try String(contentsOf: url, encoding: .utf8)
                inputString.split(separator: "\n").forEach { (nString) in
                    if let n = Int(nString) {numbers.append(n)}
                }
            } catch {
                print("Error at reading input file")
            }
        }
        return numbers
    }
    
    
}
