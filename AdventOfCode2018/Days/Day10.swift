//
//  Day10.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 10/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day10 {
    
    let input:String = "10"
    
    func showSolutions() {
        let dataFromFile = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
        print("\tB: \(aAndB(dataFromFile) )")
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    struct Point: Hashable {
    var x: Int
    var y: Int
    }
    

    func aAndB(_ input: [(position: Point, velocity: Point)])  -> Int {
        var points = input
        var output = input
        var count = 10000
        for index in points.indices {
            points[index].position.x += points[index].velocity.x * count
            points[index].position.y += points[index].velocity.y * count
        }
        while true {
            for index in points.indices {
                points[index].position.x += points[index].velocity.x
                points[index].position.y += points[index].velocity.y
            }
            let range = points.lazy.map({ $0.position.y }).minmax()!
            let prevRange = output.lazy.map({ $0.position.y }).minmax()!
            if range.count > prevRange.count {
                break
            }
            output = points
            count += 1
        }
        let xrange = points.lazy.map({ $0.position.x }).minmax()!
        let yrange = points.lazy.map({ $0.position.y }).minmax()!
        
        var arr = [[Bool]](repeating: [Bool](repeating: false, count: xrange.count), count: yrange.count)
        for point in output {
            arr[point.position.y - yrange.lowerBound][point.position.x - xrange.lowerBound] = true
        }
        for row in arr {
            print(String(row.lazy.map({ $0 ? "#" : " " })))
        }
        return count
    }

    
    

    func getData() -> [(Point,Point)]  {
        var numbers:[(Point,Point)]  = []
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        if let url = resourceURL {
            do {
                let inputString = try String(contentsOf: url, encoding: .utf8)
                for line in inputString.split(separator: "\n") {
                    let nums = line.split(whereSeparator: { !"-0123456789".contains($0) }).map({ Int($0)! })
                    numbers.append((Point(x: nums[0], y: nums[1]), Point(x: nums[2], y: nums[3])))
                }
                
            } catch {
            }
        }
        return numbers
    }
    
    
}

extension Sequence where Element: Strideable {
    func minmax() -> ClosedRange<Element>? {
        var iter = makeIterator()
        guard var min = iter.next() else { return nil }
        var max = min
        while let next = iter.next() {
            min = Swift.min(min, next)
            max = Swift.max(max, next)
        }
        return min...max
    }
}

