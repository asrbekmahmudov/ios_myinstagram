//
//  UserCell.swift
//  ios_instagramClone
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 08/09/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserCell: View {
    var uid: String
    var user: User
    var viewmodel: SearchViewModel
    @State var post = Post()
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                if !user.imgUser!.isEmpty {
                    WebImage(url: URL(string: user.imgUser!))
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 46, height: 46)
                        .padding(.all, 2)
                } else {
                    Image("img_person")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 46, height: 46)
                        .padding(.all, 2)
                }
            }.overlay(RoundedRectangle(cornerRadius: 25).stroke(Utils.color2, lineWidth: 2))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(user.displayName!).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium)
//                    .background(
//                    NavigationLink(destination: {
//                        ProfileScreen()
//                    }, label: {
//                        Text("ok")
//                    })
//                )
                
                Text(user.email!).foregroundColor(.gray).font(.system(size: 15))
            }.padding(.leading, 15)
            
            Spacer()
            
            Button(action: {
                if user.isFollowed {
                    viewmodel.apiUnFollowUser(uid: uid, to: user)
                } else {
                    viewmodel.apiFollowUser(uid: uid, to: user)
                }
            }, label: {
                if user.isFollowed {
                    Text("Following")
                        .font(.system(size: 15))
                        .foregroundColor(Color.primary)
                        .frame(width: 90, height: 30)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                } else {
                    Text("Follow")
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .frame(width: 90, height: 30)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
            })
        }.padding(.all, 20)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(uid: "uid", user: User(uid: "1", email: "programmer@gmail.com", displayname: "Programmer"), viewmodel: SearchViewModel())
    }
}
