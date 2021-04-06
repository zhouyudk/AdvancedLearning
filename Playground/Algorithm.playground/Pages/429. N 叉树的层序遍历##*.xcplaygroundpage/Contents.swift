//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/n-ary-tree-level-order-traversal/

public class Node {
    public var val: Int
    public var children: [Node]
    public init(_ val: Int) {
        self.val = val
        self.children = []
    }
}

class Solution {
    func levelOrder(_ root: Node?) -> [[Int]] {
        guard root != nil else { return []}
        var levelList: [Node] = [root!]
        var res = [[Int]]()
        while !levelList.isEmpty {
            var nNodeArr = [Node]()
            var valueArr = [Int]()
            for node in levelList {
                valueArr.append(node.val)
                nNodeArr += node.children
            }
            res.append(valueArr)
            levelList = nNodeArr
        }
        return res
    }

    // 使用递归
    func levelOrder1(_ root: Node?) -> [[Int]] {
        var res = [[Int]]()
        func helper(_ root: Node?, level: Int) {
            guard root != nil else { return }
            if level<res.count {
                res[level].append(root!.val)
            } else {
                res.append([root!.val])
            }
            for node in root!.children {
                helper(node, level: level+1)
            }
        }
        helper(root, level: 0)
        return res
    }
}


