//
//  Session.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/20/25.
//

// TODO: (FOR SIYA) in this file you're going to write to firebase a lot i think 
import SwiftUI

/*
 This takes in individual recording sessions and displays
 title, notes, date, time, waveform, and play button.
 Title and notes are editable. Once edited we will send
 the title and notes to the database.
 */
struct SessionOverview: View {
    @State private var isExpanded = false
    @State private var editedTitle: String
    @State private var notes: String

    var recording: RecordingInfo
    var defaultTitle: String
    
    @State private var messageTitle = ""
    @State private var successTitle = false

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
                    .onChange(of: editedTitle) { _, newTitle in
                    Task {
                        await changeTitle(recordingID: recording.id, newTitle: newTitle)
                    }
                            //TODO: add more error checking/a message for when there was an error with the update
                    }
                Spacer()
                
                // TODO: (FOR SIYA) when the user engages with this button for the first time, we should mark it as viewed and send that to DB. Or we could do it a different way where if they press the play button we mark it as viewed? Idk but I think going based on this button would be easiest
                Button(action: {
                    
                    withAnimation {
                        isExpanded.toggle()
                    }
                    if recording.viewed == false {
                        
                        Task {
                            await changeView(recordingID: recording.id, viewBool: true)
                        }
                        
                        
                    }
                    
                    
                }) {
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
                // Look at TestWAVPlayback struct in audioplayer file to see correct formatting
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

                TextEditor(text: $notes)
                    .frame(height: 80)
                    .padding(5)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(8)
                    .onChange(of: notes) { _, newNotes in
                        Task {
                            await changeNote(recordingID: recording.id, newNote: newNotes)
                        }
                        
                        //TODO: more robust error checking??
                    }
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
    
    func changeTitle(recordingID: String, newTitle: String) async {
        do {
            let token = try await getFirebaseToken()
            //print("[CHANGE TITLE] Got token: \(token)")
            let (message, success) = await updateRecordingTitle(
                token: token,
                recordingID: recordingID,
                newTitle: newTitle
            )
            //print("[CHANGE TITLE] got response: \(message), \(success)")
            DispatchQueue.main.async {
                if success {
                    print("Title updated: \(message)")
                } else {
                    print("Failed to update: \(message)")

                }
            }
        } catch {
           print("Auth error: \(error.localizedDescription)")
        }
    }
    func changeNote(recordingID: String, newNote: String) async {
        do {
            let token = try await getFirebaseToken()
            //print("[CHANGE Note] Got token: \(token)")
            let (message, success) = await updateRecordingNote(
                token: token,
                recordingID: recordingID,
                newNote: newNote
            )
            //print("[CHANGE NOTE] got response: \(message), \(success)")
            DispatchQueue.main.async {
                if success {
                    print("Note updated: \(message)")
                } else {
                    print("Failed to update: \(message)")

                }
            }
        } catch {
           print("Auth error: \(error.localizedDescription)")
        }
    }
    func changeView(recordingID: String, viewBool: Bool) async {
        do {
            let token = try await getFirebaseToken()
            print("[CHANGE VIEW BOOL] Got token: \(token)")
            let (message, success) = await updateRecordingView(
                token: token,
                recordingID: recordingID,
                viewBool: viewBool)
            print("[CHANGE VIEW BOOL] got response: \(message), \(success)")
            DispatchQueue.main.async {
                if success {
                    print("View Bool updated: \(message)")
                } else {
                    print("Failed to update: \(message)")

                }
            }
        } catch {
           print("Auth error: \(error.localizedDescription)")
        }
    }
}

// This takes in a list of recordings and turns them into sessionoverviews.
// The input for these should be separated into a list of
// viewed sessions and a list of new sessions. Don't input them together
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
