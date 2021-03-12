//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init?(_ val: Int?) {
        guard let v = val else { return nil }
        self.val = v
        self.left = nil
        self.right = nil
    }

    static func creatTree(_ count: Int) -> TreeNode? {
        var nodeList = [TreeNode?]()
        for i in 0..<count {
            nodeList.append(TreeNode(i))
        }
        var j = 0
        var i = 1
        while i<count {
            let node = nodeList[j]
            node?.left = nodeList[i]
            if i+1<count {
                node?.right = nodeList[i+1]
            }
            i += 2
            j += 1
        }
        inOrder(nodeList.first!)
        return nodeList.first!
    }
 // TODO: 间隔nil构造错误 待解决
    static func creatTree(_ vals: Int?...) -> TreeNode? {
        var nodeList = [TreeNode?]()
        for i in vals {
            nodeList.append(TreeNode(i))
        }
        var j = 0
        var i = 1
        while i<vals.count {
            let node = nodeList[j]
            node?.left = nodeList[i]
            if i+1<vals.count {
                node?.right = nodeList[i+1]
            }
            i += 2
            j += 1
        }
        return nodeList.first!
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
    //找出两个 节点的路径 加入两个数组， 然后遍历连个数组找到最后一个相同的节点
    var findP = false
    var findQ = false
    var same: TreeNode? = nil
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        helper(root, p, q)
        return same
    }


    func helper(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> Bool {
        guard root != nil && (!findP || !findQ)  else { return false }

        if !findP {
            if root?.val == p?.val {
                pRount = rount+[root]
                findP = true
            }
        }

        if !findQ {
            if root?.val == q?.val {
                qRount = rount+[root]
                findQ = true
            }
        }

        if findP && findQ { same = root }
        print(rount.map { $0?.val})
        helper(root?.left, p, q)
        helper(root?.right, p, q)

    }
}

//let t = TreeNode.creatTree(3,5,1,6,2,0,8,nil,nil,7,4)
let t = TreeNode.creatTree(1,nil,2,nil,3,nil,4,nil,5,nil,6)
Solution().lowestCommonAncestor(t, TreeNode(5), TreeNode(6))
