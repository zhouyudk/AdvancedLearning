//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/maximal-rectangle/

class Solution {
    func maximalRectangle(_ matrix: [[Character]]) -> Int {
        guard let first = matrix.first else { return 0 }
        guard first.count > 0  else { return 0}
        var matrixTmp = Array(repeating: Array(repeating: 0, count: first.count), count: matrix.count)
        //计算每格左侧的连续1的数量并存在对应位置
        for row in 0..<matrix.count {
            var count = 0
            for col in 0..<first.count {
                if String([matrix[row][col]]) == "1" {
                    count += 1
                    matrixTmp[row][col] = count
                } else {
                    matrixTmp[row][col] = 0
                    count = 0
                }
            }
        }
        print(matrixTmp)

        var maxArea = 0
        //遍历每一个重构的单元格，并从当前row 逐行递减 计算最大面积
        for col in 0..<first.count {
            for row in 0..<matrixTmp.count {
                if matrixTmp[row][col] > 1 {
                    var width = matrixTmp[row][col]
                    var area = width
                    //以当前格为基准向上遍历 单元格的 使用最小连续1的数量乘以行差
                    for r in (0..<row).reversed() {
                        width = min(width, matrixTmp[r][col])
                        area = max(area, width*(row-r+1))
                    }
                    maxArea = max(area, maxArea)
                }
            }
        }

        return maxArea
    }

    // 通题 84， 通过前后加入哨兵 减少每次 stack的空判断
    func maxArea(arr: [Int]) -> Int {
        var arrTmp = arr
        arrTmp.insert(0, at: 0)
        arrTmp.append(0)
        var stack = [0]
        var area = 0
        for i in 1..<arrTmp.count {
            if arrTmp[i] > arrTmp[stack.last!] {
                stack.append(i)
            } else if arrTmp[i] == arrTmp[stack.last!]{
                continue
            } else {
                while arrTmp[stack.last!] > arrTmp[i] {
                    let last = stack.last!
                    stack.removeLast()
                    if !stack.isEmpty {
                        area = max(arrTmp[last]*(i-stack.last!-1), area)
                    }
                }
                stack.append(i)
            }
        }
        return area
    }

    func maximalRectangle1(_ matrix: [[Character]]) -> Int {
        guard let first = matrix.first else { return 0 }
        guard first.count > 0  else { return 0}
        var matrixTmp = Array(repeating: Array(repeating: 0, count: first.count), count: matrix.count)
        //计算每格左侧的连续1的数量并存在对应位置
        for row in 0..<matrix.count {
            var count = 0
            for col in 0..<first.count {
                if String(matrix[row][col]) == "1" {
                    count += 1
                    matrixTmp[row][col] = count
                } else {
                    matrixTmp[row][col] = 0
                    count = 0
                }
            }
        }
//        print(matrixTmp)

        var maxA = 0
        //遍历每一个重构的单元格，并从当前row 逐行递减 计算最大面积
        for col in 0..<first.count {
            var arr = [Int]()
            for row in 0..<matrixTmp.count {
                arr.append(matrixTmp[row][col])
            }

            maxA = max(maxArea(arr: arr), maxA)
        }

        return maxA
    }

    func maximalRectangle2(_ matrix: [[Character]]) -> Int {
            guard let first = matrix.first else { return 0 }
            guard first.count > 0  else { return 0}
            var matrixTmp = Array(repeating: Array(repeating: 0, count: first.count), count: matrix.count)
            //计算每格上侧的连续1的数量并存在对应位置//减少后续组装数组的时间
            for col in 0..<first.count {
                var count = 0
                for row in 0..<matrix.count {
                    if String(matrix[row][col]) == "1" {
                        count += 1
                        matrixTmp[row][col] = count
                    } else {
                        matrixTmp[row][col] = 0
                        count = 0
                    }
                }
            }
    //        print(matrixTmp)

        var maxA = 0
        //遍历每一个重构的单元格，并从当前row 逐行递减 计算最大面积
        for row in matrixTmp {
            maxA = max(maxArea(arr: row), maxA)
        }
        return maxA
    }
}


let matrix = [["1","0","1","1","1"],["0","1","0","1","0"],["1","1","0","1","1"],["1","1","0","1","1"],["0","1","1","1","1"]]
let nM = matrix.map { row -> [Character] in
    return row.map { str -> Character in
        return str.first!
    }
}

Solution().maximalRectangle2(nM)
