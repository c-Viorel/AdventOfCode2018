//
//  Day11.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 10/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day11 {
    
    let inputDay:String = "11"
    
    func showSolutions(input:Int = 1308) {
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputDay):")
        aAndB(input)
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    func aAndB(_ input: Int) {
        func powerLevel(x: Int, y: Int) -> Int {
            let rackID        = x + 10
            let powerLevel    = rackID * y
            let newPL         = powerLevel + input
            let newPL2        = newPL * rackID
            let hundredsDigit = (newPL2 / 100) % 10
            return hundredsDigit - 5
        }
        
        var arr = [[Int]](repeating: [], count: 300)
       
        for index in arr.indices {
            if index == 0 {
                arr[index] = (0..<300).map { powerLevel(x: $0, y: 0) }
            }
            else {
                arr[index] = arr[index - 1].enumerated().map({ $0.element + powerLevel(x: $0.offset, y: index) })
            }
        }
        
        func checkSize(size: Int) -> LazyCollection<FlattenCollection<LazyMapCollection<ClosedRange<Int>, LazyMapCollection<ClosedRange<Int>, (x:Int, y:Int, size:Int, total:Int)>>>> {
            
            return (0...(300-size)).lazy.flatMap { tlX in
                
                (0...(300-size)).lazy.map { tlY -> (Int, Int, Int, Int) in
                
                    let xrange = (tlX)..<(tlX+size)
                    let total: Int
                    if tlY == 0 {
                        total = arr[size-1][xrange].reduce(0, +)
                    }
                    else {
                        let subtract = arr[tlY-1][xrange].reduce(0, +)
                        total = arr[tlY+size-1][xrange].reduce(0, +) - subtract
                    }
                    return (tlX, tlY, size, total)
                }
            }
        }
        
        
        print("\tA: \(checkSize(size: 3).max(by: { $0.3 < $1.3 })!)")
        // Part B
        let powerLevels = (1...300).lazy.flatMap { checkSize(size: $0) }
       
        let best        = powerLevels.max(by: { $0.3 < $1.3 })!
        print("\tB: \(best)")
    }
    
    
}
