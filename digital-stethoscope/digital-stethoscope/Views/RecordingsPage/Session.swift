//
//  Session.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/20/25.
//

// TODO: (FOR SIYA) in this file you're going to write to firebase a lot i think 
import SwiftUI

struct SessionOverview: View {
    @State private var isExpanded = false
    @State private var editedTitle: String
    @State private var notes: String

    var recording: RecordingInfo
    var defaultTitle: String

    init(sessionTitle: String, recording: RecordingInfo) {
        self.recording = recording
        self.defaultTitle = sessionTitle
        _editedTitle = State(initialValue: sessionTitle)
        _notes = State(initialValue: recording.notes)
    }
    
    var body: some View {
        VStack {
            HStack {
                // TODO: (FOR SIYA) we need to send the editedTitle to the database. In theory we'll do this once they're done editing, ig we can add a save button tho if needed?
                TextField("Session Title", text: $editedTitle)
                    .font(.custom("Roboto-Medium", size: 18))
                    .foregroundColor(.CTA2)
                Spacer()
                
                // TODO: (FOR SIYA) when the user engages with this button for the first time, we should mark it as viewed and send that to DB. Or we could do it a different way where if they press the play button we mark it as viewed? Idk but I think going based on this button would be easiest
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "xmark" : "chevron.down")
                        .foregroundColor(.CTA2)
                }
            }
            
            HStack {
                Text(recording.sessionTime)
                    .font(
                        Font.custom("Roboto", size: 16)
                    )
                    .foregroundColor(.CTA2)
                Text(recording.sessionDate)
                    .font(
                        Font.custom("Roboto", size: 16)
                    )
                    .foregroundColor(.CTA2)
                Spacer()
            }
            
            if isExpanded {
                Divider()

                // TODO: (FOR SIYA) ok so I tested this and this should work as long as we have the correct data type in here
                if let url = recording.wavFileURL {
                    VStack(alignment: .leading) {
                        AudioPlayerView(wavFileURL: url)
                            .frame(height: 50)
                            .padding(.vertical, 5)
                    }
                    .padding(.bottom)
                    .padding(.top)
                } else {
                    HStack {
                        Text("No audio available.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.bottom, 2)
                }
                
                HStack {
                    Text("Session Notes:")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.CTA2)
                    Spacer()
                }

                // TODO: (FOR SIYA) we need to send the updated notes text to the database. It'd be cool if we could just do this immediately but we could add a save button if needed too
                TextEditor(text: $notes)
                    .frame(height: 80)
                    .padding(5)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(8)
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
                recording.viewed ? SessionOverview(sessionTitle: "Viewed Session", recording: recording) : SessionOverview(sessionTitle: "New Session", recording: recording)
            } else {
                SessionOverview(sessionTitle: recording.sessionTitle, recording: recording)
            }
        }
    }
}
