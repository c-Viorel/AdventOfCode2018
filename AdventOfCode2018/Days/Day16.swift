//
//  Day16.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 16/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//
import Foundation
class Day16 {
    
    let inputFileName:String = "16"
    
    func showSolutions() {
        let str = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputFileName):")
        
        
        let input = str.components(separatedBy: "\n\n").compactMap { block -> (from: [Int], instr: Instruction, to: [Int])? in
            let numbers = block.split(whereSeparator: { !"0123456789".contains($0) }).lazy.map { Int($0)! }
            guard numbers.count == 12 else { return nil }
            let from = Array(numbers[0..<4])
            let instr = Instruction(numbers[4..<8])!
            let to = Array(numbers[8..<12])
            return (from, instr, to)
        }
        //part two
        let testData = str.components(separatedBy: "\n\n\n\n")[1].split(separator: "\n").map { line in
            return Instruction(line.split(separator: " ").lazy.map { Int($0)! })!
        }
        
        //
        a(input)
        b(input, program: testData)
        
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }

    
    enum Opcode: CaseIterable {
        
        case addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr
        
    
        func exec(instr: Instruction, input: [Int]) -> [Int] {
            var output = input
            switch self {
            case .addr: output[instr.c] = output[instr.a] + output[instr.b]
            case .addi: output[instr.c] = output[instr.a] + instr.b
            case .mulr: output[instr.c] = output[instr.a] * output[instr.b]
            case .muli: output[instr.c] = output[instr.a] * instr.b
            case .banr: output[instr.c] = output[instr.a] & output[instr.b]
            case .bani: output[instr.c] = output[instr.a] & instr.b
            case .borr: output[instr.c] = output[instr.a] | output[instr.b]
            case .bori: output[instr.c] = output[instr.a] | instr.b
            case .setr: output[instr.c] = output[instr.a]
            case .seti: output[instr.c] = instr.a
            case .gtir: output[instr.c] = instr.a > output[instr.b] ? 1 : 0
            case .gtri: output[instr.c] = output[instr.a] > instr.b ? 1 : 0
            case .gtrr: output[instr.c] = output[instr.a] > output[instr.b] ? 1 : 0
            case .eqir: output[instr.c] = instr.a == output[instr.b] ? 1 : 0
            case .eqri: output[instr.c] = output[instr.a] == instr.b ? 1 : 0
            case .eqrr: output[instr.c] = output[instr.a] == output[instr.b] ? 1 : 0
            }
            return output
        }
    }
    
    struct Instruction {
        var opcode: Int
        var a: Int
        var b: Int
        var c: Int
        
        init?<S: Sequence>(_ seq: S) where S.Element == Int {
            guard let tupleFour = seq.tupleOfFour else { return nil }
            (opcode, a, b, c) = tupleFour
        }
    }
    
    func a(_ input: [(from: [Int], instr: Instruction, to: [Int])]) {
        print(input.lazy.map { (from, instr, to) in
            Opcode.allCases.lazy.filter { $0.exec(instr: instr, input: from) == to }.count
            }.filter({ $0 >= 3 }).count)
    }
    
    
    func b(_ input: [(from: [Int], instr: Instruction, to: [Int])], program: [Instruction]) {
        var possibleMappings = Array(repeating: Opcode.allCases, count: 16)
        for (from, instr, to) in input {
            possibleMappings[instr.opcode].removeAll(where: { $0.exec(instr: instr, input: from) != to })
        }
        
        var finalMappings = possibleMappings.map { $0.count == 1 ? $0[0] : nil }
        var new = finalMappings.compactMap { $0 }
        while let next = new.popLast() {
            for index in possibleMappings.indices {
                if let i = possibleMappings[index].firstIndex(of: next) {
                    possibleMappings[index].remove(at: i)
                    if possibleMappings[index].count == 1 {
                        finalMappings[index] = possibleMappings[index][0]
                        new.append(possibleMappings[index][0])
                    }
                }
            }
        }
        let mappings = finalMappings.map { $0! }
        var arr = [0, 0, 0, 0]
        for instruction in program {
            arr = mappings[instruction.opcode].exec(instr: instruction, input: arr)
        }
        print(arr)
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

