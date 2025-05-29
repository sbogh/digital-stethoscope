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
    LearnMorePage(title: "Record, replay, reassure.", imageName: "docPlus", subtitle: "Replay sounds for easy collaboration and clear diagnoses."),
    LearnMorePage(title: "Track patient history.", imageName: "medHistory", subtitle: "Save recordings by patient to track changes over time."),
    LearnMorePage(title: "Portable, powerful care.", imageName: "portable", subtitle: "ScopeFace fits in your hand and in your workflow — no extra steps."),
]

struct LearnMore: View {
    @State private var currentPage = 0
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                LoginHeaderView(subtitle: "Don’t miss a beat.")
                    .padding(.bottom, 20)

                TabView(selection: $currentPage) {
                    ForEach(Array(learnMorePages.enumerated()), id: \.offset) { index, page in
                        VStack(spacing: 16) {
                            VStack(spacing: 16) {
                                Text(page.title)
                                    .font(.custom("Roboto", size: 30))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.CTA2)
                                    .multilineTextAlignment(.center)
                                    .accessibilityLabel("LearnMoreTitle")

                                Image(page.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 230)

                                Text(page.subtitle)
                                    .font(.custom("Roboto", size: 22))
                                    .foregroundColor(Color.CTA2)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: 500)
                            .padding()
                            .background(Color.navColor)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)

                            VStack(spacing: 12) {
                                if currentPage < learnMorePages.count - 1 {
                                    Button(action: {
                                        withAnimation {
                                            currentPage += 1
                                        }
                                    }) {
                                        Text("Next")
                                            .font(.custom("Roboto-ExtraBold", size: 22))
                                            .fontWeight(.bold)
                                            .frame(width: 206)
                                            .padding()
                                            .background(Color.CTA1)
                                            .foregroundColor(Color.primary)
                                            .cornerRadius(10)
                                    }
                                } else {
                                    Button(action: {
                                        dismiss()
                                    }) {
                                        Text("Done")
                                            .font(.custom("Roboto-ExtraBold", size: 22))
                                            .fontWeight(.bold)
                                            .frame(width: 206)
                                            .padding()
                                            .background(Color.CTA1)
                                            .foregroundColor(Color.primary)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.top, 8)

                            Spacer(minLength: 0)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .padding(.bottom)
            }

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color.CTA2)
                    .padding()
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(
                red: 191/255,
                green: 191/255,
                blue: 191/255,
                alpha: 1
            )
        }
    }
}

#Preview {
    LearnMore()
}
