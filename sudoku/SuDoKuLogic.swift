//
//  SuDoKuLogic.swift
//  sudoku
//
//  Created by Moinuddin Girach on 29/11/21.
//

import Foundation


class Sudoku {
    
    /// reate puzzle
    /// - Parameter difficulty: 1 - 5
    /// - Returns: give sudoku elements array
    func createPuzzle(difficulty: Int) -> [[Int]] {
        reset()
        self.difficulty = difficulty
        generateGame(grid: &gridPuzzle)
        gridSolution = gridPuzzle
        gridProgress = gridPuzzle
        prepareBoard()
        return gridPuzzle
    }
    
    /// remove number from the board
    /// - Parameters:
    ///   - row: grid row 0 - 8
    ///   - col: grid col 0 - 8
    /// - Returns: true if success else false
    func eraseNumber(row: Int, col: Int) -> Bool {
        if gridPuzzle[row][col] != 0 {
            return false
        } else {
            gridProgress[row][col] = 0
            return true
        }
    }
    
    /// insert number to board
    /// - Parameters:
    ///   - number: number to be inserted
    ///   - row: grid row 0 - 8
    ///   - col: grid col 0 - 8
    /// - Returns: true if success else false
    func addNumber(number: Int, row: Int, col: Int) -> Bool {
        if gridProgress[row][col] != 0 {
            return false
        } else {
            if gridSolution[row][col] == number {
                gridProgress[row][col] = number
                return true
            } else {
                return false
            }
        }
    }
    
    /// give randoom hint object
    /// - Returns: gives value, row and col for which hint given
    func getHint() -> (value: Int, row: Int, col: Int)? {
        if isFull(grid: gridProgress) {
            return nil
        }
        var row = Int(arc4random() % 9)
        var col = Int(arc4random() % 9)
        while gridProgress[row][col] != 0 {
            row = Int(arc4random() % 9)
            col = Int(arc4random() % 9)
        }
        return (gridSolution[row][col], row, col)
    }
    
    /// check either all values are filled in game
    /// - Returns: true if game completed else false
    func isGameCompleted() -> Bool {
        return isFull(grid: gridProgress)
    }
    
    private var gridPuzzle = [[Int]].init(repeating: [Int].init(repeating: 0, count: 9), count: 9)
    private var gridProgress = [[Int]].init(repeating: [Int].init(repeating: 0, count: 9), count: 9)
    private var gridSolution = [[Int]].init(repeating: [Int].init(repeating: 0, count: 9), count: 9)
    private var numlist = [1,2,3,4,5,6,7,8,9]
    private var counter = 1
    private var difficulty = 5

    private func reset() {
        gridPuzzle.removeAll()
        gridProgress.removeAll()
        gridSolution.removeAll()
    }
    
    private func isValid(grid: [[Int]]) -> Bool {
        for i in 0..<9 {
            for j in 0..<9 {
                if !(grid[i][j] == 0 || grid[i][j] == gridSolution[i][j]) {
                    return false
                }
            }
        }
        return true
    }
    
    private func getCol(grid: [[Int]], col: Int) -> [Int] {
        var tempArr = [Int]()
        for i in 0..<9 {
            tempArr.append(grid[i][col])
        }
        return tempArr
    }
    
    private func createSquare(grid: [[Int]], row: Int, col: Int) -> [[Int]] {
        var temp = [[Int]]()
        for i in row..<(row + 3) {
            var arrRow = [Int]()
            for j in col..<(col + 3) {
                arrRow.append(grid[i][j])
            }
            temp.append(arrRow)
        }
        return temp
    }
    
    private func isFull(grid: [[Int]]) -> Bool {
        for row in grid {
            for element in row {
                if element == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    private func checkPossilbeSolution(grid: inout [[Int]]) -> Bool {
        var row = 0
        var col = 0
        for i in 0..<81 {
            row = i / 9
            col = i % 9
            
            if grid[row][col] == 0 {
                for value in 1..<10 {
                    if !grid[row].contains(value) {
                        if !getCol(grid: grid, col: col).contains(value) {
                            let square = generateSquare(grid: grid, row: row, col: col)
                            if !(square[0].contains(value) || square[1].contains(value) || square[2].contains(value)) {
                                grid[row][col] = value
                                if isFull(grid: grid) {
                                    counter += 1
                                    if counter > 2 {
                                        return true
                                    } else {
                                        break
                                    }
                                } else if checkPossilbeSolution(grid: &grid) {
                                    return true
                                }
                            }
                        }
                    }
                }
                break
            }
        }
        grid[row][col] = 0
        return false
    }
    
    private func generateGame(grid: inout [[Int]]) -> Bool {
        var row = 0
        var col = 0
        for i in 0..<81 {
            row = i / 9
            col = i % 9
            
            if grid[row][col] == 0 {
                for value in numlist.shuffled() {
                    if !grid[row].contains(value) {
                        if !getCol(grid: grid, col: col).contains(value) {
                            let square = generateSquare(grid: grid, row: row, col: col)
                            if !(square[0].contains(value) || square[1].contains(value) || square[2].contains(value)) {
                                grid[row][col] = value
                                if isFull(grid: grid) {
                                    return true
                                } else if generateGame(grid: &grid) {
                                    return true
                                }
                            }
                        }
                    }
                }
                break
            }
        }
        grid[row][col] = 0
        return false
    }
    
    private func generateSquare(grid: [[Int]], row: Int, col: Int) -> [[Int]] {
        var square = [[Int]]()
        if row < 3 {
            if col < 3 {
                square = createSquare(grid: grid, row: 0, col: 0)
            } else if col < 6 {
                square = createSquare(grid: grid, row: 0, col: 3)
            } else {
                square = createSquare(grid: grid, row: 0, col: 6)
            }
        } else if row < 6 {
            if col < 3 {
                square = createSquare(grid: grid, row: 3, col: 0)
            } else if col < 6 {
                square = createSquare(grid: grid, row: 3, col: 3)
            } else {
                square = createSquare(grid: grid, row: 3, col: 6)
            }
        } else {
            if col < 3 {
                square = createSquare(grid: grid, row: 6, col: 0)
            } else if col < 6 {
                square = createSquare(grid: grid, row: 6, col: 3)
            } else {
                square = createSquare(grid: grid, row: 6, col: 6)
            }
        }
        return square
    }
    
    private func prepareBoard() {
        while difficulty > 0 {
            var row = Int(arc4random() % 9)
            var col = Int(arc4random() % 9)
            while gridPuzzle[row][col] == 0 {
                row = Int(arc4random() % 9)
                col = Int(arc4random() % 9)
            }
            let backup = gridPuzzle[row][col]
            gridPuzzle[row][col] = 0
            
            var copyGrid = gridPuzzle
            counter = 0
            checkPossilbeSolution(grid: &copyGrid)
            if counter != 1 {
                gridPuzzle[row][col] = backup
                difficulty -= 1
            }
        }
    }
}
