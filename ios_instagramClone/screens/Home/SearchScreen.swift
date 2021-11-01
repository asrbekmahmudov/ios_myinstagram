//
//  SearchScreen.swift
//  ios_instagramClone
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 27/08/21.
//

import SwiftUI

struct SearchScreen: View {
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewmodel = SearchViewModel()
    @State var keyword = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ZStack(alignment: .top) {
                        ScrollView {
                            VStack {}.frame(height: 60)
                            LazyVStack(spacing: 0) {
                                ForEach(viewmodel.items, id: \.self) { item in
                                    if let uid = session.session?.uid {
                                        UserCell(uid: uid, user: item, viewmodel: viewmodel)
                                            .listRowInsets(EdgeInsets())
                                            .buttonStyle(PlainButtonStyle())
                                        Divider().padding(.leading, 15)
                                    }
                                }
                            }
                        }
                        TextField("Search for user", text: $keyword).padding(.leading, 15).padding(.trailing, 15).frame(height: 45).background(Color.white).cornerRadius(10).font(.system(size: 15)).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.5), lineWidth: 0.5)).padding(.leading, 20).padding(.trailing, 20).padding(.top, 15)
                    }
                }
                
                if viewmodel.isLoading {
                    ProgressView()
                }
                
            }.navigationBarTitle("Search", displayMode: .inline)
        }.onAppear {
            if let uid = session.session?.uid {
                viewmodel.apiUserList(uid: uid, keyword: keyword)
            }
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
