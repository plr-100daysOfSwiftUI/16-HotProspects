//
//  Prospect.swift
//  HotProspects
//
//  Created by Paul Richardson on 17.10.2020.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable {
		
	var id = UUID()
	var name = "Anonymous"
	var emailAddress = ""
	fileprivate(set) var isContacted = false

	static func < (lhs: Prospect, rhs: Prospect) -> Bool {
		lhs.name < rhs.name
	}

	static func == (lhs: Prospect, rhs: Prospect) -> Bool {
		lhs.name == rhs.name
	}
	
}

class Prospects: ObservableObject {
	@Published private(set) var people: [Prospect]
	
	static let saveKey = "SavedData"
	
	static var prospectsURL: URL {
		let documentName = "prospects.json"
		return Prospects.getDocumentsDirectory().appendingPathComponent(documentName)
	}
	
	init() {
		if let data = try? Data(contentsOf: Prospects.prospectsURL) {
			if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
				self.people = decoded
				return
			}
		}
		
		self.people = []
	}
	
	func toggle(_ prospect: Prospect) {
		objectWillChange.send()
		prospect.isContacted.toggle()
		save()
	}
	
	private func save() {
		if let encoded = try? JSONEncoder().encode(people) {
			do {
				try encoded.write(to: Prospects.prospectsURL, options: [.atomic])
			} catch {
				print(error.localizedDescription)
			}
		} else {
			print("Error encoding data")
		}
	}
	
	func add(_ prospect: Prospect) {
		people.append(prospect)
		save()
	}
	
	private  static func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
}
