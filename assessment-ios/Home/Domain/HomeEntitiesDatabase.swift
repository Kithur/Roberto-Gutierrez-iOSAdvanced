//
//  HomeEntitiesDatabase.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 20/04/23.
//

import Foundation
import RealmSwift

class PokemonDatabaseEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var url: String = ""
}
