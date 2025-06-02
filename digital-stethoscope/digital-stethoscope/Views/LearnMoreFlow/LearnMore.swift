//
//  LearnMore.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/10/25.
//
//  Defines a multi-page onboarding view (`LearnMore`)

import SwiftUI

// MARK: - LearnMorePage Model

/// A model representing a single page in the Learn More flow.

struct LearnMorePage: Identifiable {
    let id = UUID() // Unique identifier for SwiftUI use
    let title: String // Title text shown prominently
    let imageName: String // Name of the image asset to display
    let subtitle: String // Supporting description text
}

// MARK: - Static Page Data

/// Static list of pages shown in the LearnMore TabView.
let learnMorePages: [LearnMorePage] = [
    LearnMorePage(title: "Listen with confidence.", imageName: "earIcon", subtitle: "Amplify heart and lung sounds to catch subtle diagnostic clues."),
    LearnMorePage(title: "Record, replay, reassure.", imageName: "docPlus", subtitle: "Replay sounds for easy collaboration and clear diagnoses."),
    LearnMorePage(title: "Track patient history.", imageName: "medHistory", subtitle: "Save recordings by patient to track changes over time."),
    LearnMorePage(title: "Portable, powerful care.", imageName: "portable", subtitle: "ScopeFace fits in your hand and in your workflow — no extra steps."),
]

// MARK: - LearnMore View

/// A SwiftUI view that presents a swipeable onboarding carousel explaining the app's features.
struct LearnMore: View {
    @State private var currentPage = 0 // Tracks the current page index
    @Environment(\.dismiss) var dismiss // Used to dismiss the view when finished

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                // Reusable login header with subtitle
                LoginHeaderView(subtitle: "Don’t miss a beat.")
                    .padding(.bottom, 20)

                // Main content is swipeable TabView of LearnMorePages
                TabView(selection: $currentPage) {
                    ForEach(Array(learnMorePages.enumerated()), id: \.offset) { index, page in
                        VStack(spacing: 16) {
                            // Card-style content layout
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

                            // Navigation Button: "Next" or "Done"
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
                        .tag(index) // Important for keeping track of which page is currently displayed
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Enables page indicator dots
                .padding(.bottom)
            }

            // Back button in top-left corner
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
            // Customize appearance of the native UIPageControl
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(
                red: 191 / 255,
                green: 191 / 255,
                blue: 191 / 255,
                alpha: 1
            )
        }
    }
}

// MARK: - Preview

#Preview {
    LearnMore()
}
