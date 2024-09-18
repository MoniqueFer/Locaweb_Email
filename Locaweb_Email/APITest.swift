//
//  APITest.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 12/09/24.
//

import SwiftUI
import Alamofire



struct APITest: View {
	
	@State var myname: String = ""
	
	@State var fruits : [String] = [
		"apple", "banana", "pear", "peach", "orange", "Strawberry", "watermellon", "cherry", "melon"]
	
	var body: some View {
		
		ZStack {
			
			Color.bg.ignoresSafeArea()
			
			NavigationStack {
				List {
						ForEach (fruits, id: \.self) { fruit in
							Text(fruit.capitalized)
								.foregroundStyle(.black)
						}
				}
				
				
			}
		}
		
	}
}

#Preview {
    APITest()
}
