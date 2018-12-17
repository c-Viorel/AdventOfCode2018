//
//  Day17.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 17/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//
//str.components(separatedBy: "\n\n").compactMap { block -> (from: [Int], instr: Instruction, to: [Int])? in
//    let numbers = block.split(whereSeparator: { !"0123456789".contains($0) }).lazy.map { Int($0)! }
//    guard numbers.count == 12 else { return nil }
//    let from = Array(numbers[0..<4])
//    let instr = Instruction(numbers[4..<8])!
//    let to = Array(numbers[8..<12])
//    return (from, instr, to)
//}

import Foundation
class Day17 {
    
    let inputFileName:String = "17"
    
    func showSolutions() {
        let str = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputFileName):")
        
        
        let input = str.components(separatedBy: "\n").compactMap { block -> LinesInfo? in
            let numbers = block.split(whereSeparator: { !"0123456789".contains($0) }).lazy.map { Int($0)!}
            guard  numbers.count == 3 else {
                return nil
            }
            if block.first! == "y" {
                return LinesInfo.init(x: ClosedRange.init(uncheckedBounds: (lower: numbers[1], upper: numbers[2])), y: ClosedRange.init(uncheckedBounds: (lower: numbers[0], upper: numbers[0])))

            } else {
                return LinesInfo.init(x: ClosedRange.init(uncheckedBounds: (lower: numbers[0], upper: numbers[0])), y: ClosedRange.init(uncheckedBounds: (lower: numbers[1], upper: numbers[2])))
            }
        }
   
        //
        aAndB(input)
//        b(input)
        
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
  
    enum Area {
        case sand, clay, water, flowingWater
        var char: Character {
            switch self {
            case .sand: return "."
            case .clay: return "#"
            case .water: return "~"
            case .flowingWater: return "|"
            }
        }
        
        var isWater: Bool {
            return self == .water || self == .flowingWater
        }
    }
    
    func aAndB(_ input: [LinesInfo]) {
        let minX = input.lazy.map { $0.x.lowerBound }.min()! - 1
        let maxX = input.lazy.map { $0.x.upperBound }.max()! + 1
        let minY = input.lazy.map { $0.y.lowerBound }.min()!
        let maxY = input.lazy.map { $0.y.upperBound }.max()!
        let xbounds = minX...maxX
        let ybounds = minY...maxY
        
        var map = [[Area]](repeating: [Area](repeating: .sand, count: xbounds.count), count: ybounds.count)
        for item in input {
            for x in item.x {
                for y in item.y {
                    map[y - minY][x - minX] = .clay
                }
            }
        }
        
        func pourDown(x: Int, y: Int) -> Bool {
            var newY = y
            while map[newY-minY][x-minX] != .clay {
                map[newY-minY][x-minX] = .flowingWater
                newY += 1
                if !ybounds.contains(newY) {
                    return true
                }
            }
            repeat {
                newY -= 1
            } while !pourSideways(x: x, y: newY) && newY > y
            return newY != y
        }
        
        func pourSideways(x: Int, y: Int) -> Bool {
            var lX = x
            var rX = x
            var spilled = false
            while map[y-minY][lX-minX] != .clay {
                let below = map[y-minY + 1][lX-minX]
                if below == .sand {
                    spilled = pourDown(x: lX, y: y) || spilled
                    break
                }
                else if below == .flowingWater {
                    spilled = true
                    break
                }
                map[y-minY][lX-minX] = .water
                lX -= 1
            }
            while map[y-minY][rX-minX] != .clay {
                let below = map[y-minY + 1][rX-minX]
                if below == .sand {
                    spilled = pourDown(x: rX, y: y) || spilled
                    break
                }
                else if below == .flowingWater {
                    spilled = true
                    break
                }
                map[y-minY][rX-minX] = .water
                rX += 1
            }
            if spilled {
                for x in lX...rX {
                    if map[y-minY][x-minX] == .water {
                        map[y-minY][x-minX] = .flowingWater
                    }
                }
            }
            return spilled
        }
        _ = pourDown(x: 500, y: minY)
        
        print("\tA: \(map.lazy.flatMap({ $0 }).filter({ $0.isWater }).count)")
        print("\tB: \(map.lazy.flatMap({ $0 }).filter({ $0 == .water }).count)")
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
    

    struct LinesInfo {
        var x:ClosedRange<Int> = ClosedRange.init(uncheckedBounds: (lower: 0, upper: 0))
        var y:ClosedRange<Int> =  ClosedRange.init(uncheckedBounds: (lower: 0, upper: 0))
        
    }
    
}



