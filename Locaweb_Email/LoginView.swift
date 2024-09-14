//
//  ContentView.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 05/09/24.
//

import SwiftUI

struct LoginView: View {
	
	@State private var loginField: String = ""
	@State private var passwordField: String = ""
	
    var body: some View {
		
		NavigationStack {
			ZStack {
				Color.bg.ignoresSafeArea()
				
				RoundedRectangle(cornerRadius: 25)
					.fill(Color.myColorGray)
					.frame(maxWidth: .infinity, alignment: .center)
					.padding()
					.padding(.vertical, 80)
				
				
				VStack{
					
					Text("Faça login ou cadastre-se")
						.bold()
						.foregroundStyle(Color.myColorPink)
						.padding(.bottom, 30)
					
					HStack{
						
						TextField("seuemailcomarroba.com", text: $loginField)
							.padding()
						Image("user")
							.padding(.trailing)
					}
					.background(
						RoundedRectangle(cornerRadius: 35)
							.foregroundStyle(.white)
					)
					.shadow(radius: 10, y: 10)
					.padding(.horizontal, 40)
					
					
					.padding(.vertical)
					HStack{
						
						TextField("senha", text: $loginField)
							.padding()
						Image("password")
							.padding(.trailing)
					}
					.background(
						RoundedRectangle(cornerRadius: 35)
							.foregroundStyle(.white)
					)
					.shadow(radius: 10, y: 10)
					.padding(.horizontal, 40)
					
					.padding(.vertical)
					Text("Esqueceu a senha?")
						.underline()
						.foregroundStyle(Color.myColorBlue)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.leading, 45)
					
					
					HStack {
						LinearGradient(
							gradient: 
								Gradient(colors: [Color(#colorLiteral(red: 0.8110429645, green: 0.8110429049, blue: 0.8110429049, alpha: 1)), Color(#colorLiteral(red: 0.1857279539, green: 0.2665883899, blue: 0.3367829919, alpha: 1))]),
							startPoint: .leading,
							endPoint: .trailing)
						
						.padding(.leading, 30)
						.frame(height: 3)
						
						
						Text("Ou entrar com:")
							.font(.caption)
						
						LinearGradient(
							gradient:
								Gradient(colors: [Color(#colorLiteral(red: 0.8110429645, green: 0.8110429049, blue: 0.8110429049, alpha: 1)), Color(#colorLiteral(red: 0.1857279539, green: 0.2665883899, blue: 0.3367829919, alpha: 1))]),
							startPoint: .trailing,
							endPoint: .leading)
							.frame(height: 3)
							.padding(.trailing, 30)

						
					} .padding(.vertical)
					
					HStack{
						Spacer()
						Image("google")
							.padding(.horizontal, 5)
						Image("facebook")
							.padding(.horizontal, 5)
						Image("apple")
							.padding(.horizontal, 5)
						
						Spacer()
					}.padding(.vertical)
					
					
					// need to transform this in a nav link in the future
					// LOOK LOOK LOOK LOOK LOOK LOOK LOOK LOOK LOOK LOOK LOOK LOOK
					
					
					NavigationLink(destination: Dashboard()) {
						HStack{
							Text("ENTRAR")
							Image(systemName: "chevron.right")
						} 	.padding(.vertical, 10)
							.padding(.horizontal, 48)
							.foregroundColor(.white)
							.background(
								RoundedRectangle(cornerRadius: 10.0))
							.foregroundStyle(Color.myColorBlue)
					}
					
					
					HStack {
						Text("Não tem uma conta?")
						Text("Cadastre-se")
							.underline()
						
					}
					.padding(.top, 40)
					.foregroundStyle(Color.myColorPink)
					
					
				}
				
			}
		}
		
    }
}

#Preview {
	LoginView()
}
