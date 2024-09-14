//
//  WriteMail.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 08/09/24.
//

import SwiftUI
import EventKitUI
import EventKit

struct WriteMail: View {
	
	@State var destination: String = ""
	@State var subject: String = ""
	@State var mailBody: String = ""
	@State private var showEventEditViewController = false
	@State private var event: EKEvent?
	@State private var store = EKEventStore()
	
	
	var body: some View {
		
		NavigationStack {
			ZStack{
				Color.bg.ignoresSafeArea()
				
				VStack{
					
					TextField("E-mail", text: $destination)
						.padding()
						.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(.white)
						)
						.padding(.horizontal)
					
					TextField("Assunto", text: $subject)
						.padding()
						.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(.white)
						)
						.padding(.horizontal)
					
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
					
					TextEditor(text: $mailBody)
						.padding()
						.background(
						RoundedRectangle(cornerRadius: 25.0))
						.foregroundStyle(.white)
						.padding(.horizontal)
				
					Button(action: {}, label: {
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




#Preview {
	WriteMail()
}
