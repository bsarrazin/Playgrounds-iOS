//: Playground - noun: a place where people can play

import UIKit
import Alamofire
import PlaygroundSupport

var str = "Hello, playground"

request("http://google.com").responseString { (response) in
    print(response)
}

PlaygroundPage.current.needsIndefiniteExecution = true
