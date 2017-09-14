//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let name = "Stephen"
print("Hello " + name + "!")

//integer
var val = 100
val += 100
print("val is \(val)")

var age = 35
print("My name is \(name) and I am \(age) years old!")

//Doubles
var a: Double = 5.76
var b = 8
var c: Float = 5.7
print("The product of \(a) and \(b) is \(a * Double(b))")

//boolean
var d = true

//Array
var array = [3.87, 7.1, 8.9]
print(array)
array.remove(at: 1)
array.append(array[0] * array[1])
print(array)

  //let mixArray = ["Stephen", 35, true]
let stringArray = [String]()

// Dictionary
let menu: [String: Decimal] = ["pizza": 10.99, "cream": 4.99, "salad": 7.00 ]
print("The total cost of my meal is \(menu["pizza"]! + menu["salad"]!)")
