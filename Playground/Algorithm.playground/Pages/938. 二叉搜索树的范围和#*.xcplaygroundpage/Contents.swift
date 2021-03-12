//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/range-sum-of-bst/

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
    // 基本递归 不判断边界
    func rangeSumBST(_ root: TreeNode?, _ low: Int, _ high: Int) -> Int {
        guard let root = root else { return 0 }
        let l = rangeSumBST(root.left, low, high)
        let cur = root.val >= low && root.val <= high ? root.val : 0
        let r = rangeSumBST(root.right, low, high)
        return l+cur+r
    }

    func rangeSumBST1(_ root: TreeNode?, _ low: Int, _ high: Int) -> Int {
        guard let root = root else { return 0 }
        let l = root.val >= low ? rangeSumBST(root.left, low, high) : 0
        let cur = root.val >= low && root.val <= high ? root.val : 0
        let r = root.val <= high ? rangeSumBST(root.right, low, high) : 0
        return l+cur+r
    }
}
