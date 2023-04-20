//
//  DatabaseManager.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 20/04/23.
//

import Foundation
import RealmSwift
import Combine

enum DatabaseError: Error {
    case databaseNotFound
    case errorWritingToDatabase

    var localizedDescription: String {
        switch self {
        case .databaseNotFound: return "Error opening Realm"
        case .errorWritingToDatabase: return "Error writing to database"
        }
    }
}

protocol DatabaseManagerProtocol {
    func read<T: Object & ObjectKeyIdentifiable>(decodedType: T.Type) -> AnyPublisher<[T], Error>
    func create<T: Object & ObjectKeyIdentifiable>(_ object: T)
}

final class DatabaseManager: DatabaseManagerProtocol {
    private(set) var database: Realm?

    init() {
        openRealm()
    }

    private func openRealm() {
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        do {
            database = try Realm()
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func create<T: Object & ObjectKeyIdentifiable>(_ object: T) {
        guard let database = database else {
            return
        }
        try? database.write {
            database.add(object, update: .all)
        }
    }

    func read<T: Object & ObjectKeyIdentifiable>(decodedType: T.Type) -> AnyPublisher<[T], Error> {
        guard let database = database else {
            return Fail(error: DatabaseError.databaseNotFound)
                .eraseToAnyPublisher()
        }
        let objects = database.objects(decodedType.self)
        var result: [T] = []
        objects.forEach({ result.append($0) })
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


