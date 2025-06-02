//
//  Activity.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/19/25.
//
//  Displays all user recordings categorized into New and Viewed,
//  and allows loading new sessions from the backend.
//

import SwiftUI

struct Activity: View {
    // MARK: - Environment and State

    @EnvironmentObject var userProfile: UserProfile // Holds user info passed between views

    @State private var NewRecordings: [RecordingInfo] = [] // Recordings that haven't been viewed yet
    @State private var ViewedRecordings: [RecordingInfo] = [] // Recordings already marked as viewed
    @State private var errorMessage: String? = nil // Optional error message from loading
    @State private var goToLoading = false // Controls navigation to loading screen

    // MARK: - Body

    var body: some View {
        VStack {
            // Scrollable area for session data
            ScrollView {
                VStack(spacing: 5) {
                    // App logo
                    Image("Logo")
                        .resizable()
                        .frame(width: 62.46876, height: 87, alignment: .top)
                        .padding(.top)
                        .accessibilityIdentifier("ActivityLogo")

                    // View Title
                    Text("Activity")
                        .font(Font.custom("Roboto-ExtraBold", size: 40).weight(.heavy))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.CTA2)
                        .frame(width: 248, alignment: .top)
                        .accessibilityLabel("ActivityTitle")

                    // Subheading / Info
                    Text("Unassigned sessions will clear after 24 hours.")
                        .font(Font.custom("Roboto-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.CTA2)
                        .accessibilityIdentifier("ActivitySubtitle")

                    // If there are new recordings, show in section
                    if NewRecordings.count > 0 {
                        RecordingsView(
                            type: "New",
                            recordings: NewRecordings,
                            onPlay: { recording in
                                // When a new recording is played, mark it as viewed
                                if let index = NewRecordings.firstIndex(of: recording) {
                                    var updated = recording
                                    updated.viewed = true
                                    NewRecordings.remove(at: index)
                                    ViewedRecordings.append(updated)
                                }
                            }
                        )
                    }

                    // Show viewed recordings section
                    if ViewedRecordings.count > 0 {
                        RecordingsView(type: "Viewed", recordings: ViewedRecordings)
                    }
                }
                .padding(.top)
                .background(Color.primary)
                .accessibilityElement(children: .contain)
            }
            // Load new recordings on view load
            .onAppear {
                if isUITestMode() {
                    // Inject mock data during UI test runs
                    NewRecordings = [RecordingInfo.mock(id: "1", title: "Mock Session", viewed: false)]
                    ViewedRecordings = []
                } else {
                    // Fetch real recordings from backend
                    Task { await loadRecordings() }
                }
            }

            // MARK: - Load New Sessions Button

            Button(action: {
                goToLoading = true
            }) {
                Text("Load New Sessions")
                    .font(Font.custom("Roboto-Bold", size: 18))
                    .padding()
                    .background(Color.CTA1)
                    .foregroundColor(Color.primary)
                    .cornerRadius(12)
                    .padding([.horizontal, .bottom])
            }
            .accessibilityIdentifier("LoadSessionsButton")
        }
        // Root background and navigation config
        .accessibilityElement(children: .contain)
        .background(Color.primary)
        // Navigates to the loading view when triggered
        .navigationDestination(isPresented: $goToLoading) {
            Loading(
                newRecordings: $NewRecordings,
                viewedRecordings: $ViewedRecordings,
                goBack: $goToLoading
            )
            .environmentObject(userProfile)
        }
    }

    // MARK: - Data Fetching

    /// Fetches all recordings for the logged-in user from the backend.
    /// Separates them into viewed and unviewed, updating local state.
    ///
    /// - Note: Requires a valid Firebase ID token for authentication.
    func loadRecordings() async {
        do {
            let token = try await getFirebaseToken()
            // print("token recieved")
            let (recordings, error) = await fetchRecordings(token: token)

            DispatchQueue.main.async {
                if let error {
                    errorMessage = error
                } else {
                    // Partition into viewed vs new
                    NewRecordings = recordings.filter { !$0.viewed }
                    ViewedRecordings = recordings.filter(\.viewed)
                }
            }
        } catch {
            // If Firebase auth fails
            errorMessage = "Auth error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Preview

#Preview {
    Activity().environmentObject(UserProfile())
}
