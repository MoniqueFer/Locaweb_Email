//
//  Dashboard.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 07/09/24.
//

import SwiftUI
import Alamofire


// falta transformar a lista na lista de emails
// fazer a tela de visualizacao de email
// setar o botao do calendario


struct Dashboard: View {
	
	@State var myName : String = ""
	@State var fruits : [String] = [
		"apple", "banana", "pear", "peach", "orange", "Strawberry", "watermellon", "cherry", "melon"]
	
    var body: some View {
	
		NavigationStack {
			ZStack{
				Color.bg.ignoresSafeArea()
				
				VStack{
				
					
					HelloUserSubView(myName: $myName)
					
					
					MailPlusMagnifierSubview()
					
					HScrollview()
					
					
					HStack{
						
						VStack{
							
							NavigationLink {
								WriteMail()
							} label: {
								RoundedRectangle(cornerRadius: 10)
									.fill(Color.myColorBlue)
									.overlay(
										Text("+ \n Novo Email")
											.font(.largeTitle)
											.foregroundStyle(.white)
									)
							}
							
							Button(action: {}, label: {
								RoundedRectangle(cornerRadius: 10)
									.fill(Color.myColorPink)
									.overlay(
										Text("Blá")
											.foregroundStyle(.white)
									)
								
							})
						} .padding(.leading)
						
						List {
							
							Section (header:
										
										HStack {
								
							} 
								.font(.headline)
									 
							) {
								ForEach (fruits, id: \.self) { fruit in
									Text(fruit.capitalized)
										.foregroundStyle(.black)
								}
								
								
								
							}
							
							
						}
						
						.scrollContentBackground(.hidden)
						.background(Color.bg)
						.frame(width: 250)
						.padding(.bottom, 1)
						
					}
					
					
					
					
					
				}
				
				
				//calling the function that calls the API
				.onAppear{
					callAPI()
				}
				
			}
			
			
			.navigationBarHidden(true)
		}

    }
	

	func callAPI() {
		AF.request("http://127.0.0.1:8000/user/monique")
			.responseData { response in
				switch response.result {
				case .success(let data):
					// Print raw data to understand the format
					let dataString = String(data: data, encoding: .utf8) ?? "Dados não disponíveis"
					print("Dados da resposta: \(dataString)")
					
					// Attempt to decode the data
					do {
						let decodedData = try JSONDecoder().decode(MyDataTest.self, from: data)
						print("Nome recebido: \(decodedData.name)")
						self.myName = decodedData.name
					} catch {
						print("Erro ao decodificar dados: \(error.localizedDescription)")
					}
					
				case .failure(let error):
					print("Erro ao chamar a API: \(error.localizedDescription)")
				}
			}
	}

	
	
	
}


#Preview {
    Dashboard()
}

struct HelloUserSubView: View {
	@Binding var myName : String
	
	var body: some View {
		HStack {
			
			NavigationLink(destination: UserPreferences()) {
				Image("profile")
					.padding(.trailing)
			}
			
			Text("Olá, \(myName)")
				.font(.largeTitle)
				.bold()
				.foregroundStyle(Color.white)
			
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal)
		.padding(.vertical, 8)
	}
}

struct MailPlusMagnifierSubview: View {
	var body: some View {
		VStack {
			
			Text("Você tem 12 novos \n emails.")
				.font(.largeTitle)
				.foregroundStyle(Color.white)
				.frame(maxWidth: .infinity, maxHeight: 200, alignment: .topLeading)
				.padding(.leading, 20)
			
			Image(systemName: "magnifyingglass")
				.font(.largeTitle)
				.foregroundStyle(.secondary)
				.bold()
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.horizontal)
			
			
		}
	}
}

struct HScrollview: View {
	var body: some View {
		ScrollView (.horizontal, showsIndicators: false) {
			LazyHGrid(rows: [GridItem(.flexible())], content: {
				
				Button(action: {}, label: {
					Text("Entrada")
						.foregroundStyle(.black)
						.padding()
						.padding(.horizontal)
						.background(
							RoundedRectangle(cornerRadius: 25.0)
								.fill(.white)
						)
				})
				Button(action: {}, label: {
					Text("Saída")
						.foregroundStyle(.black)
						.padding()
						.padding(.horizontal)
						.background(
							RoundedRectangle(cornerRadius: 25.0)
								.fill(.white)
						)
				})
				
				Button(action: {}, label: {
					Text("Rascunhos")						.foregroundStyle(.black)
						.padding()
						.padding(.horizontal)
						.background(
							RoundedRectangle(cornerRadius: 25.0)
								.fill(.white)
						)
				})
				
				Button(action: {}, label: {
					Text("Importantes")						.foregroundStyle(.black)
						.padding()
						.padding(.horizontal)
						.background(
							RoundedRectangle(cornerRadius: 25.0)
								.fill(.white)
						)
				})
			}) .frame(height: 70)
		} .padding(.leading)
	}
}
