//
//  SearchBarView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 14/12/2024.
//
import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 8)

            TextField("Search", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
        }
        .frame(height: 40)
    }
}
