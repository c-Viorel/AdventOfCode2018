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
