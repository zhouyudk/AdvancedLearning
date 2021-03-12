//: [Previous](@previous)

import Foundation


//https://leetcode-cn.com/problems/minimum-depth-of-binary-tree/


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

// 二叉树的最小深度  是距离最近一个叶子(没有子节点)的深度，
class Solution {
    // 递归O(n)
    func minDepth(_ root: TreeNode?) -> Int {
        return minDepth(root, 0)
    }

    func minDepth(_ root: TreeNode?, _ current: Int) -> Int {
        guard root != nil else { return current }
        //如果左右节点都为空则 找到这条路径上的最小深度
        if root?.left == nil && root?.right == nil {
            return current+1
        }
        // 如果左右节点都有 ，则取最小的
        if root?.left != nil && root?.right != nil {
            return min(minDepth(root?.left, current+1), minDepth(root?.right, current+1))
        }
        // 如果左右节点只有一个则 取最大的
        return max(minDepth(root?.left, current+1), minDepth(root?.right, current+1))
    }
}
