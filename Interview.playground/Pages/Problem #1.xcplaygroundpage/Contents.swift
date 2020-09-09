import Foundation

let baseUrl = URL(string: "https://example.com/v1")!
let operationUrl = URL(string: "/products")!
let fullUrl = URL(string: operationUrl.path, relativeTo: baseUrl)!
print("description:\n", fullUrl)
print("absolute string:\n", fullUrl.absoluteString)

// Can you spot the problem?
// How would you fix it?
