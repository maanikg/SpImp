//
//  LogInSignUp.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-29.
//

private enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

import SwiftUI
struct SignUp: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss

    @FocusState private var focus: FocusableField?
//    let loggingIn: Bool
    //    @Binding var loggingIn:Bool
    @State var username: String = ""
    @State var password:String = ""
    
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                HStack {
                  Image(systemName: "at")
                  TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                      self.focus = .password
                    }
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 4)
                
                HStack {
                  Image(systemName: "lock")
                  SecureField("Password", text: $viewModel.password)
                    .focused($focus, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                      self.focus = .confirmPassword
                    }
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 8)

//                HStack {
//                  Image(systemName: "lock")
//                  SecureField("Confirm password", text: $viewModel.confirmPassword)
//                    .focused($focus, equals: .confirmPassword)
//                    .submitLabel(.go)
//                    .onSubmit {
//                      signUpWithEmailPassword()
//                    }
//                }
//                .padding(.vertical, 6)
//                .background(Divider(), alignment: .bottom)
//                .padding(.bottom, 8)
//
                if !viewModel.errorMessage.isEmpty {
                  VStack {
                    Text(viewModel.errorMessage)
                      .foregroundColor(Color(UIColor.systemRed))
                  }
                }
                //                Button(action: signInWithEmailPassword) {
//                Button(action: {
//
//                }) {
//                    Text("Login")
//                        .padding(.vertical, 8)
//                        .frame(maxWidth: .infinity)
//                    //                  if viewModel.authenticationState != .authenticating {
//                    //                    Text("Login")
//                    //                      .padding(.vertical, 8)
//                    //                      .frame(maxWidth: .infinity)
//                    //                  }
//                    //                  else {
//                    //                    ProgressView()
//                    //                      .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                    //                      .padding(.vertical, 8)
//                    //                      .frame(maxWidth: .infinity)
//                    //                  }
//                }
                Button(action: signUpWithEmailPassword) {
                    if viewModel.authenticationState != .authenticating {
                      Text("Sign up")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                    }
                    else {
                      ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                    }
                }
                .disabled(!viewModel.isValid)
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                
                HStack {
                    Text("Already have an account?")
                    Button(action: {viewModel.switchFlow() }) {
                      Text("Log In")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }
                }
                .padding([.top, .bottom], 50)
                
                Spacer()
//                Divider()
//                    .foregroundColor(.black)
//                Spacer()
//                NavigationLink(destination: HomeScreen().navigationBarBackButtonHidden(true)) {
//                    Image(systemName: "house.fill")
//                    Text("Home Page")
//                }
//                .tint(Color.black.opacity(0.25))
//                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .foregroundColor(Color.black)
            
            
            .padding()
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.black)
            .background(LinearGradient(colors: [Color.green, Color.indigo], startPoint: .top, endPoint: .bottom))
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
            .environmentObject(AuthenticationViewModel())
    }
}
