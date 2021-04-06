//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/binary-tree-zigzag-level-order-traversal/

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }

    static func creatTree(_ count: Int) -> TreeNode? {
        var nodeList = [TreeNode]()
        for i in 0..<count {
            nodeList.append(TreeNode(i))
        }
        var j = 0
        var i = 1
        while i<count {
            let node = nodeList[j]
            node.left = nodeList[i]
            if i+1<count {
                node.right = nodeList[i+1]
            }
            i += 2
            j += 1
        }
        inOrder(nodeList.first!)
        return nodeList.first
    }

    //生成二叉搜索树
    static var i = 0
    static func inOrder(_ node: TreeNode?) {
        if node == nil { return }
        inOrder(node!.left)
        node!.val = i
        print(node!.val)
        i += 1
        inOrder(node!.right)
    }
}

class Solution {
    //迭代 BFS
    func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
        guard root != nil else { return []}
        var levelList: [TreeNode] = [root!]
        var res = [[Int]]()
        var direction = true// true 升序 、 false 降序
        while !levelList.isEmpty {
            var nNodeArr = [TreeNode]()
            var valueArr = [Int]()
            
            for node in levelList {
                valueArr.append(node.val)
                if let left = node.left {
                    nNodeArr.append(left)
                }
                if let right = node.right {
                    nNodeArr.append(right)
                }
            }
            res.append(direction ? valueArr : valueArr.reversed())
            levelList = nNodeArr
            direction = !direction
        }
        return res
    }

    func zigzagLevelOrder1(_ root: TreeNode?) -> [[Int]] {
        return []
    }
    // 递归DFS
}
