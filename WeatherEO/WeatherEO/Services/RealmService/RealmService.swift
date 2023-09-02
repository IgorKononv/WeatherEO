//
//  RealmService.swift
//
//  Created by Igor Kononov on 08.07.2023.
//

import Foundation
import RealmSwift

final class RealmService {
    private init() {}
    static let shared = RealmService()
    
    private var realm = try! Realm()
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error)
        }
    }
    
    func readAll<T: Object>(_ object: T.Type) -> Results<T> {
        realm.objects(object)
    }
    
    func read<T: Object>(_ object: T.Type, id: String) -> T? {
        realm.object(ofType: object, forPrimaryKey: id)
    }
}
