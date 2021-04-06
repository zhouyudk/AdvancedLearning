//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/minimum-height-trees/

class Solution {
    func findMinHeightTrees(_ n: Int, _ edges: [[Int]]) -> [Int] {
        var dic = [Int: Int]()
        for
    }

    struct Node {
        var child: [Node]
        var val: Int
        var parent: Node
    }
}

let edges = [[1,0],[1,2],[1,3]]
let n = 4
