//
//  Day21.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 21/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day21 {
    
    let inputFileName:String = "21"
    
    func showSolutions() {
        let str   = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputFileName):")
        
        
        let split = str.split(separator: "\n")
        let binding = Int(split.first!.split(separator: " ")[1])!
        let input = split.compactMap { line in
            return Instruction(line.split(separator: " "))
        }
        a(input, ip: binding)
       // a(input, ip: binding)
        
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    func a(_ input: [Instruction], ip: Int) {
        
    
        func test(register:Int = 0 ) {
            let computer = Computer(ipBinding: 5)
            computer.registers[0] = register
            var counter = 0
            while input.indices.contains(computer.instructionRegister) {
                let ip = computer.instructionRegister
                let instruction = input[ip]
                
                computer.exec(instruction)
                computer.instructionRegister += 1
                counter += 1
                if counter > 10000 {
                    return
                }
            }
            computer.instructionRegister -= 1
            print(computer.registers)
            print(register)
            fatalError()
        }
        
        for i in 1...999999 {
            test(register: i)
        }
    
    }
    func b(_ input: [Instruction], ip: Int) {
        let computer = Computer(ipBinding: ip)
        var target = 0
        computer.registers[0] = 0
        while input.indices.contains(computer.instructionRegister) {
            let ip = computer.instructionRegister
            let instruction = input[ip]
            computer.exec(instruction)
            computer.instructionRegister += 1
            if computer.instructionRegister == 1 {
                target = computer.registers[5] ///forr different inputs, change this register index.
                break
            }
        }
        var total = 0
        let up = 1
        let d = Int(Double(target).squareRoot())
        
        var upper = d
        var down = up
        if up > d {
            upper = up
            down = d
        }
        
        for i in down...upper {
            if target % i == 0 {
                total += i
                if target / i != i {
                    total += target/i
                }
            }
        }
        print(total)
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




