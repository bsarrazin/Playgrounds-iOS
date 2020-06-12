extension Marvel.Response {
    public struct Page<T: Codable>: Codable {
        public var offset: Int
        public var limit: Int
        public var total: Int
        public var count: Int
        public var results: [T]
    }
}
