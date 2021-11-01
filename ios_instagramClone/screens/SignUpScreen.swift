//
//  SignUpScreen.swift
//  ios_instagramClone
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 25/08/21.
//

import SwiftUI

struct SignUpScreen: View {
    
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewmodel = SignUpViewModel()
    @EnvironmentObject var session: SessionStore
    
    @State var fullname = "Asrbek"
    @State var email = "asrbek@gmail.com"
    @State var password = "12345678"
    @State var cpassword = ""
    @State var isCorrect = true
    
    // email, password validation
    func check(_ password: String, _ email: String) -> Bool {
        // email validation
        let gmail = "@gmail.com"
        var mail = email
        mail.removeLast(10)
        let emailValidation = mail.filter{ $0 == "@"}.count == 0 && mail.filter{ ((33...47).map { String(UnicodeScalar($0)!) } + (58...64).map { String(UnicodeScalar($0)!) } + (91...96).map { String(UnicodeScalar($0)!) }).contains(String($0)) }.isEmpty && email.contains(gmail)
        // password validation
        let characters = (33...63).map { String(UnicodeScalar($0)!) } + (91...96).map { String(UnicodeScalar($0)!) }
        let numbers = (0...9).map { String($0) }
        let uppercased = (65...90).map { String(UnicodeScalar($0)!) }
        let lowercased = (97...122).map { String(UnicodeScalar($0)!) }
        let passwordValidation = password.first!.isUppercase && password.count >= 8 && !password.filter { characters.contains(String($0)) }.isEmpty && !password.filter { numbers.contains(String($0)) }.isEmpty && !password.filter { uppercased.contains(String($0)) }.isEmpty && !password.filter { lowercased.contains(String($0)) }.isEmpty && !password.contains(" ")
        return emailValidation && passwordValidation
    }
    
    func doSignup() {
        self.isCorrect = check(password, email)
        if isCorrect {
            viewmodel.apiSignUp(email: email, password: password, completion: { result in
                if !result {
                    // when error show alert or toast
                } else {
                    var user = User(email: email, displayname: fullname, password: password, imgUser: "")
                    user.uid = session.session?.uid
                    // save user data to firestore
                    viewmodel.apiStoreUser(user: user)
                    presentation.wrappedValue.dismiss()
                }
            })
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Utils.color1, Utils.color2]), startPoint: .bottom, endPoint: .top)
                
                VStack(spacing: 0) {
                    Spacer()
                    Text("app_name")
                        .foregroundColor(.white)
                        .font(Font.custom("Billabong", fixedSize: 45))
                    
                    if !isCorrect {
                        Text("email_password_validation_error")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1.5)
                                    .foregroundColor(Color.red.opacity(0.4))
                            ).padding(.top, 10)
                    }
                    
                    TextField("fullname", text: $fullname)
                        .frame(height: 50)
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4).cornerRadius(8)).padding(.top, 10)
                    
                    TextField("email", text: $email)
                        .frame(height: 50)
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4).cornerRadius(8)).padding(.top, 10)
                    
                    SecureField("password", text: $password)
                        .frame(height: 50)
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4).cornerRadius(8)).padding(.top, 10)
                    
                    SecureField("cpassword", text: $cpassword)
                        .frame(height: 50)
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4).cornerRadius(8)).padding(.top, 10)
                    
                    Button(action: {
                        doSignup()
                    }, label: {
                        Text("sign_up")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1.5)
                                    .foregroundColor(Color.white.opacity(0.4))
                            )
                    }).padding(.top, 10)
                    
                    Spacer()
                    VStack {
                        HStack {
                            Text("already_have_account")
                                .foregroundColor(.white)
                            Button(action: {
                                presentation.wrappedValue.dismiss()
                            }, label: {
                                Text("sign_in").foregroundColor(.white)
                                    .fontWeight(.bold)
                            })
                        }
                    }.frame(maxWidth: .infinity, maxHeight: 70)
                }.padding()
                
                if viewmodel.isLoading {
                    ProgressView()
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
