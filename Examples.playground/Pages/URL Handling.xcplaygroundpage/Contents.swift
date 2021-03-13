import Foundation
import XCTest

let raw = "https://gd-voiceandmessaging-test-usermedia-us-west-2.s3.us-west-2.amazonaws.com/2qV5ZtBS3SaDEBnm1tnG4H/D898E074-77EB-4DA4-AE37-C4DD8D900C9A?X-Amz-Expires=60&x-amz-security-token=IQoJb3JpZ2luX2VjEKT%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJHMEUCIEJ0W0JULc5Hma1hqafumQs4HOqpRBGpddtWhjM5PypqAiEA8vOYNjvoQzXU1QIbt73V3pBWvUG36jRi0RjwMECp1CcqtAMITRACGgw1MDQyOTg2MjM2NTciDCsxmAs1YrJT9DTiWCqRA8S0rMzPPrZw%2FhWYbLywqv6%2BvYAcjtqhvZZhdG2mbnv%2FCRmrxCKAlqMfCcBGziqO1hm8nbHoNspj62GB6SOXOHHfdN6ntS7mWhMBVYa6R4f71%2BkfItl5EHCBbNGrI99sCbAkDjF%2FsiPpAAa7Rw5C5z1tibwXf%2FpMN3emyRekuHIzgEkSlO2TCxWRxRW%2FYtGtMZhhQis2HsHW3m8HyPChResVVUXBPxaiGig0Q3SYBmqgNQn1wW01%2FHR86OyhyUmrj%2BfYzKxYv%2BDhq31s9gCAzNlbr6xdCXWdRP4QQ0OPK69kI9Eq7rv5PrbZ4mha4ckacHXwzdPx8cPnn%2Fckee4q5TpScQnzNwvGTXIiyp2c4ji0fCNEIghWl93x5FsprgAQFH%2Fh1pHCKmlKmq1%2BOoil21yHsJWjZ%2F5Hv5C8bdeDkElTalPF0OHU7HhjVUE4k8M4kbLbqxcvNeeStcIXdtlEpzsdNPHPPfgCzykqCNJQy4g9Y1Y3iIw6ZHws0twFVFTUSQLxGUKQjzq44Bov9QLd6ik%2BMKKH9P4FOusBo457RAPBUHh5TXOTu2x6gDfYS%2FAz0I%2BFJXvhmOprFM4lTc4q2AQubvEjtpYhuR0sXymUmQKRfBQJVF5N%2F6MBS26EJn3dlvvjT9myGzsL4LItuNBOrWCBoeN7jXNUZbKGC%2BfLMGfLU5qBmV8B49fhvnCvlnmk7JIbhX2ZpeJrQWpv%2BV4Nzboxi2JgcrkWCi1jz7dHIflCraYLNGhHcc4GFtyMhVEr%2FsfG7iwjB79358UUvO2bTNUDLMNV%2BsKqS2ZQqUVmGM8z9jlCg50zowFrp4CJ%2BexXiobnjPczSrR2HrwBbOWFNnV4mFF%2FrQ%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAXK2UKKKUR2GAKXE7/20201218/us-west-2/s3/aws4_request&X-Amz-Date=20201218T195822Z&X-Amz-SignedHeaders=content-length;content-type;host;x-amz-security-token&X-Amz-Signature=360fae1bdbb6af53d5110b779906e292c768f11247f412aad713adbc99b79107"

class URLHandlingTests: XCTestCase {
    func testURL_getsDecoded() throws {

        let components = URLComponents(string: raw)
        XCTAssertEqual(components!.url!.absoluteString, raw)

        let url = URL(string: raw)
        XCTAssertEqual(url!.absoluteString, raw)
    }

    func testDuplicateQueryParams() throws {
        let url = URL(string: "https://www.example.com?param1=foo&param1=bar")!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        for item in components?.queryItems ?? [] {
            print("name: \(item.name), value: \(item.value)")
        }

        print(url.absoluteURL)
        print(url.absoluteString)
    }
}

URLHandlingTests.defaultTestSuite.run()
