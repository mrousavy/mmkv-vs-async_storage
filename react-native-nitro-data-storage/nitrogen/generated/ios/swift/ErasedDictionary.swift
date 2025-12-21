//
//  ErasedDictionary.swift
//  Pods
//
//  Created by Marc Rousavy on 21.12.25.
//

import Foundation

public class ErasedDictionary {
  public typealias bridge = margelo.nitro.storage.bridge.swift
  private var dict: Dictionary<String, Any>
  
  public init() {
    self.dict = Dictionary<String, Any>()
  }
  public init(reservingCapacity: Int) {
    self.dict = Dictionary<String, Any>(minimumCapacity: reservingCapacity)
  }
  public init(jsonData: UnsafeBufferPointer<UInt8>) {
    let data = Data(buffer: jsonData)
    let decoded = try! JSONSerialization.jsonObject(with: data, options: [])
    self.dict = decoded as! Dictionary<String, Any>
  }
  
  internal init(_ dictionary: Dictionary<String, Any>) {
    self.dict = dictionary
  }
  
  public func setDouble(key: String, value: Double) {
    dict[key] = value
  }
  public func setString(key: String, value: String) {
    dict[key] = value
  }
  public func setDoubleArray(key: String, value: [Double]) {
    dict[key] = value
  }
  public func setStringArray(key: String, value: [String]) {
    dict[key] = value
  }
  public func setObject(key: String, value: ErasedDictionary) {
    dict[key] = value.dict
  }
  
  public func getKeys() -> [String] {
    return Array(dict.keys)
  }
  public func getTypeKind(key: String) -> bridge.AnyTypeKind {
    switch dict[key] {
    case is String: return .STRING
    case is Double: return .DOUBLE
    default: fatalError("invalid type!")
    }
  }
  
  public func get(key: String) -> Any? {
    return dict[key]
  }
  public func getDouble(key: String) -> Double {
    return dict[key] as! Double
  }
  public func getString(key: String) -> String {
    return dict[key] as! String
  }
  
  public func getDictionary() -> Dictionary<String, Any> {
    return dict
  }
}
