//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/sudoku-solver/

class Solution {

    var hashRow = Array(repeating: [Character: Int](), count: 9)
    var hasColumn = Array(repeating: [Character: Int](), count: 9)
    var hashBox = Array(repeating: [Character: Int](), count: 9)
    var isSolved = false


    func solveSudoku(_ board: inout [[Character]]) {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] != Character(".") {
                    let num = board[row][col]
                    hashRow[col][num] = 0
                    hasColumn[row][num] = 0
                    hashBox[(row/3)*3+col/3][num] = 0
                }
            }
        }
        solveSudoku(&board, row: 0, col: 0)
    }

    func solveSudoku(_ board: inout [[Character]], row: Int, col: Int) {
        if row >= 9 || col >= 9 {
            isSolved = true
            return
        }
        if board[row][col] == Character(".") {
            for input in 1...9 {
                let ch = Character("\(input)")
                if hashRow[col][ch] == nil
                    && hasColumn[row][ch] == nil
                    && hashBox[(row/3)*3+col/3][ch] == nil {

                    hashRow[col][ch] = 0
                    hasColumn[row][ch] = 0
                    hashBox[(row/3)*3+col/3][ch] = 0
                    board[row][col] = ch
//                    print(board)
//                    print("=-=====================================")
                    solveSudoku(&board, row: row+col/8, col: (col/8 == 0 ? col+1 : 0))
                    if isSolved {
                        return
                    }
                    //回溯环境清理
                    board[row][col] = Character(".")
                    hashRow[col][ch] = nil
                    hasColumn[row][ch] = nil
                    hashBox[(row/3)*3+col/3][ch] = nil
                }
            }
        } else {
            solveSudoku(&board, row: row+col/8, col: (col/8 == 0 ? col+1 : 0))
        }
    }

    func isValidSudoku(_ board: [[Character]]) -> Bool {
        var hashRow = Array(repeating: [Character: Int](), count: 9)
        var hasColumn = Array(repeating: [Character: Int](), count: 9)
        var hashBox = Array(repeating: [Character: Int](), count: 9)

        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] != Character(".") {
                    let num = board[row][col]
                    //行判断
                    if hashRow[col][num] == nil {
                        hashRow[col][num] = 0
                    } else {
                        return false
                    }

                    //列判断
                    if hasColumn[row][num] == nil {
                        hasColumn[row][num] = 0
                    } else {
                        return false
                    }

                    //3*3判断 将数独分为从左到右 从上到下  0-9 9个hash
                    //index 计算方式未 (row/3)*3+col/3
                    if hashBox[(row/3)*3+col/3][num] == nil {
                        hashBox[(row/3)*3+col/3][num] = 0
                    } else {
                        return false
                    }
                }
            }
        }
        return true
    }
}

let sudu = [["5","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]

var charSudu = sudu.map { (arr) -> [Character] in
     return arr.map { (str) -> Character in
        return Character(str)
    }
}

Solution().solveSudoku(&charSudu)

print(charSudu)
