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
    let id: String // recording ID from database
    let sessionTitle: String // this doesnt exist in db, for now we'll call them untitled but I think we should give user ability to change session name since we're not linking patients
    let sessionDate: String // might need to change data type
    let sessionTime: String // might need to change data type
}

// TODO: (FOR SIYA) REPLACE HARDCODED LISTs BELOW WITH FETCH FROM BACKEND
// replace this with new recordings
// make sure to include the id or it will break
// also a note I think we should force users to have a device so we don't have to build acct view, I will txt u but adding this here in case I forget
let NewRecordings: [RecordingInfo] = [
    RecordingInfo(id: "r1", sessionTitle: "Unassigned Session 2", sessionDate: "5/20/24", sessionTime: "12:59pm"),
    RecordingInfo(id: "r2", sessionTitle: "Unassigned Session 1", sessionDate: "5/20/24", sessionTime: "11:02am")
]

// replace this with viewed recordings
let ViewedRecordings: [RecordingInfo] = [
    RecordingInfo(id: "r3", sessionTitle: "Jane Doe", sessionDate: "5/16/24", sessionTime: "3:47pm"),
    RecordingInfo(id: "r4", sessionTitle: "Jack Frost", sessionDate: "5/14/24", sessionTime: "8:12am"),
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
            SessionOverview(sessionTitle: recording.sessionTitle, sessionDate: recording.sessionDate, sessionTime: recording.sessionTime)
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
