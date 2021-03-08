//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/gray-code/

//
class Solution {
    func grayCode(_ n: Int) -> [Int] {
        var res = [0]
        var head = 1
        for _ in 0..<n {
            for j in res.reversed() {
                res.append(j+head)
            }
            head <<= 1
        }
        return res
    }
}

Solution().grayCode(2)

//0   0
//1   0
//
//    1
//2   00
//    01
//
//    11
//    10
//3   000
//    001
//    011
//    010
//
//    110
//    111
//    101
//    100
// 位数n  相当于位数n-1的 序列左侧加0 再加上序列倒序左侧加1  以此类推

