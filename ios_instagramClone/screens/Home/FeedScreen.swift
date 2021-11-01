//
//  FeedScreen.swift
//  ios_instagramClone
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 27/08/21.
//

import SwiftUI

struct FeedScreen: View {
    @Binding var tabSelection: Int
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewmodel = FeedViewModel()
    @State var post = Post()
    @State var user = User()
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewmodel.items, id: \.self) { item in
                        if let uid = session.session?.uid! {
                            FeedPostCell(uid: uid, viewmodel: viewmodel, post: item).listRowInsets(EdgeInsets())
                        }
                    }
                }.listStyle(PlainListStyle())
                
                if viewmodel.isLoading {
                    ProgressView()
                }
            }.navigationBarItems(trailing:
                                    Button(action: {
                                        self.tabSelection = 2
                                    }, label: {
                                        Image(systemName: "camera").resizable().scaledToFit().frame(width: 25, height: 25)
                                    })
            )
            .navigationBarTitle("Instagram", displayMode: .inline)
        }.onAppear {
            if let uid = session.session?.uid! {
                viewmodel.apiFeedList(uid: uid)
                viewmodel.apiLoadFollowers(uid: uid)
            }
        }
    }
}

struct FeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedScreen(tabSelection: .constant(0))
    }
}
