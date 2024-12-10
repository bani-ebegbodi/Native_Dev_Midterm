//
//  SignUp.swift
//  Midterm_Project
//
//  Created by Banibe Ebegbodi on 10/9/24.
//

import SwiftUI

struct SignUp: View {
    @State private var username = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    var body: some View {
        VStack {
            Text("Create Account")
                .font(.system(size: 45, design: .rounded))
                .bold()
                .padding(.bottom, 30)
                .gradientForeground(colors: [Color.darkPurple, .purple])
            FormField(fieldName: "Username", fieldValue: $username)
                .padding()
            FormField(fieldName: "Password", fieldValue: $password, isSecure: true)
                .padding()
            FormField(fieldName: "Confirm Password", fieldValue: $passwordConfirm, isSecure: true)
                .padding()
            NavigationLink(destination: Home()){
                Text("SignUp")
                    .font(.system(size: 35, weight: .semibold, design: .rounded))
            }
            .buttonStyle(GradientBackgroundStyle())
            .padding(30)
            
            HStack {
                Text("Already have an account?")
                    .font(.system(.body, design: .rounded))
                    .bold()
                NavigationLink(destination: Login()) {
                    Text("Log In")
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .foregroundColor(Color(red: 251/255, green: 128/255, blue: 128/255))
                }
            }
            
        }
    }
}

struct FormField: View {
    var fieldName = ""
    @Binding var fieldValue: String
    var isSecure = false
    
    var body: some View {
        VStack {
            if isSecure {
                SecureField(fieldName, text: $fieldValue)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .padding(.horizontal)
            } else {
                TextField(fieldName, text: $fieldValue)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .padding(.horizontal)
            }
            
            Divider()
                .frame(height: 1)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .padding(.horizontal)
        }
    }
}

#Preview {
    SignUp().environmentObject(FlashcardSetManager())
}
