//
//  UserPreferences.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 14/09/24.
//

import SwiftUI
import Alamofire

struct UserPreferences: View {
	
	@State var present_full_name : Bool = false
	
	@Environment(\.dismiss) var dismiss
	
	
	var body: some View {
		
		ZStack{
			
			Color.bg.ignoresSafeArea()
			
			VStack{
				
				Text("Preferências")
					.font(.largeTitle)
					.padding()
				
				HStack{
					Toggle("Quer que te chame pelo nome completo?", isOn: $present_full_name)
						.padding()
				}
				
				Spacer()
				
				Button(action: {
					postAPI(present_full_name: present_full_name)
					//dimiss
					dismiss()
					
				}, label: {
					Text("Salvar")
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 25.0)
								.fill(Color.myColorPink)
						)
				})
				
			}
			
		}
		
		
	}
	
	func postAPI(present_full_name: Bool) {
		let userData: [String: Any] = [
			"configs": [
				"present_full_name": present_full_name
			]
		]
		
		if let presentFullNameValue = userData["configs"] as? [String: Bool] {
			print("Dados enviados: \(presentFullNameValue["present_full_name"] ?? false)")
		} else {
			print("Falha ao obter o valor de present_full_name")
		}
		
		let url = "http://127.0.0.1:8000/user/monique/configs"
		
		AF.request(url, method: .post, parameters: userData, encoding: JSONEncoding.default)
			.responseJSON { response in
				switch response.result {
				case .success(let value):
					// Verifique a resposta recebida do servidor
					if let jsonResponse = value as? [String: Any],
					   let configs = jsonResponse["configs"] as? [String: Bool] {
						print("Resposta do servidor - present_full_name: \(configs["present_full_name"] ?? false)")
					} else {
						print("Resposta do servidor: \(value)")
					}
				case .failure(let error):
					print("Erro ao enviar os dados: \(error.localizedDescription)")
				}
			}
	}
}

#Preview {
    UserPreferences()
}
