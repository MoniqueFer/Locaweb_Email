//
//  WriteMail.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 16/09/24.
//

import SwiftUI
import SwiftUI
import EventKitUI
import EventKit
import Alamofire

struct WriteMail: View {
	
	@State var destination: String = ""
	@State var subject: String = ""
	@State var mailBody: String = ""
	@State private var showEventEditViewController = false
	@State private var event: EKEvent?
	@State private var store = EKEventStore()
	@State private var isDarkMode: Bool = false
	@EnvironmentObject var darkModeManager: DarkModeManager
	@State private var showConfirmation = false

	
	var body: some View {
		
		NavigationStack {
			ZStack{
				Color.bg.ignoresSafeArea()
				
				VStack{
					
					
					HStack {
						Text("E-mail:")
							.padding(.leading)
						TextField("E-mail", text: $destination)
							.foregroundStyle(isDarkMode ? .black : .white)
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 10)
									.fill(.white)
							)
							.padding(.horizontal)
					}
					
					HStack {
						Text("Assunto:")
							.padding(.leading)
						TextField("Assunto", text: $subject)
							.foregroundStyle(isDarkMode ? .black : .white)
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 10)
									.fill(.white)
							)
							.padding(.trailing)
							.padding(.leading, 1)
					}
					
					HStack{
						Spacer()
						
						Button(action: {}, label: {
							Text("Adicionar Anexo")
								.foregroundStyle(.black)
								.padding()
								.background(
									RoundedRectangle(cornerRadius: 10)
										.fill(.white)
										.frame(height: 70)
								)
						})
						
						
						Spacer()
						
					} .frame(maxWidth: .infinity)
					
					TextEditor(text: $mailBody)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 25.0)
								.fill(isDarkMode ? Color.black : Color.white)
						)
						.overlay(
							RoundedRectangle(cornerRadius: 25.0)
								.stroke(isDarkMode ? Color.white : Color.gray, lineWidth: 2)
						)
						.foregroundColor(isDarkMode ? Color.white : Color.black)
						.padding(.horizontal)
						.onAppear {
							UITextView.appearance().backgroundColor = .clear
						}
					
					
					Button(action: {
						sendEmail()
					}, label: {
						Text("Enviar")
							.foregroundStyle(.black)
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 20)
									.fill(.white)
							) .frame(maxWidth: .infinity, alignment: .trailing)
							.padding(.horizontal)
					})
					
					
				}
				
				
				
			}
			
			.onAppear {
							fetchUserPreferences()
						}
					}
					.preferredColorScheme(darkModeManager.isDarkMode ? .dark : .light)
					.alert(isPresented: $showConfirmation) {
						Alert(title: Text("E-mail enviado!"), message: Text("Seu e-mail foi enviado com sucesso."), dismissButton: .default(Text("OK")))
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
							self.isDarkMode = decodedData.configs.configs.is_dark_mode
						}
					} catch {
						print("Erro ao decodificar dados: \(error.localizedDescription)")
					}
				case .failure(let error):
					print("Erro ao chamar a API: \(error.localizedDescription)")
				}
			}
	}
	func sendEmail() {
		let newEmail = Email(
			sent_date: Int(Date().timeIntervalSince1970),
			id: UUID().uuidString,
			type: .sent,
			hash: UUID().uuidString,
			to: destination,
			from: "monique.ferrarini@email.com",
			cc: nil,
			subject: subject,
			content: mailBody,
			category: .normal
		)
		
		let url = "http://127.0.0.1:8000/email/send/monique.ferrarini@email.com"
		
		AF.request(url, method: .post, parameters: newEmail, encoder: JSONParameterEncoder.default)
			.response { response in
				switch response.result {
				case .success:
					print("E-mail enviado com sucesso.")
					showConfirmation = true
				case .failure(let error):
					print("Erro ao enviar o e-mail: \(error.localizedDescription)")
				}
			}
	}
	
}

#Preview {
	WriteMail()
		.environmentObject(DarkModeManager())
}

