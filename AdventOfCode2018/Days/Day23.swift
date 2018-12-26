//
//  Day23.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 23/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day23 {
    
    let inputFileName:String = "23"
    
    func showSolutions() {
        let str = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputFileName):")
      //  pos,-21986333,66024452,103106770>, r=50059976

        let bots  = str.split(separator: "\n").compactMap{ (line) -> Nanobot in
            let numbers = line.components(separatedBy: "<")[1].components(separatedBy: ">")[0].components(separatedBy: ",")
            let last = line.components(separatedBy: "r=")[1]
            return Nanobot.init(position: Day23.Point.init(x: Int(numbers[0])!, y: Int(numbers[1])!, z: Int(numbers[2])!), radius: Int(last)!)
        }
        
        a(bots)
        b(bots, searchSize: 32)
        
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    struct  Nanobot {
        var position:Point
        var radius:Int
    }
    
    
    struct Point: Hashable {
        var x: Int
        var y: Int
        var z:Int
        
         func distanceTo(p:Point) -> UInt {
            return (self.x - p.x).magnitude + (self.y - p.y).magnitude + (self.z - p.z).magnitude
        }
    }
    
    func a(_ bots: [Nanobot])  {
        
        let best = bots.sorted { (a, b) -> Bool in
            return a.radius > b.radius
        }.first!

        var count = 0
        bots.forEach { (bot) in
            if best.position.distanceTo(p: bot.position) <= best.radius {
                count += 1
            }
        }
        print( "\tA: \(count)")
    }
    
    func b(_ input: [Nanobot], searchSize:Int) {
        // Will search searchSize^3 points each round
        // Bigger numbers are more likely to find the solution but are slower
        let xRange = input.lazy.map({ $0.position.x }).minmax()!
        let yRange = input.lazy.map({ $0.position.y }).minmax()!
        let zRange = input.lazy.map({ $0.position.z }).minmax()!
        
        let largestRange = max(xRange.count, max(yRange.count, zRange.count))
        let center = Point(x: 0, y: 0, z: 0)
        var best = center
        var bestScore = 0
        
        for stepPower in (0...32).reversed() {
            let step = 1 << stepPower
            let offset = (step * searchSize) / 2
            guard offset < largestRange else { continue }
            // Shift points around slightly to raise chances of finding new minimums
            let negOffset = step / 2 - offset
            let posOffset = step / 2 + offset
            let xSearch = stride(from: best.x + negOffset, to: best.x + posOffset, by: step)
            let ySearch = stride(from: best.y + negOffset, to: best.y + posOffset, by: step)
            let zSearch = stride(from: best.z + negOffset, to: best.z + posOffset, by: step)
            for x in xSearch {
                for y in ySearch {
                    for z in zSearch {
                        let point = Point(x: x, y: y, z: z)
                        let score = input.lazy.filter({ $0.position.distanceTo( p: point) <= $0.radius }).count
                        if score > bestScore {
                            best = point
                            bestScore = score
                        }
                        else if score == bestScore && best.distanceTo( p: center) > point.distanceTo(p: center) {
                            best = point
                        }
                    }
                }
            }
        }
        print("\tB: \(best.distanceTo( p: center))")

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

