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
