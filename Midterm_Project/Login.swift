//
//  Login.swift
//  Midterm_Project
//
//  Created by Banibe Ebegbodi on 10/11/24.
//

import SwiftUI

struct Login: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
            VStack {
                Text("Welcome Back")
                    .font(.system(size: 45, design: .rounded))
                    .bold()
                    .padding(.bottom, 30)
                    .gradientForeground(colors: [Color.darkPurple, .purple])
                FormField(fieldName: "Username", fieldValue: $username)
                    .padding()
                FormField(fieldName: "Password", fieldValue: $password, isSecure: true)
                    .padding(.top)
                    .padding(.horizontal)
                HStack {
                    Spacer()
                    Text("Forgot")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 35)
                NavigationLink (destination: Home()) {
                    Text("Log In")
                        .font(.system(size: 35, weight: .semibold, design: .rounded))
                }
                .buttonStyle(GradientBackgroundStyle())
                .padding(30)
                
                HStack {
                    Text("Don't have an account?")
                        .font(.system(.body, design: .rounded))
                        .bold()
                    NavigationLink(destination: SignUp()) {
                        Text("Sign Up")
                            .font(.system(.body, design: .rounded))
                            .bold()
                            .foregroundColor(Color(red: 251/255, green: 128/255, blue: 128/255))
                    }
                }
        }
    }
}
#Preview {
    Login().environmentObject(FlashcardSetManager())
}
