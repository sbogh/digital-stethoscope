//
//  Activity.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/19/25.
//

// TODO: (FOR SHELBY) need to add expanded view of recordings where user can take notes, rename recording, listen to recording, see waveform
// TODO: (FOR SHELBY) need to add button that goes back to loading screen to listen for new recordings


import SwiftUI

struct RecordingInfo: Identifiable {
    let id: String // unique recording ID from database, must be included or it will break
    let sessionDate: String // everything works a lot better if we convert this to string on backend and pass in as string here
    let sessionTime: String // same as above
    var viewed: Bool
    var sessionTitle: String = "" // optional, don't include for new sessions but do include for viewed sessions
    var notes: String = "" // optional
    var wavFileURL: URL? = nil // might need to change
}

// TODO: (FOR SIYA) REPLACE HARDCODED LISTs BELOW WITH FETCH FROM BACKEND
// replace this with new recordings
// make sure to include the id or it will break
// also a note I think we should force users to have a device so we don't have to build acct view, I will txt u but adding this here in case I forget
// we'll have to have something in the db to denote whether a session is new or viewed so we can handle this in the backend
let NewRecordings: [RecordingInfo] = [
    RecordingInfo(id: "r1", sessionDate: "5/20/24", sessionTime: "12:59pm", viewed: false),
    RecordingInfo(id: "r2", sessionDate: "5/20/24", sessionTime: "11:02am", viewed: false)
]

// replace this with viewed recordings
let ViewedRecordings: [RecordingInfo] = [
    RecordingInfo(id: "r3", sessionDate: "5/16/24", sessionTime: "3:47pm", viewed: true, sessionTitle: "Shelby Myrman", notes: "wow this heartbeat is awesome I think she will live forever"),
    RecordingInfo(id: "r4", sessionDate: "5/14/24", sessionTime: "8:12am", viewed: true, sessionTitle: "Jack Frost", notes: "his heart is frozen!!!!!! I hope he doesn't die lol"),
]

struct SessionOverview: View {
    var sessionTitle: String
    var sessionDate: String
    var sessionTime: String
    
    var body: some View {
        VStack {
            HStack {
                Text(sessionTitle)
                    .font(
                        Font.custom("Roboto-Medium", size: 18)
                    )
                    .foregroundColor(.CTA2)
                Spacer()
            }
            
            HStack {
                Text(sessionTime)
                    .font(
                        Font.custom("Roboto", size: 16)
                    )
                    .foregroundColor(.CTA2)
                Text(sessionDate)
                    .font(
                        Font.custom("Roboto", size: 16)
                    )
                    .foregroundColor(.CTA2)
                Spacer()
            }
            
        }
        .frame(maxWidth: 500)
        .padding()
        .background(Color("sessionbg"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("sessionborder"), lineWidth: 1)
        )
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom, 3)
    }
}

struct RecordingsView: View {
    var type: String
    var recordings: [RecordingInfo]
    
    var body: some View {
        HStack {
            Text(type)
                .font(
                    Font.custom("Roboto-ExtraBold", size: 30)
                )
                .foregroundColor(.CTA2)
                .padding(.leading, 30)
                .padding(.top, 10)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        
        
        ForEach(recordings) { recording in
            if recording.sessionTitle == "" {
                recording.viewed ? SessionOverview(sessionTitle: "Viewed Session", sessionDate: recording.sessionDate, sessionTime: recording.sessionTime) : SessionOverview(sessionTitle: "New Session", sessionDate: recording.sessionDate, sessionTime: recording.sessionTime)
            } else {
                SessionOverview(sessionTitle: recording.sessionTitle, sessionDate: recording.sessionDate, sessionTime: recording.sessionTime)
            }
        }
    }
}

struct Activity: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 5) {
                Image("Logo")
                    .resizable()
                    .frame(width: 62.46876, height: 87, alignment: .top)
                    .padding(.top)
                
                Text("Activity")
                    .font(
                        Font.custom("Roboto-ExtraBold", size: 40)
                            .weight(.heavy)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.CTA2)
                    .frame(width: 248, alignment: .top)
                
                Text("Unassigned sessions will clear after 24 hours.")
                    .font(Font.custom("Roboto-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.CTA2)
                    .lineLimit(nil)
                
                if NewRecordings.count > 0 {
                    RecordingsView(type: "New", recordings: NewRecordings)
                }
                
                
                if ViewedRecordings.count > 0 {
                    RecordingsView(type: "Viewed", recordings: ViewedRecordings)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top)
            .background(Color.primary)
        }
        .background(Color.primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    Activity()
}
