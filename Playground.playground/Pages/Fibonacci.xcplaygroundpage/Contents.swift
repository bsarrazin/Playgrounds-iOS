import Foundation

//func fibonacci(_ n: Int) -> [Int] {
//
//    var result: [Int] = []
//    var num1 = 0
//    var num2 = 1
//
//    for _ in 0 ..< n {
//        result.append(num1)
//        let sum = num1 + num2
//        num1 = num2
//        num2 = sum
//    }
//
//    print("result = \(num2)")
//    return result
//}
//fibonacci(7)

func fibonacci(n: Int) -> [Int] {
    
    assert(n > 1)
    
    var array = [0, 1]
    
    while array.count < n {
        array.append(array[array.count - 1] + array[array.count - 2])
    }
    return array
}

fibonacci(n: 10) // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
