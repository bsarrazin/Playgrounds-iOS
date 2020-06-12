extension Marvel {
    public struct Response<T: Codable>: Codable {
        public var code: Int
        public var status: String
        public var copyright: String
        public var attributionText: String
        public var attributionHTML: String
        public var etag: String
        public var data: Page<T>
    }
}
