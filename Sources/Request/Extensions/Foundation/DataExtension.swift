import Foundation

extension Data {
    /**
     Convert data to String

     - Returns: The computed json String.
     */
    public var toString: String? {
        return String(data: self, encoding: .utf8)
    }

    /**
     JSON Deserialization

     - Returns: Any type.
     */
    public func jsonDeserialization() throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
    }
}

// https://medium.com/@andrea.prearo/working-with-codable-and-core-data-83983e77198e
extension CodingUserInfoKey {
    // Helper property to retrieve the context
    public static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
