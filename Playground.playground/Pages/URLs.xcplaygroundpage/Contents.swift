import Foundation

let badBaseUrl = URL(string: "https://example.com/v1")! // considered a file
badBaseUrl.absoluteString
let badOperationUrl = URL(string: "/products")! // all part of the filename
let badFullUrl = URL(string: badOperationUrl.path, relativeTo: badBaseUrl)!
print("bad description:\n", badFullUrl) // /products -- https://example.com/v1
print("bad absolute string:\n", badFullUrl.absoluteString) // https://example.com/products

print()

let goodBaseUrl = URL(string: "https://example.com/v1/")! // considered a folder
goodBaseUrl.absoluteString
let goodOperationUrl = URL(string: "products")!
let goodFullUrl = URL(string: goodOperationUrl.path, relativeTo: goodBaseUrl)!
print("good description:\n", goodFullUrl) // products -- https://example.com/v1/
print("good absolute string:\n", goodFullUrl.absoluteString) // https://example.com/v1/products

