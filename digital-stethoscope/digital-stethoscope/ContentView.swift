//
//  ContentView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/18/25.
//

import SwiftUI

// Main screen
struct ContentView: View {
    // Variables that help with state management
    @State private var response = ""
    @State private var showNextPage = false

    // core view layout
    var body: some View {
        // manages navigation
        NavigationStack {
            // arranges elements inside it vertically, spacing each by 20
            VStack(spacing: 20) {
                Text("Response: \(response)")
                    .padding()

                Button("Call Backend") {
                    pingBackend()
                }
            }

            // navigates the the next page if showNextPage returns true
            .navigationDestination(isPresented: $showNextPage) {
                SecondView()
            }.padding()
        }
    }

    /// Sends a GET request to the FastAPI backend at `/ping`
    /// and updates the UI with the response message. Navigates
    /// to the next page upon successful response.
    ///
    /// - Note: Updates `response` and `showNextPage` on the main thread.
    func pingBackend() {
        // creates url url from a string (this is the local backend server)
        guard let url = URL(string: "http://127.0.0.1:8000/ping") else { return }

        // starts a background network request to backend
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let result = try? JSONDecoder().decode(PingResponse.self, from: data)
            {
                DispatchQueue.main.async {
                    response = result.message
                    showNextPage = true
                }
            }
        }.resume()
    }

    /// Represents the JSON structure returned by the backend `/ping` route.
    /// Example: {message: "start successful"}
    struct PingResponse: Codable {
        let message: String
    }
}

// second screen
struct SecondView: View {
    var body: some View {
        Text("Hello from the second view!")
            .font(.title)
    }
}

#Preview {
    ContentView()
}
