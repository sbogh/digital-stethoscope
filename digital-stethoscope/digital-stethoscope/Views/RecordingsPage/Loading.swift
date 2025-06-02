//
//  Loading.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/19/25.
//
//  Displays a loading screen while fetching new and viewed
//  recording sessions from the backend. Includes a progress indicator
//  and triggers an asynchronous fetch operation on appear.
//

import SwiftUI

// MARK: - Loading View

/// Displays a loading animation and triggers data fetch for new/viewed recordings
struct Loading: View {
    @EnvironmentObject var userProfile: UserProfile

    /// Bindings for storing fetched recordings and navigation control
    @Binding var newRecordings: [RecordingInfo]
    @Binding var viewedRecordings: [RecordingInfo]
    @Binding var goBack: Bool

    var body: some View {
        VStack(spacing: 5) {
            // MARK: - Logo and Title

            Image("Logo")
                .resizable()
                .frame(width: 62.46876, height: 87, alignment: .top)

            Text("Listening for new recordings.")
                .font(
                    Font.custom("Roboto-ExtraBold", size: 34)
                        .weight(.heavy)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 248, alignment: .top)
                .accessibilityIdentifier("LoadingTitle")

            Text("Please wait, this can take\n up to 2 minutes.")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)

            // MARK: - Spinner and Animation

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.secondary))
                .scaleEffect(2.0, anchor: .center)
                .padding()

            Image("loading")
                .resizable()
                .frame(width: 150,
                       height: 150,
                       alignment: .top)
                .padding(.top)
        }
        .onAppear {
            Task {
                await loadAndReturn()
            }
        }
    }

    // MARK: - loadAndReturn

    /// Loads recordings from backend and updates binding variables
    ///
    /// This function performs the following:
    /// - Waits briefly in test mode to simulate loading delay
    /// - Fetches Firebase authentication token
    /// - Sends token to backend and retrieves recordings
    /// - Updates `newRecordings` and `viewedRecordings`
    /// - Dismisses this view by setting `goBack = false`
    func loadAndReturn() async {
        if isUITestMode() {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
        }

        do {
            let token = try await getFirebaseToken()
            // print(" [LOAD AND RETURN] token recieved")
            let (recordings, error) = await fetchRecordings(token: token)
            // print(" [LOAD AND RETURN]  recordings recieved")

            DispatchQueue.main.async {
                if let error {
                    print(" [LOAD AND RETURN] Fetch error:", error)
                } else {
                    newRecordings = recordings.filter { !$0.viewed }
                    viewedRecordings = recordings.filter(\.viewed)
                    goBack = false
                }
            }

        } catch {
            print("[LOAD AND RETURN] Auth error:", error.localizedDescription)
        }
    }
}

// MARK: - Preview

#Preview {
    Loading(
        newRecordings: .constant([]),
        viewedRecordings: .constant([]),
        goBack: .constant(true)
    )
    .environmentObject(UserProfile())
}
