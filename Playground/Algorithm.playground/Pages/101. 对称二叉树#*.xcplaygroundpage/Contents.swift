//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/symmetric-tree/
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

    //将root的左右均中序遍历 然后反向比较
    func isSymmetric(_ root: TreeNode?) -> Bool {
        guard let root = root else { return false }
        guard root.left?.val == root.right?.val else { return false }
        var leftArr = [Int?]()
        var rightArr = [Int?]()
        midOrder(root.left, res: &leftArr)
        midOrder(root.right, res: &rightArr)
        let len = leftArr.count
        for i in 0..<len {
            if leftArr[i] != rightArr[len-1-i] {
                return false
            }
        }
        return true
    }

    // left 中序遍历 然后 翻转， 再和 右侧比较
//    func isSymmetric1(_ root: TreeNode?) -> Bool {
//        guard let root = root else { return false }
//        guard root.left?.val == root.right?.val else { return false }
//        let leftArr = midOrder(root.left)
//        let rightArr = midOrder(root.right)
//        let len = leftArr.count
//        for i in 0..<len {
//            if leftArr[i] != rightArr[len-1-i] {
//                return false
//            }
//        }
//        return true
//    }

    func midOrder(_ root: TreeNode?, res: inout [Int?]) {
        guard let root = root else { return }
        if (root.left == nil && root.right == nil) {
            res.append(root.val)
            return
        }
        if (root.left == nil) {
            res.append(nil)
        }  else{
            midOrder(root.left, res: &res)
        }

        res.append(root.val)

        if (root.right == nil) {
            res.append(nil)
        }  else{
            midOrder(root.right, res: &res)
        }
    }

    //迭代
    func isSymmetric1(_ root: TreeNode?) -> Bool {
        guard let root = root else { return false }
        guard root.left?.val == root.right?.val else { return false }
        var leftN = [root.left].filter{ $0 != nil}
        var rightN = [root.right].filter{ $0 != nil}

        while leftN.count>0 && rightN.count>0 {
            var ln = [TreeNode?]()
            var rn = [TreeNode?]()
            if leftN.count != rightN.count {
                return false
            }
            for i in 0..<leftN.count {
                if leftN[i]!.left?.val != rightN[leftN.count-1-i]?.right?.val || leftN[i]!.right?.val != rightN[leftN.count-1-i]?.left?.val {
                    return false
                }
                ln.append(leftN[i]!.left)
                ln.append(leftN[i]!.right)

                rn.append(rightN[i]!.left)
                rn.append(rightN[i]!.right)
            }
            leftN = ln.filter{ $0 != nil }
            rightN = rn.filter{ $0 != nil }
        }
        return true
    }

    // 递归优化 (题解)
    func isSymmetric2(_ root: TreeNode?) -> Bool {
        return checkTree(root, root)
    }

    func checkTree(_ l: TreeNode?, _ r: TreeNode?) -> Bool {
        if l == nil && r == nil { return true }
        if l == nil || r == nil { return false }
        return l?.val == r?.val && checkTree(l?.left, r?.right) && checkTree(l?.right, r?.left)
    }
}

//[1,2,2,2,null,2]
//[1,2,2,3,4,4,3]
