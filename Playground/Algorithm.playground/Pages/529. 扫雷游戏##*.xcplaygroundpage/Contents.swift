//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/minesweeper/

class Solution {


   let dirY:[Int] = [1, 1, -1, -1, 0, 1, 0, -1]
   let dirX:[Int] = [1, -1, 1, -1, 1, 0, -1, 0]


    func updateBoard(_ board: [[Character]], _ click: [Int]) -> [[Character]] {



       var result:[[Character]] = board

       let x = click[0]
       let y = click[1]

       if (result[x][y] == "M") {
           ///规则1
           result[x][y] = "X"
       } else {
           dfs(&result, x: x, y: y)
       }
       return result
    }

   func dfs(_  board: inout [[Character]], x:Int, y:Int) {

       var cnt = 0
       for i in 0..<8 {
           let tx = x + dirX[i];
           let ty = y + dirY[i];

           if (tx < 0 || tx >= board.count || ty < 0 || ty >= board[0].count) {
               continue
           }

           if (board[tx][ty] == "M") {
               cnt+=1
           }
       }

       if (cnt > 0) {
           ///规则3
           board[x][y] = Character.init("\(cnt)")
       }else {
           ///规则2
           board[x][y] = "B"
           for i in 0..<8 {
               let tx = x + dirX[i]
               let ty = y + dirY[i]
               ///这里不需要在存在B的时候继续扩展 因为B之前被点击的时候 已经被扩展过了
               if (tx < 0 || tx >= board.count || ty < 0 || ty >= board[0].count || board[tx][ty] != "E") {
                   continue
               }
            print(tx,ty)
               dfs(&board, x: tx, y: ty)
           }

       }
   }

    func updateBoard1(_ board: [[Character]], _ click: [Int]) -> [[Character]] {
        var result:[[Character]] = board

        let x = click[0]
        let y = click[1]

        if (result[x][y] == "M") {
            ///规则1
            result[x][y] = "X"
        } else {
            bfs(&result, x: x, y: y)
        }
        return result
      }

    func bfs(_ board: inout [[Character]], x:Int, y:Int) {
        var cnt = 0
        var charArr = [(x,y)]
        while !charArr.isEmpty {
            var nCharArr = [(Int, Int)]()
            for char in charArr {
                var nnCharArr = [(Int, Int)]()
                for i in 0..<8 {
                    let tx = char.0 + dirX[i];
                    let ty = char.1 + dirY[i];
                    if (tx < 0 || tx >= board.count || ty < 0 || ty >= board[0].count) {
                        continue
                    }

                    if (board[tx][ty] == "M") {
                        cnt+=1
                    } else if board[tx][ty] == "E" {
                        print(board[tx][ty])
                        if !nCharArr.contains(where: { $0 == (tx,ty) }) {
                            print(tx,ty)
                            nnCharArr.append((tx, ty))
                        }
                    }
                }
                if (cnt > 0) {
                    ///规则3
                    board[char.0][char.1] = Character.init("\(cnt)")
                }else {
                    ///规则2
                    board[char.0][char.1] = "B"
                    nCharArr += nnCharArr
                }
                cnt = 0
            }
            print(nCharArr)
            charArr = nCharArr
        }
    }
}


let input = [["E", "E", "E", "E", "E"],
             ["E", "E", "M", "E", "E"],
             ["E", "E", "E", "E", "E"],
             ["E", "E", "E", "E", "E"]].map{ arr in
                return arr.map { Character($0) }
             }

Solution().updateBoard1(input, [3,0])
