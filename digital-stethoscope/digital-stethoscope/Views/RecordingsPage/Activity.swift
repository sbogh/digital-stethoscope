//
//  Activity.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/19/25.
//

import SwiftUI

struct Activity: View {
    @EnvironmentObject var userProfile: UserProfile
    @State private var NewRecordings: [RecordingInfo] = []
    @State private var ViewedRecordings: [RecordingInfo] = []
    @State private var errorMessage: String?
    @State private var goToLoading = false

    var body: some View {
            VStack {
                ScrollView {
                    VStack(spacing: 5) {
                        Image("Logo")
                            .resizable()
                            .frame(width: 62.46876, height: 87, alignment: .top)
                            .padding(.top)

                        Text("Activity")
                            .font(Font.custom("Roboto-ExtraBold", size: 40).weight(.heavy))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.CTA2)
                            .frame(width: 248, alignment: .top)

                        Text("Unassigned sessions will clear after 24 hours.")
                            .font(Font.custom("Roboto-Regular", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.CTA2)

                        if NewRecordings.count > 0 {
                            RecordingsView(
                            type: "New",
                            recordings: NewRecordings,
                            onPlay: { recording in
                                   if let index = NewRecordings.firstIndex(of: recording) {
                                       var updated = recording
                                       updated.viewed = true
                                       NewRecordings.remove(at: index)
                                       ViewedRecordings.append(updated)
                                   }
                               }
                            )
                        }

                        if ViewedRecordings.count > 0 {
                            RecordingsView(type: "Viewed", recordings: ViewedRecordings)
                        }
                    }
                    .padding(.top)
                    .background(Color.primary)
                }
                .onAppear {
                    Task {
                        await loadRecordings()
                    }
                }
                
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
            }
            .background(Color.primary)
            .navigationDestination(isPresented: $goToLoading) {
                Loading(
                        newRecordings: $NewRecordings,
                        viewedRecordings: $ViewedRecordings,
                        goBack: $goToLoading
                    )
                    .environmentObject(userProfile)
        }
    }
    
    func loadRecordings() async {
        
        do {
            let token = try await getFirebaseToken()
            //print("token recieved")
            let (recordings, error) = await fetchRecordings(token: token)

            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error
                } else {
                    self.NewRecordings = recordings.filter { !$0.viewed }
                    self.ViewedRecordings = recordings.filter { $0.viewed }
                    
                    //print("new recordings: ", NewRecordings)
                    //print("viewed recordings: ", ViewedRecordings)
                }
            }
        } catch {
            self.errorMessage = "Auth error: \(error.localizedDescription)"
        }

    }

    
}

#Preview {
    Activity()
}
