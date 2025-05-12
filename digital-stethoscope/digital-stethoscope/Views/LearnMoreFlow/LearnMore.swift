//
//  LearnMore.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/10/25.
//

import SwiftUI

struct LearnMorePage: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let subtitle: String
}

let learnMorePages: [LearnMorePage] = [
    LearnMorePage(title: "Listen with confidence.", imageName: "earIcon", subtitle: "Amplify heart and lung sounds to catch subtle diagnostic clues."),
]

struct LearnMore: View {
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            LoginHeaderView(subtitle: "Don’t miss a beat.")
        }
        
        VStack(spacing: 5) {
            TabView(selection: $currentPage) {
                ForEach(Array(learnMorePages.enumerated()), id: \.offset) { index, page in
                    VStack(spacing: 16) {
                        Text(page.title)
                            .font(.custom("Roboto", size: 30))
                            .fontWeight(.heavy)
                            .foregroundColor(Color.CTA2)
                            .multilineTextAlignment(.center)

                        Image("medHistory")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)

                        Text(page.subtitle)
                            .font(.custom("Roboto", size: 22))
                            .foregroundColor(Color.CTA2)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.navColor)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .tag(index)
                }
                Spacer()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 400)
        }
        Spacer()
    }
}

#Preview {
    LearnMore()
}
