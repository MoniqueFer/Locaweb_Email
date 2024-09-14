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
	
    var body: some View {
		
		
		ZStack {
			
			Color.bg.ignoresSafeArea()
			
			
			VStack {
				Text("Hello, \(myname)")
				
				
			}
			
			
				.onAppear{
					callAPI()
				}
			
			
		}
		
    }
	
	func callAPI() {
		AF.request("http://127.0.0.1:8000/user/Monique")
			.responseDecodable(of: MyDataTest.self) { response in
				switch response.result {
				case.success(let data):
					DispatchQueue.main.async {
						print(data)
						self.myname = data.name
					}
				case.failure(let error):
					print(error.localizedDescription)
					
				}
			}
	}
	
}




#Preview {
    APITest()
}
