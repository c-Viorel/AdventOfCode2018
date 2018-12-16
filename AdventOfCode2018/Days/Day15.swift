//
//  Day15.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 15/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day15 {
    
    let inputFileName:String = "15"
    
    func showSolutions() {
        let str = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputFileName):")
        var beings: [Being] = []
        
        let dataIn = str.split(separator: "\n").enumerated().map { y, line in
            line.enumerated().compactMap { x, space -> Space? in
                if let race = Being.Race(rawValue: space) {
                    beings.append(Being(race: race, at: Point(x: x, y: y), attack: 3))
                }
                return Space(rawValue: space)
            }
        }
        
        for power in 3...200 {
            let newBeings = beings.map({ Being(race: $0.race, at: $0.coord, attack: $0.race == .goblin ? 3 : power) })
            print("Power: \(power)")
            if aAndB(dataIn, beings: newBeings, printFields: false) {
                break
            }
        }

        
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    struct Point: Hashable, Comparable {
        var x: Int
        var y: Int
        
        static func +(lhs: Point, rhs: Point) -> Point {
            return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
        }
        
        static func +=(lhs: inout Point, rhs: Point) {
            lhs = lhs + rhs
        }
        
        static func <(lhs: Point, rhs: Point) -> Bool {
            return lhs.y != rhs.y ? lhs.y < rhs.y : lhs.x < rhs.x
        }
        
        var adjacent: [Point] {
            return [(0, -1), (-1, 0), (1, 0), (0, 1)].map({ Point(x: x + $0.0, y: y + $0.1) })
        }
        
        func range(in field: [[Space]]) -> [Point] {
            return adjacent.filter { field.get($0.y)?.get($0.x) == .open }
        }
        
        func distances(in field: [[Space]]) -> [Point: Int] {
            var queue = adjacent.map { ($0, 1) }
            var out: [Point: Int] = [self: 0]
            while let (next, distance) = queue.first {
                queue.remove(at: 0)
                guard field.get(next.y)?.get(next.x) == .open && out[next] == nil else { continue }
                out[next] = distance
                queue.append(contentsOf: next.adjacent.lazy.map({ ($0, distance + 1) }))
            }
            return out
        }
    }
    
    enum Space: Character {
        case wall = "#", open = ".", elf = "E", goblin = "G"
    }
    
    class Being {
        enum Race: Character {
            case elf = "E", goblin = "G"
        }
        var race: Race
        var coord: Point
        var attackPower  = 3
        var hitpoints    = 200
        
        init(race: Race, at: Point, attack: Int) {
            self.race   = race
            self.coord  = at
            attackPower = attack
        }
        
        func attackables(in field: [[Space]]) -> [Point] {
            return coord.adjacent.filter {
                let space = field.get($0.y)?.get($0.x)
                return race == .elf && space == .goblin || race == .goblin && space == .elf
            }
        }
    }
    
    func fieldString(_ field: [[Space]]) -> String {
        return field.lazy.map({ String($0.lazy.map({ $0.rawValue })) }).joined(separator: "\n")
    }
    
    
    func aAndB(_ input: [[Space]], beings: [Being], printFields: Bool) -> Bool {
        var input = input
        var beings = beings
        
        if printFields { print(fieldString(input)) }
        var rounds = 0
        outerWhile: while true {
            beings.sort(by: { $0.coord < $1.coord })
            var action = false
            defer {
                if printFields {
                    print(fieldString(input))
                    for being in beings where being.hitpoints > 0 {
                        print("\(being.race == .elf ? "   Elf" : "Goblin") at \(being.coord): \(being.hitpoints)")
                    }
                }
            }
            for being in beings where being.hitpoints > 0 {
                input[being.coord.y][being.coord.x] = .open
                let targets = beings.filter({ being.race != $0.race && $0.hitpoints > 0 })
                if targets.isEmpty {
                    break outerWhile
                }
                let inRange = targets.flatMap({ $0.coord.range(in: input) })
                if !inRange.contains(being.coord) {
                    let distances = being.coord.distances(in: input)
                    let inRangeDistances = inRange.compactMap({ spot in distances[spot].map({ (spot, $0) }) })
                    if let nearestDistance = inRangeDistances.min(by: { $0.1 < $1.1 })?.1 {
                        let best = inRangeDistances.filter({ $0.1 == nearestDistance }).min(by: { $0.0 < $1.0 })!
                        let targetDistances = best.0.distances(in: input)
                        let step = being.coord.adjacent
                            .compactMap({ point in targetDistances[point].flatMap({ $0 < targetDistances[being.coord]! ? point : nil }) })
                            .min()!
                        being.coord = step
                        action = true
                    }
                }
                
                
                input[being.coord.y][being.coord.x] = Space(rawValue: being.race.rawValue)!
                
                let possibleTargets = being.attackables(in: input).lazy.map { point in beings.lazy.filter({ $0.hitpoints > 0 && point == $0.coord }).first! }
                if !possibleTargets.isEmpty {
                    action = true
                    let target = possibleTargets.min(by: { $0.hitpoints < $1.hitpoints })!
                    target.hitpoints -= being.attackPower
                    if target.hitpoints <= 0 {
                        input[target.coord.y][target.coord.x] = .open
                    }
                }
            }
            if !action { break }
            rounds += 1
        }
        let remainingHealth = beings.map({ $0.hitpoints }).filter({ $0 > 0 }).reduce(0, +)
        print("\(rounds) rounds, \(remainingHealth) health, \(rounds * remainingHealth)")
        if beings.lazy.filter({ $0.race == .elf && $0.hitpoints <= 0 }).isEmpty {
            print("No dead elves")
            return true
        }
        return false
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
