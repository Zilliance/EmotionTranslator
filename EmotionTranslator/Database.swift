//
//  Database.swift
//  EmotionTranslator
//
//  Created by Philip Dow on 8/27/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

class StringItem: Object {
    
    dynamic var title: String?
    dynamic var order: Int = 0
    
    class func createNew(title: String) -> Self {
        
        let newItem = self.init()
        newItem.order = -1
        newItem.title = title
        
        Database.shared.add(realmObject: newItem)
        
        return newItem
    }
    
}

class Database {
    static let shared = Database()
    
    private(set) var realm: Realm!
    fileprivate(set) var user: User!
    private(set) var emotionsStored: Results<Emotion>!
    
    init() {
        do {
            
            let config = Realm.Configuration(
                schemaVersion: 13,
                
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                        // Nothing to do!
                        // Realm will automatically detect new properties and removed properties
                        // And will update the schema on disk automatically
                    }
            })
            
            Realm.Configuration.defaultConfiguration = config
            self.realm = try Realm()
            
            let sortProperties = [SortDescriptor(keyPath: "order", ascending: true), SortDescriptor(keyPath: "title", ascending: true)]
            emotionsStored = self.realm.objects(Emotion.self).sorted(by: sortProperties)
            
            if let user = self.realm.objects(User.self).first {
                self.user = user
            }
            else {
                //first time launch, let's prepare the DB
                self.bootstrap()
            }
            
            
        } catch {
            print("realm initialization failed, aborting", error)
        }
    }
    
    fileprivate func bootstrap() {
        self.bootstrapUser()
        self.bootstrapEmotions()
    }
    
    fileprivate func bootstrapUser() {
        guard self.realm.objects(User.self).count == 0 else {
            return
        }
        
        let user = User()
        
        add(realmObject: user)
        
        self.user = user
    }
    
    
    typealias StringData = [String]
    
    fileprivate func parseStringData(fileName: String, itemType: StringItem.Type) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "plist"), let data = NSArray(contentsOfFile: path) as? StringData {
            
            try! realm.write({
                
                data.enumerated().forEach({ offset, StringItem  in
                    //newItemLoaded(offset, StringItem)
                    
                    let newStringItem = itemType.init()
                    newStringItem.title = StringItem
                    newStringItem.order = offset
                    
                    realm.add(newStringItem)
                    
                })
            })
        }
    }

    fileprivate func bootstrapEmotions() {
        
        parseStringData(fileName: "PreloadedEmotions", itemType: Emotion.self)
        
    }
    
}

//realm storage methods
extension Database {
    
    func save(storeLogic: () -> ()) {
        do {
            try realm.write(storeLogic)
        }
        catch let error {
            print(error)
        }
    }
    
    func delete(_ object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        }
        catch let error {
            print(error)
        }
    }
    
    func deleteObjects(_ objects: [Object]) {
        do {
            try realm.write {
                
                objects.forEach({ (object) in
                    realm.delete(object)
                })
            }
        }
        catch let error {
            print(error)
        }
    }
    
    
    func add(realmObject: Object, update: Bool = false) {
        do {
            try realm.write({
                realm.add(realmObject, update: update)
            })
        }
        catch let error {
            print(error)
        }
    }
    
}

