//
//  SuDoKuLogic.swift
//  sudoku
//
//  Created by Moinuddin Girach on 29/11/21.
//

import Foundation

struct Steps {
    var row: Int
    var col: Int
    var oldValue: Int
    var newValue: Int
}

struct Board {
    let size: Int
    let defaultValues: Int = 0
    let steps: [Steps] = []
    var slots: [[Slots]] = []
}

struct Slots {
    var value: Int
    let isPrefilled: Bool
    let correctValue: Int
    let location : Location
    
    var isFilled: Bool {
        return value != 0
    }
    var isCorrect: Bool {
        return correctValue == value
    }
}

struct Location {
    let row: Int
    let col: Int
}

class GameManager {
    
    subscript(row: Int, col: Int) -> Int {
        return board!.slots[row][col].value
    }
    
    static let shared: GameManager = {
       return GameManager()
    }()
    
    func createGame() {
        let boards = sudoku.createPuzzle(difficulty: 4)
        createGameBoard(fullboard: boards.fullBoard, puzzleBoard: boards.puzzleBoard)
    }
    
    func resetGame() {
        steps = []
        for i in 0..<9 {
            for j in 0..<9 {
                if let isPrefiled = board?.slots[i][j].isPrefilled, !isPrefiled {
                    board?.slots[i][j].value = 0
                }
            }
        }
    }
    
    func fillValue(value: Int, row: Int, col: Int, isUndoRedo: Bool = false) {
        if let slot = board?.slots[row][col], !(slot.isPrefilled && slot.isFilled) {
            if !isUndoRedo {
                let step = Steps(row: row, col: col, oldValue: slot.value, newValue: value)
                setStep(step: step)
            }
            board?.slots[row][col].value = value

        }
    }
    
    func eraseValue(row: Int, col: Int) {
        fillValue(value: 0, row: row, col: col)
    }
    
    func getHint() -> (value: Int, row: Int, col: Int) {
        var row = Int(arc4random() % 9)
        var col = Int(arc4random() % 9)
        while board!.slots[row][col].isFilled {
            row = Int(arc4random() % 9)
            col = Int(arc4random() % 9)
        }
        let slot = board!.slots[row][col]
        fillValue(value: slot.correctValue, row: row, col: col)
        return (slot.correctValue, row, col)
    }
    
    func undo() -> (value: Int, row: Int, col: Int)? {
        if (steps.count > undoPointer) && undoPointer >= 0 {
            let step = steps[undoPointer]
            fillValue(value: step.oldValue, row: step.row, col: step.col, isUndoRedo: true)
            undoPointer -= 1
            return (step.oldValue, step.row, step.col)
        }
        return nil
    }
    
    func redo() -> (value: Int, row: Int, col: Int)? {
        if steps.count > (undoPointer + 1) {
            let step = steps[undoPointer + 1]
            fillValue(value: step.newValue, row: step.row, col: step.col, isUndoRedo: true)
            undoPointer += 1
            return (step.newValue, step.row, step.col)
        }
        return nil
    }
    
    private var board: Board?
    private var steps: [Steps] = []
    private var sudoku = SudokuGenerator()
    private var undoPointer: Int = -1
    
    private init() {
        
    }
    
    private func createGameBoard(fullboard: [[Int]], puzzleBoard: [[Int]]) {
        board = Board(size: 9)
        for (indexRow, row) in fullboard.enumerated() {
            var gameRow = [Slots]()
            for (indexCol, element) in row.enumerated() {
                let location = Location(row: indexRow, col: indexCol)
                let isPrefilled = puzzleBoard[indexRow][indexCol] != 0
                let slot = Slots(value: puzzleBoard[indexRow][indexCol], isPrefilled: isPrefilled, correctValue: element, location: location)
                gameRow.append(slot)
            }
            board?.slots.append(gameRow)
        }
    }
    
    private func setStep(step: Steps) {
        while steps.count > (undoPointer + 1) {
            steps.removeLast()
        }
        steps.append(step)
        undoPointer += 1
    }
}

class SudokuGenerator {
    
    /// reate puzzle
    /// - Parameter difficulty: 1 - 5
    /// - Returns: give sudoku elements array
    func createPuzzle(difficulty: Int) -> (fullBoard: [[Int]], puzzleBoard: [[Int]]) {
        var grid = [[Int]].init(repeating: [Int].init(repeating: 0, count: 9), count: 9)
        generateGame(grid: &grid)
        let puzzle = prepareBoard(grid: grid,difficulty: difficulty)
        return (grid, puzzle)
    }
    
 
    /// give randoom hint object
    /// - Returns: gives value, row and col for which hint given
//    func getHint() -> (value: Int, row: Int, col: Int)? {
//        if isFull(grid: gridProgress) {
//            return nil
//        }
//        var row = Int(arc4random() % 9)
//        var col = Int(arc4random() % 9)
//        while gridProgress[row][col] != 0 {
//            row = Int(arc4random() % 9)
//            col = Int(arc4random() % 9)
//        }
//        return (gridSolution[row][col], row, col)
//    }
    
    /// check either all values are filled in game
    /// - Returns: true if game completed else false
//    func isGameCompleted() -> Bool {
//        return isFull(grid: gridProgress)
//    }
    
    private var numlist = [1,2,3,4,5,6,7,8,9]
    private var counter = 1
    
//    private func isValid(grid: [[Int]]) -> Bool {
//        for i in 0..<9 {
//            for j in 0..<9 {
//                if !(grid[i][j] == 0 || grid[i][j] == gridSolution[i][j]) {
//                    return false
//                }
//            }
//        }
//        return true
//    }
    
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
    
    private func prepareBoard(grid: [[Int]], difficulty: Int) -> [[Int]] {
        var gridPuzzle = grid
        var difficulty = difficulty
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
        return gridPuzzle
    }
}
