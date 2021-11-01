//
//  LikesScreen.swift
//  ios_instagramClone
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 27/08/21.
//

import SwiftUI

struct LikesScreen: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewmodel = LikesViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewmodel.items, id: \.self) { item in
                        if let uid = session.session?.uid! {
                            LikePostCell(uid: uid, viewmodel: viewmodel, post: item).listRowInsets(EdgeInsets())
                        }
                    }
                }.listStyle(PlainListStyle())
                
                if viewmodel.isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle("Likes", displayMode: .inline)
        }.onAppear {
            if let uid = session.session?.uid! {
                self.viewmodel.apiLikesList(uid: uid)
            }
        }

    }
}

struct LikesScreen_Previews: PreviewProvider {
    static var previews: some View {
        LikesScreen()
    }
}
