//
//  UserPreferences.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 14/09/24.
//
import SwiftUI
import Alamofire


class DarkModeManager: ObservableObject {
	@Published var isDarkMode: Bool = false
	
	func updateDarkMode(from value: Bool) {
		isDarkMode = value
	}
}


struct UserPreferences: View {
	
	@State private var present_full_name: Bool = false
	@Environment(\.dismiss) var dismiss
	@State private var is_dark_mode: Bool = false
	@EnvironmentObject var darkModeManager: DarkModeManager


	var body: some View {
		ZStack {
			Color.bg.ignoresSafeArea()
			
			VStack {
				Text("Preferências")
					.font(.largeTitle)
					.padding()
				
				HStack {
					Toggle("Quer que te chame pelo nome completo?", isOn: $present_full_name)
						.padding()
				}
				
				
				Toggle("Modo Escuro", isOn: $darkModeManager.isDarkMode)
									.padding()
									.onChange(of: darkModeManager.isDarkMode) { newValue in
										
										postAPI(present_full_name: present_full_name, is_dark_mode: newValue)
									}
									.padding()
									.preferredColorScheme(darkModeManager.isDarkMode ? .dark : .light)

				
				Spacer()
				
				Button(action: {
									// Atualiza ambas as preferências na API
									postAPI(present_full_name: present_full_name, is_dark_mode: darkModeManager.isDarkMode)
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
							.onAppear {
								fetchUserPreferences()
							}
						}
					}
	
	func fetchUserPreferences() {
		let url = "http://127.0.0.1:8000/user/monique"
		
		AF.request(url)
			.responseData { response in
				switch response.result {
				case .success(let data):
					do {
						let decodedData = try JSONDecoder().decode(MyDataTest.self, from: data)
						DispatchQueue.main.async {
							present_full_name = decodedData.configs.configs.present_full_name
							
							darkModeManager.updateDarkMode(from: decodedData.configs.configs.is_dark_mode)
						}
					} catch {
						print("Erro ao decodificar dados: \(error.localizedDescription)")
					}
				case .failure(let error):
					print("Erro ao chamar a API: \(error.localizedDescription)")
				}
			}
	}

	
	func postAPI(present_full_name: Bool, is_dark_mode: Bool) {
			let userData: [String: Any] = [
				"configs": [
					"present_full_name": present_full_name,
					"is_dark_mode": is_dark_mode
				]
			]
			
			let url = "http://127.0.0.1:8000/user/monique/configs"
			
			AF.request(url, method: .post, parameters: userData, encoding: JSONEncoding.default)
				.responseJSON { response in
					switch response.result {
					case .success(let value):
						if let jsonResponse = value as? [String: Any],
						   let configs = jsonResponse["configs"] as? [String: Bool] {
							print("Resposta do servidor - present_full_name: \(configs["present_full_name"] ?? false)")
							print("Resposta do servidor - is_dark_mode: \(configs["is_dark_mode"] ?? false)")
							
							// Atualiza o valor global de dark mode
							darkModeManager.updateDarkMode(from: configs["is_dark_mode"] ?? false)
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
		.environmentObject(DarkModeManager())
}
