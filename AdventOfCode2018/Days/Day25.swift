//
//  25.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 25/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day25 {
    
    let inputFileName:String = "25"
    
    func showSolutions() {
        let str = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputFileName):")
        
        let points  = str.split(separator: "\n").compactMap{ (line) -> Point in
            let n = line.split(whereSeparator: { !"0123456789-".contains($0) }).lazy.map { Int($0)! }

            return Point.init(x: n[0], y: n[1], z: n[2], t: n[3])

        }
        
      
            a(points)
            
         if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    struct Point: Hashable {
        var x: Int
        var y: Int
        var z:Int
        var t:Int
        
        func distanceTo(p:Point) -> UInt {
            return (self.x - p.x).magnitude + (self.y - p.y).magnitude + (self.z - p.z).magnitude + (self.t - p.t).magnitude
        }
    }
    
    func a(_ input: [Point])  {
        
        var sampleMap: [Point: [Point]] = [:]
        for first in input {
            for second in input {
                if first.distanceTo(p: second) <= 3 {
                    sampleMap[first, default: []].append(second)
                }
            }
        }
        
        var constellations: [[Point]] = []
        var used: Set<Point> = []
        for point in input {
            if used.contains(point) { continue }
            var working: Set<Point> = [point]
            var new = working
            while !new.isEmpty {
                new = Set(working.lazy.flatMap { sampleMap[$0]! })
                new.subtract(working)
                working.formUnion(new)
            }
            used.formUnion(working)
            constellations.append(Array(working))
        }
        
        print("\tA: \(constellations.count)")

    }
    
    
    
    func getData() -> String {
        var data:String = ""
        let resourceURL = Bundle.main.url(forResource: inputFileName, withExtension: "txt")
        if let url = resourceURL {
            do {
                data = try String(contentsOf: url, encoding: .utf8)
                
            } catch {
                print("Error at reading input file")
            }
        }
        return data
    }
    
    
}
