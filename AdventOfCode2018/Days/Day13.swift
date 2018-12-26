//
//  Day13.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 13/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day13 {
    
    let input:String = "13"
    
    func showSolutions() {
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "txt")!

        let str = try! String(contentsOf: resourceURL)
        
        var carts: [Cart] = []
        
        let track = str.split(separator: "\n").enumerated().map { y, line in
            return line.enumerated().map { x, char -> Track in
                if let dir = Direction(rawValue: char) {
                    carts.append(Cart(coord: Point(x: x, y: y), facing: dir))
                    return dir == .left || dir == .right ? .horizontal : .vertical
                }
                return Track(rawValue: char)!
            }
        }
        
        
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
        aAndB(track, carts)
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }

    
    struct Point: Hashable {
        var x: Int
        var y: Int
        
        static func +(lhs: Point, rhs: Point) -> Point {
            return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
        }
    }
    
    enum Direction: Character {
        case up = "^", down = "v", left = "<", right = ">"
        var turningLeft: Direction {
            switch self {
            case .up: return .left
            case .down: return .right
            case .right: return .up
            case .left: return .down
            }
        }
        
        var turningRight: Direction {
            switch self {
            case .up: return .right
            case .down: return .left
            case .right: return .down
            case .left: return .up
            }
        }
        
        var coords: Point {
            switch self {
            case .up: return Point(x: 0, y: -1)
            case .down: return Point(x: 0, y: 1)
            case .left: return Point(x: -1, y: 0)
            case .right: return Point(x: 1, y: 0)
            }
        }
    }
    
    enum Track: Character {
        case vertical = "|", horizontal = "-", diagonalA = "/", diagonalB = "\\", intersection = "+", none = " "
        
        func go(from: Direction) -> Direction {
            switch self {
            case .vertical, .horizontal: return from
            case .diagonalA:
                switch from {
                case .up: return .right
                case .down: return .left
                case .right: return .up
                case .left: return .down
                }
            case .diagonalB:
                switch from {
                case .up: return .left
                case .down: return .right
                case .right: return .down
                case .left: return .up
                }
            case .intersection, .none: fatalError("Shouldn't use go on track of type \(self)")
            }
        }
    }
    
    enum Turn {
        case left, right, straight
        func apply(to direction: Direction) -> Direction {
            switch self {
            case .left: return direction.turningLeft
            case .right: return direction.turningRight
            case .straight: return direction
            }
        }
    }
    
 

    func aAndB(_ track: [[Track]], _ carts: [Cart]) {
        var carts = carts
        var positions = Dictionary(uniqueKeysWithValues: carts.lazy.map({ ($0.coord, $0) }) )
        var foundedA:Bool = false
         while carts.count > 1 {
            carts.sort(by: { $0.coord.y != $1.coord.y ? $0.coord.y < $1.coord.y : $0.coord.x < $1.coord.x })
            for cart in carts {
                guard !cart.removed else { continue }
                let trackPiece = track[cart.coord.y][cart.coord.x]
                positions[cart.coord] = nil
                cart.go(on: trackPiece)
                
                if let other = positions[cart.coord] {
                    positions[cart.coord] = nil
                    if !foundedA {
                        print("\tA: \(cart.coord.x),\(cart.coord.y)")
                        foundedA = true
                    }
                    cart.removed = true
                    other.removed = true
                }
                else {
                    positions[cart.coord] = cart
                }
            }
            carts.removeAll(where: { $0.removed })
            if carts.count == 1 {
                print("\tB: \(carts[0].coord.x),\(carts[0].coord.y)")
            }
        }
    }

    
    
    
}


class Cart: CustomStringConvertible {
    var coord: Day13.Point
    
    var facing: Day13.Direction
    var nextTurn: Day13.Turn = .left
    var removed: Bool = false
    
    func go(on track: Day13.Track) {
        if case .intersection = track {
            facing = nextTurn.apply(to: facing)
            switch nextTurn {
            case .left: nextTurn = .straight
            case .straight: nextTurn = .right
            case .right: nextTurn = .left
            }
        }
        else {
            facing = track.go(from: facing)
        }
        coord = coord + facing.coords
    }
    
    init(coord: Day13.Point, facing: Day13.Direction) {
        (self.coord, self.facing) = (coord, facing)
    }
    
    var description: String {
        return "Cart(coord: \(coord), facing: \(facing), nextTurn: \(nextTurn), removed: \(removed))"
    }
}



