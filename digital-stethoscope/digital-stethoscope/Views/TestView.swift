//
//  TestView.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/12/25.
//
import SwiftUI


struct TestImageView: View {
    var body: some View {
        Image("portable")
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .border(Color.red)
    }
}

#Preview {
    TestImageView()
}
