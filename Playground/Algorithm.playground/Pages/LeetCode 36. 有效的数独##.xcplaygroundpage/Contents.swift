//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/valid-sudoku/
//每一个行列和9格 使用hash代替
class Solution {
    //接近暴力法
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        var intBoard = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        for i in 0..<9 {
            for j in 0..<9 {
                if let num = Int(String(board[i][j])) {
                    intBoard[i][j] = num
                }
            }
        }

        return isRowValid(intBoard)
            && isColumnValid(intBoard)
            && isSubBoardValid(intBoard)
    }

    //使用hash的key存储数独的值 快速查重
    func isRowValid(_ board: [[Int]]) -> Bool {
        for i in 0..<9 {
            var hash = [Int: Int]()
            for j in 0..<9 {
                if board[i][j] > 0 {
                    if hash[board[i][j]] == nil {
                        hash[board[i][j]] = 0
                    } else {
                        return false
                    }
                }
            }
        }
        return true
    }

    func isColumnValid(_ board: [[Int]]) -> Bool {
        for i in 0..<9 {
            var hash = [Int: Int]()
            for j in 0..<9 {
                if board[j][i] > 0 {
                    if hash[board[j][i]] == nil {
                        hash[board[j][i]] = 0
                    } else {
                        return false
                    }
                }
            }
        }
        return true
    }

    func isSubBoardValid(_ board: [[Int]]) -> Bool {
        for i in [0,3,6] {
            for j in [0,3,6] {
                var hash = [Int: Int]()
                for ii in i..<i+3 {
                    for jj in j..<j+3 {
                        if board[ii][jj] > 0 {
                            if hash[board[ii][jj]] == nil {
                                hash[board[ii][jj]] = 0
                            } else {
                                return false
                            }
                        }
                    }
                }
            }
        }
        return true
    }

    //一次迭代
    func isValidSudoku2(_ board: [[Character]]) -> Bool {
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
