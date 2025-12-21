import Foundation
import SwiftData

/// Manager for Nitro Data Storage using SwiftData
public class DataStorageManager {
    public static let shared = DataStorageManager()
    
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?
    
    private init() {
        setupContainer()
    }
    
    private func setupContainer() {
        do {
            let schema = Schema([NitroDataStorageItem.self])
            // Use a unique database name for NitroDataStorage
            let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                .appendingPathComponent("nitro-data-storage.store")
            
            let modelConfiguration = ModelConfiguration(
                "NitroDataStorage",
                schema: schema,
                url: storeURL,
                allowsSave: true
            )
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer!)
        } catch {
            print("❌ NitroDataStorage: Failed to initialize SwiftData container: \(error)")
        }
    }
    
    private func save() throws {
        guard let context = modelContext else {
            throw NSError(
              domain: "NitroDataStorage",
              code: -1,
              userInfo: [NSLocalizedDescriptionKey: "Model context not initialized"]
            )
        }
        try context.save()
    }
    
    // MARK: - Storage Operations
    
    public func setItem(key: String, value: [String: Any]) throws {
        guard let context = modelContext else {
            throw NSError(
              domain: "NitroDataStorage",
              code: -1,
              userInfo: [NSLocalizedDescriptionKey: "Model context not initialized"]
            )
        }
        
        // Serialize to JSON Data
        guard JSONSerialization.isValidJSONObject(value) else {
            throw NSError(
              domain: "NitroDataStorage",
              code: -2,
              userInfo: [NSLocalizedDescriptionKey: "Value must be a valid JSON object"]
            )
        }
        
        let data = try JSONSerialization.data(withJSONObject: value, options: [])
        
        // Check if item exists
        let descriptor = FetchDescriptor<NitroDataStorageItem>(
            predicate: #Predicate { $0.key == key }
        )
        
        let existingItems = try context.fetch(descriptor)
        
        if let existingItem = existingItems.first {
            // Update existing item
            existingItem.data = data
            existingItem.timestamp = Date()
        } else {
            // Create new item
            let newItem = NitroDataStorageItem(key: key, data: data)
            context.insert(newItem)
        }
        
        try save()
    }
    
    public func getItem(key: String) throws -> [String: Any]? {
        guard let context = modelContext else {
            throw NSError(
              domain: "NitroDataStorage",
              code: -1,
              userInfo: [NSLocalizedDescriptionKey: "Model context not initialized"]
            )
        }
        
        let descriptor = FetchDescriptor<NitroDataStorageItem>(
            predicate: #Predicate { $0.key == key }
        )
        
        let items = try context.fetch(descriptor)
        
        guard let item = items.first else {
            return nil
        }
        
        // Deserialize from JSON Data
        let object = try JSONSerialization.jsonObject(with: item.data, options: [])
        return object as? [String: Any]
    }
    
    public func removeItem(key: String) throws {
        guard let context = modelContext else {
            throw NSError(
              domain: "NitroDataStorage",
              code: -1,
              userInfo: [NSLocalizedDescriptionKey: "Model context not initialized"]
            )
        }
        
        let descriptor = FetchDescriptor<NitroDataStorageItem>(
            predicate: #Predicate { $0.key == key }
        )
        
        let items = try context.fetch(descriptor)
        
        for item in items {
            context.delete(item)
        }
        
        try save()
    }
    
    public func getAllKeys() throws -> [String] {
        guard let context = modelContext else {
            throw NSError(
              domain: "NitroDataStorage",
              code: -1,
              userInfo: [NSLocalizedDescriptionKey: "Model context not initialized"]
            )
        }
        
        let descriptor = FetchDescriptor<NitroDataStorageItem>()
        let items = try context.fetch(descriptor)
        
        return items.map { $0.key }
    }
    
    public func clear() throws {
        guard let context = modelContext else {
            throw NSError(
              domain: "NitroDataStorage",
              code: -1,
              userInfo: [NSLocalizedDescriptionKey: "Model context not initialized"]
            )
        }
        
        let descriptor = FetchDescriptor<NitroDataStorageItem>()
        let items = try context.fetch(descriptor)
        
        for item in items {
            context.delete(item)
        }
        
        try save()
    }
}
