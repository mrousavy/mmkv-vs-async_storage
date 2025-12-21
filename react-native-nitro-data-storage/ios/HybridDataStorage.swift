import Foundation
import SwiftData
import NitroModules

/**
 * Swift implementation of NitroDataStorage using SwiftData
 */
public class HybridDataStorage: HybridDataStorageSpec {
  private let manager = DataStorageManager.shared
  
  public var count: Double {
    guard let keys = try? manager.getAllKeys() else {
      return 0
    }
    return Double(keys.count)
  }
  
  public func setItem(key: String, value: Dictionary<String, Any>) throws {
    guard !key.isEmpty else {
      throw RuntimeError.error(withMessage: "Key cannot be empty!")
    }
    
    try manager.setItem(key: key, value: value)
  }
  
  public func getItem(key: String) throws -> Dictionary<String, Any>? {
    return try manager.getItem(key: key)
  }
  
  public func removeItem(key: String) throws -> Bool {
    guard !key.isEmpty else {
      return false
    }
    try manager.removeItem(key: key)
    return true
  }
  
  public func getAllKeys() throws -> [String] {
    return try manager.getAllKeys()
  }
  
  public func clear() throws {
    try manager.clear()
  }
  
  public func contains(key: String) throws -> Bool {
    do {
      let value = try manager.getItem(key: key)
      return value != nil
    } catch {
      return false
    }
  }
}
