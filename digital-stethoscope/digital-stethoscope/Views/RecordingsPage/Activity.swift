//
//  Activity.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/19/25.
//

// TODO: (FOR SHELBY) need to add button that goes back to loading screen to listen for new recordings

// TODO: (FOR SIYA) in this file i think you'll just be reading from firebase then in the session file you'll be writing to firebase
// TODO: (FOR SIYA) just a note I think we should force users to have a device so we don't have to build acct view, I will txt u but adding this here in case I forget


import SwiftUI

// TODO: (FOR SIYA) REPLACE HARDCODED LISTs BELOW WITH FETCH FROM BACKEND
// Pls look at the recordingInfo in the models folder bc there's more that goes into these than what's below and I explain it better there
// replace this with new recordings
// make sure to include the id or it will break
// we'll have to have something in the db to denote whether a session is new or viewed so we can handle this in the backend
let NewRecordings: [RecordingInfo] = [
    RecordingInfo(id: "r1", sessionDate: "5/20/24", sessionTime: "12:59pm", viewed: false),
    RecordingInfo(id: "r2", sessionDate: "5/20/24", sessionTime: "11:02am", viewed: false)
]

// replace this with viewed recordings
let ViewedRecordings: [RecordingInfo] = [
    RecordingInfo(id: "r3", sessionDate: "5/16/24", sessionTime: "3:47pm", viewed: true, sessionTitle: "Shelby Myrman", notes: "wow this heartbeat is soooo awesome I think she is invincible"),
    RecordingInfo(id: "r4", sessionDate: "5/14/24", sessionTime: "8:12am", viewed: true, sessionTitle: "Jack Frost", notes: "his heart is frozen!!!!!! I hope he doesn't die lol"),
]

struct Activity: View {
    @State private var goToLoading = false

    var body: some View {
        NavigationStack {
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
                            RecordingsView(type: "New", recordings: NewRecordings)
                        }

                        if ViewedRecordings.count > 0 {
                            RecordingsView(type: "Viewed", recordings: ViewedRecordings)
                        }
                    }
                    .padding(.top)
                    .background(Color.primary)
                }

                // TODO: (FOR SIYA) so in theory I have this going to the loading page but like idk if we want to do that?? Maybe we just load on this screen instead? idk up to u
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
                Loading()
            }
        }
    }
}

#Preview {
    Activity()
}
