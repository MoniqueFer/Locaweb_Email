//
//  WriteMail.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 08/09/24.
//

import SwiftUI
import EventKitUI
import EventKit
import Alamofire

struct ReadMail: View {
	
	
	@State private var showEventEditViewController = false
	@State private var event: EKEvent?
	@State private var store = EKEventStore()
	@State private var isDarkMode: Bool = false
	@EnvironmentObject var darkModeManager: DarkModeManager
	let email: Email

	
	var body: some View {
		
		NavigationStack {
			ZStack{
				Color.bg.ignoresSafeArea()
				
				VStack{
					
					
					HStack {
						Text("E-mail:")
							.padding(.leading)
						Text("")
							.foregroundStyle(isDarkMode ? .black : .white)
							.padding()
							.padding(.horizontal)
						
					} .frame(maxWidth: .infinity, alignment: .leading)
					
					HStack {
						Text("Assunto:")
							.padding(.leading)
						Text("")
							.foregroundStyle(isDarkMode ? .black : .white)
							.padding()
					} .frame(maxWidth: .infinity, alignment: .leading)
					
					HStack{
						Spacer()
						
						Button(action: {
							showEventEditViewController = true
						}, label: {
							Text("Adicionar ao Calendário")
								.foregroundStyle(.black)
								.padding()
								.padding(.vertical)
								.background(
									RoundedRectangle(cornerRadius: 10)
										.fill(.white)
										.frame(height: 70)
								)
						})
						.sheet(isPresented: $showEventEditViewController, content: {
							EventEditViewController(event: $event, eventStore: store)
						})
						
						
						Spacer()
						
					} .frame(maxWidth: .infinity)
					
					//					TextEditor(text: $mailBody)
					//						.padding()
					//						.background(
					//						RoundedRectangle(cornerRadius: 25.0))
					//						.foregroundStyle(.white)
					//						.padding(.horizontal)
					
					Text("Este é um email teste")
						.padding()
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

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
					
				}
				
				
				
			}
			
			.onAppear {
				fetchUserPreferences()
			}
		} 
		
		
	}
	
	func addCalendarEvent() {
		let store = EKEventStore()
		
		// Request full access to events
		store.requestFullAccessToEvents { granted, error in
			if let error = error {
				print("Failed to get access: \(error.localizedDescription)")
			} else if granted {
				// Full access granted, proceed with event creation
				let event = EKEvent(eventStore: store)
				event.title = "New Event"
				event.startDate = Date()
				event.endDate = Date().addingTimeInterval(60 * 60) // 1-hour event
				event.calendar = store.defaultCalendarForNewEvents
				
				do {
					try store.save(event, span: .thisEvent)
					print("Event successfully saved")
				} catch {
					print("Error saving event: \(error)")
				}
			} else {
				print("Access was denied.")
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
}


struct EventEditViewController: UIViewControllerRepresentable {
	@Environment(\.dismiss) var dismiss
	@Binding var event: EKEvent?

	let eventStore: EKEventStore
	
	func makeUIViewController(context: Context) -> EKEventEditViewController {
		let controller = EKEventEditViewController()
		
		controller.eventStore = eventStore
		controller.event = event
		controller.editViewDelegate = context.coordinator
		
		return controller
	}
	
	func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
	
	func makeCoordinator() -> Coordinator { return Coordinator (self) }
	
	class Coordinator: NSObject, EKEventEditViewDelegate {
		var parent: EventEditViewController
		
		init(_ controller: EventEditViewController) {
			self.parent = controller
		}
		func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
			parent.dismiss()
		}
	}
}

//#Preview {
//	ReadMail(email: Email(from: any Decoder))
//		.environmentObject(DarkModeManager())
//
//}
