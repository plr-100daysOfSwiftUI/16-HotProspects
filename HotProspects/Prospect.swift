//
//  Prospect.swift
//  HotProspects
//
//  Created by Paul Richardson on 17.10.2020.
//

import SwiftUI

class Prospect: Identifiable, Codable {
	var id = UUID()
	var name = "Anonymous"
	var emailAddress = ""
	fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
	@Published private(set) var people: [Prospect]
	
	static let saveKey = "SavedData"
	
	init() {
		if let data = try? Data(contentsOf: Prospects.getProspectsURL()) {
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
				try encoded.write(to: Prospects.getProspectsURL(), options: [.atomic])
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
	
	private static func getProspectsURL() -> URL {
		let documentName = "prospects.json"
		return Prospects.getDocumentsDirectory().appendingPathComponent(documentName)
	}
}
