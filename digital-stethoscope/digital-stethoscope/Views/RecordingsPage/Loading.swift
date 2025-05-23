//
//  Loading.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/19/25.
//


// TODO: (FOR SIYA) Once recordings are loaded, we'll want to go to the activity page. We may even want to set some sort of timer that waits like 2 mins if no new recordings are appearing, since it can take a while to get the data from the device? Idk up to you what the best way to handle it is
import SwiftUI

struct Loading: View {
    
    @EnvironmentObject var userProfile: UserProfile
    @Binding var newRecordings: [RecordingInfo]
    @Binding var viewedRecordings: [RecordingInfo]
    @Binding var goBack: Bool
    
    
    var body: some View {
        VStack(spacing: 5) {
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

            Text("Please wait, this can take\n up to 2 minutes.")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)
            
            // TODO: (FOR SIYA) should we leave this spinny thing? i think it looks
            // good but idk if we should choose that or the image
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
    
    func loadAndReturn() async {
        
        
        do {
            let token = try await getFirebaseToken()
            //print(" [LOAD AND RETURN] token recieved")
            let (recordings, error) = await fetchRecordings(token: token)
            //print(" [LOAD AND RETURN]  recordings recieved")
            
            DispatchQueue.main.async {
                if let error = error {
                    print(" [LOAD AND RETURN] Fetch error:", error)
                } else {
                    newRecordings = recordings.filter { !$0.viewed }
                    viewedRecordings = recordings.filter { $0.viewed }
                    goBack = false
                }
            }
            
        } catch {
            print("[LOAD AND RETURN] Auth error:", error.localizedDescription)
        }
    }
}

#Preview {
    Loading(
            newRecordings: .constant([]),
            viewedRecordings: .constant([]),
            goBack: .constant(true)
        )
        .environmentObject(UserProfile())
}
