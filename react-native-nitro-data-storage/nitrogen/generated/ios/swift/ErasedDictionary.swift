//
//  ErasedDictionary.swift
//  Pods
//
//  Created by Marc Rousavy on 21.12.25.
//


public class ErasedDictionary {
  private var dict: Dictionary<String, Any>
  
  public init() {
    self.dict = Dictionary<String, Any>()
  }
  
  internal init(_ dictionary: Dictionary<String, Any>) {
    self.dict = dictionary
  }
  
  func set(key: String, value: Any) {
    dict[key] = value
  }
  func get(key: String) -> Any? {
    return dict[key]
  }
  
  public func getDictionary() -> Dictionary<String, Any> {
    return dict
  }
}
