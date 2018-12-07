//
//  Day6.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 06/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day6 {
    
    let input:String = "6"
    
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
    
    
    func a(_ dataIn: [(x:Int, y:Int)] ) -> Int {
        var areas = [(count: Int, infinite: Bool)](repeating: (0, false), count: dataIn.count)
        let minX  = dataIn.map({ $0.x }).min()!
        let maxX  = dataIn.map({ $0.x }).max()!
        let minY  = dataIn.map({ $0.y }).min()!
        let maxY  = dataIn.map({ $0.y }).max()!
        for x in minX...maxX {
            for y in minY...maxY {
                let distances      = dataIn.lazy.map({ ($0 - x).magnitude + ($1 - y).magnitude }).enumerated()
                let minDistance    = distances.min(by: { $0.element < $1.element })!.element
                let distancesAtMin = distances.filter({ $0.element == minDistance })
                if distancesAtMin.count > 1 { continue }
                if x == minX || x == maxX || y == minY || y == maxY {
                    areas[distancesAtMin[0].offset].infinite = true
                }
                areas[distancesAtMin[0].offset].count += 1
            }
        }
        
        var values:[Int] = []
        for i in areas {
            if !i.infinite {
                values.append(i.count)
            }
        }
        values.sort()
        
        return values.max() ?? -1
    }
    
    func b(_ dataIn: [(x:Int, y:Int)] ) -> Int  {
        var count = 0
        let minX  = dataIn.map({ $0.x }).min()!
        let maxX  = dataIn.map({ $0.x }).max()!
        let minY  = dataIn.map({ $0.y }).min()!
        let maxY  = dataIn.map({ $0.y }).max()!
        for x in minX...maxX {
            for y in minY...maxY {
                let distances = dataIn.lazy.map({ ($0 - x).magnitude + ($1 - y).magnitude })
                if distances.reduce(0, +) < 10000 {
                    count += 1
                }
            }
        }
        return count
    }
    
    func getData() ->[(x:Int, y:Int)] {
        var numbers: [(x:Int, y:Int)]  = []
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        if let url = resourceURL {
            do {
                let inputString = try String(contentsOf: url, encoding: .utf8).split(separator: "\n")
                for item in inputString {
                    let v = item.replacingOccurrences(of: " ", with: "").split(separator: ",")
                    let a = Int(String(v[0])) ?? 0
                    let b = Int(String(v[1])) ?? 0
                    numbers.append((x: a, y: b))
                    
                }
                
                
            } catch {
                print("Error at reading input file")
            }
        }
        return numbers
    }
    
    
}
