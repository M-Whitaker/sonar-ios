//
//  SecureTextFieldView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 02/09/2024.
//

import SwiftUI

struct SecureTextField: View {
    @Binding private var prompt: String
    @State private var isSecured: Bool = true
    private var text: String

    init(_ text: String, prompt: Binding<String>) {
        self.text = text
        _prompt = prompt
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(text, text: $prompt)
                } else {
                    TextField(text, text: $prompt)
                }
            }.padding(.trailing, 32)

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}
