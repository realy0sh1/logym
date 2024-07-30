//
//  DonateView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 30.07.24.
//

import SwiftUI
import StoreKit

struct DonateView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Keep Logym alive")
                    .bold()
                    .font(.largeTitle)
                    .padding()
                Text("Logym does not track you and does not show advertisements. If you enjoy using Logym feel free to leave a tip or review. Thanks!")
                    .padding(.horizontal)
                
                #if os(visionOS)
                ProductView(id: "com.timniklasgruel.logym.smallTip") {
                    Image(systemName: "giftcard.fill")
                }
                .padding(.horizontal)
                ProductView(id: "com.timniklasgruel.logym.mediumTip") {
                    Image(systemName: "giftcard.fill")
                }
                .padding(.horizontal)
                ProductView(id: "com.timniklasgruel.logym.hugeTip") {
                    Image(systemName: "giftcard.fill")
                }
                .padding(.horizontal)
                #else
                ProductView(id: "com.timniklasgruel.logym.smallTip") {
                    Image(systemName: "giftcard.fill")
                }
                .productViewStyle(.compact)
                .padding(.horizontal)
                ProductView(id: "com.timniklasgruel.logym.mediumTip") {
                    Image(systemName: "giftcard.fill")
                }
                .productViewStyle(.compact)
                .padding(.horizontal)
                ProductView(id: "com.timniklasgruel.logym.hugeTip") {
                    Image(systemName: "giftcard.fill")
                }
                .productViewStyle(.compact)
                .padding(.horizontal)
                #endif
                
                Spacer()
                
                Button("Review the app") {
                    requestReview()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DonateView()
}
