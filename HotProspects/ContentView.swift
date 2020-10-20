//
//  ContentView.swift
//  HotProspects
//
//  Created by Paul Richardson on 14.10.2020.
//

import SwiftUI

enum SortType {
	case name, dateCreated
}

struct ContentView: View {
		
	@State private var sortBy = SortType.name

	var prospects = Prospects()
	
	var body: some View {
		TabView {
			
			ProspectsView(filter: .none, sortBy: $sortBy)
				.tabItem {
					Image(systemName: "person.3")
					Text("Everyone")
				}

			ProspectsView(filter: .contacted, sortBy: $sortBy)
				.tabItem {
					Image(systemName: "checkmark.circle")
					Text("Contacted")
				}

			ProspectsView(filter: .uncontacted, sortBy: $sortBy)
				.tabItem {
					Image(systemName: "questionmark.diamond")
					Text("Uncontacted")
				}
			
			MeView()
				.tabItem {
					Image(systemName: "person.crop.square")
					Text("Me")
				}
			
		}
		.environmentObject(prospects)
	}
	
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
