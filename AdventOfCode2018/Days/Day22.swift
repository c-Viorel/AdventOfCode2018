//
//  Day22.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 22/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day22 {
    
    let inputFileName:String = "22"
    
    func showSolutions() {
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputFileName):")
        
//        aAndB(depth: 510, target: Point22(x: 10, y: 10))
        aAndB(depth: 11739, target: Point22(x: 718, y: 11))
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    func aAndB(depth: Int, target: Point22) {
        var cave = Grid22(repeating: RegionType22.narrow, x: 0...(target.x * 2), y: 0...(target.y * 2))
        var erosionLevel = Grid22(repeating: 0, x: cave.xRange, y: cave.yRange)
        for y in erosionLevel.yRange {
            for x in erosionLevel.xRange {
                let point = Point22(x: x, y: y)
                let index: Int
                if point == target {
                    index = 0
                }
                else if y == 0 {
                    index = x * 16807
                }
                else if x == 0 {
                    index = y * 48271
                }
                else {
                    index = erosionLevel[x: x-1, y: y] * erosionLevel[x: x, y: y-1]
                }
                erosionLevel[point] = (index + depth) % 20183
                cave[x: x, y: y] = RegionType22(erosionLevel[point])
            }
        }
            //Print the map 
            //print(cave.convertedDescription({ $0.char }))
        print("\tA: \(cave.storage.lazy.map({ $0.rawValue }).reduce(0, +))")
        let bigNumber = Int.max - Int(Int16.max)
        let grid = Grid22(repeating: bigNumber, x: cave.xRange, y: cave.yRange)
        var fastest = [grid, grid, grid]
        fastest[Tool22.torch.rawValue][x: 0, y: 0] = 0
        var lastFastest = fastest
        repeat {
            lastFastest = fastest
            for distance in 0...(cave.xRange.upperBound + cave.yRange.upperBound) {
                for x in cave.xRange {
                    let y = distance - x
                    guard cave.yRange.contains(y) else { continue }
                    let point = Point22(x: x, y: y)
                    for ind in (0...2) {
                        let tool = Tool22(rawValue: ind)!
                        guard cave[point] != tool.banned else { continue }
                        var best = fastest[ind][point]
                        if y > 0 {
                            best = min(best, fastest[ind][point.above] + 1)
                        }
                        if x > 0 {
                            best = min(best, fastest[ind][point.left] + 1)
                        }
                        if y < cave.yRange.upperBound {
                            best = min(best, fastest[ind][point.below] + 1)
                        }
                        if x < cave.xRange.upperBound {
                            best = min(best, fastest[ind][point.right] + 1)
                        }
                        fastest[ind][point] = best
                    }
                    for ind in (0...2) {
                        let tool = Tool22(rawValue: ind)!
                        guard cave[point] != tool.banned else { continue }
                        var best = fastest[ind][point]
                        for ind2 in 0...2 {
                            best = min(best, fastest[ind2][point] + 7)
                        }
                        fastest[ind][point] = best
                    }
                }
            }
        } while lastFastest != fastest
        print("\tA: \(fastest[Tool22.torch.rawValue][target])")

    }
}
/// I've choose to change the name of some helper classes/structs to eliinate conflicts with
/// previous declations. So, the new format will be (NameOfClass)(DayNumber).
//MARK: - Grid
struct Grid22<Element> {
    var xRange: ClosedRange<Int>
    var yRange: ClosedRange<Int>
    var storage: [Element]
    
    init(repeating element: Element, x: ClosedRange<Int>, y: ClosedRange<Int>) {
        xRange = x
        yRange = y
        storage = [Element](repeating: element, count: xRange.count * yRange.count)
    }
    
    subscript(x x: Int, y y: Int) -> Element {
        get {
            precondition(xRange.contains(x) && yRange.contains(y))
            let xIndex = x - xRange.lowerBound
            let yIndex = y - yRange.lowerBound
            return storage[xRange.count * yIndex + xIndex]
        }
        set {
            precondition(xRange.contains(x) && yRange.contains(y))
            let xIndex = x - xRange.lowerBound
            let yIndex = y - yRange.lowerBound
            storage[xRange.count * yIndex + xIndex] = newValue
        }
    }
    
    subscript(point: Point22) -> Element {
        get {
            return self[x: point.x, y: point.y]
        }
        set {
            self[x: point.x, y: point.y] = newValue
        }
    }
    
    func row(at y: Int) -> ArraySlice<Element> {
        precondition(yRange.contains(y))
        let yIndex = y - yRange.lowerBound
        return storage[(yIndex * xRange.count)..<((yIndex + 1) * xRange.count)]
    }
    
    var rows: LazyMapCollection<ClosedRange<Int>, ArraySlice<Element>> {
        return yRange.lazy.map { self.row(at: $0) }
    }
    
    func convertedDescription(_ converter: (Element) throws -> Character) rethrows -> String {
        return try rows.map({ try String($0.lazy.map(converter)) }).joined(separator: "\n")
    }
}

extension Grid22: Equatable where Element: Equatable {}
extension Grid22: CustomStringConvertible where Element == Character {
    var description: String {
        return convertedDescription { $0 }
    }
}


//MARK:- Poinr
struct Point22: Hashable, Comparable {
    var x: Int
    var y: Int
    static func +(lhs: Point22, rhs: Point22) -> Point22 {
        return Point22(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func +=(lhs: inout Point22, rhs: Point22) {
        lhs = lhs + rhs
    }
    
    static func <(lhs: Point22, rhs: Point22) -> Bool {
        return lhs.y != rhs.y ? lhs.y < rhs.y : lhs.x < rhs.x
    }
    
    var  left: Point22 { return Point22(x: x - 1, y: y) }
    var right: Point22 { return Point22(x: x + 1, y: y) }
    var above: Point22 { return Point22(x: x, y: y - 1) }
    var below: Point22 { return Point22(x: x, y: y + 1) }
    var adjacent: [Point22] {
        return [above, left, right, below]
    }
}

//MARK: RegionType

enum RegionType22: Int {
    case rocky = 0, wet = 1, narrow = 2
    init(_ int: Int) {
        self.init(rawValue: int % 3)!
    }
    var char: Character {
        switch self {
        case .rocky: return "."
        case .wet: return "="
        case .narrow: return "|"
        }
    }
}
//MARK:- Tool
enum Tool22: Int {
    case neither = 0, torch, climbing
    var banned: RegionType22 {
        switch self {
        case .climbing: return .narrow
        case .torch: return .wet
        case .neither: return .rocky
        }
    }
}
