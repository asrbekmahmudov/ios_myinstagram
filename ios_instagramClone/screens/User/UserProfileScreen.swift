
import SwiftUI
import SDWebImageSwiftUI

struct UserProfileScreen: View {
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewmodel = UserProfileViewModel()
    @State var user = User()
    var uid: String
    var post: Post
    @State var level = 1
    @State var columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: UIScreen.width - 20), spacing: 10), count: 1)
    
    func postSize() -> CGFloat {
        if level == 1 {
            return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
        } else if level == 2 {
            return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
        }
        return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        VStack {
                            if !viewmodel.imgUser.isEmpty {
                                WebImage(url: URL(string: viewmodel.imgUser)).resizable().clipShape(Circle()).frame(width: 70, height: 70).padding(.all, 2)
                            } else {
                                Image("img_person").resizable().clipShape(Circle()).frame(width: 70, height: 70).padding(.all, 2)
                            }
                        }.overlay(RoundedRectangle(cornerRadius: 37).stroke(Utils.color2, lineWidth: 2))
                        Text(viewmodel.displayName).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium).padding(.top, 5)
                    }
                    Spacer()
                    
                    // post, following, followers counts
                    
                    HStack {
                        VStack {
                            Text(String(viewmodel.items.count)).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium)
                            
                            Text("Posts").foregroundColor(.gray).font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3-25, maxHeight: 60)
                        Divider().frame(height: 25)
                        VStack {
                            Text(String(viewmodel.followers.count)).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium)
                            
                            Text("Followers").foregroundColor(.gray).font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3-35, maxHeight: 60)
                        Divider().frame(height: 25)
                        VStack {
                            Text(String(viewmodel.following.count)).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium)
                            
                            Text("Following").foregroundColor(.gray).font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3-25, maxHeight: 60)
                    }.padding(.top, 10)
                    
                }
                
                // follow, message, call
                
                if uid != post.uid {
                    Button(action: {
                        if user.isFollowed {
                            viewmodel.apiUnFollowUser(uid: uid, to: user)
                        } else {
                            viewmodel.apiFollowUser(uid: uid, to: user)
                        }
                    }, label: {
                        if viewmodel.isFolowed(uid: uid) {
                            Text("Following")
                                .font(.system(size: 15))
                                .foregroundColor(Color.primary)
                                .frame(width: UIScreen.width-20, height: 30)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                        } else {
                            Text("Follow")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(Color.white)
                                .frame(width: UIScreen.width-20, height: 30)
                                .background(Color.blue)
                                .cornerRadius(5)
                        }
                    }).padding(.top, 10)
                }
                
                // Post columns
                
                HStack {
                    Button(action: {
                        self.level = 1
                        self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 1)
                    }, label: {
                        Image(systemName: level == 1 ? "rectangle.grid.1x2.fill" : "rectangle.grid.1x2").resizable().frame(width: 20, height: 17).foregroundColor(.primary)
                    }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                    Button(action: {
                        self.level = 2
                        self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 2)
                    }, label: {
                        Image(systemName: level == 2 ? "rectangle.grid.2x2.fill" : "rectangle.grid.2x2").resizable().frame(width: 20, height: 17).foregroundColor(.primary)
                    }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                    Button(action: {
                        self.level = 3
                        self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 3)
                    }, label: {
                        Image(systemName: level == 3 ? "rectangle.grid.3x2.fill" : "rectangle.grid.3x2").resizable().frame(width: 20, height: 17).foregroundColor(.primary)
                    }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                }.padding(.top, 10).padding(.bottom, 10)
                
                // posts
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewmodel.items, id: \.self) { item in
                            UserPostCell(uid: uid, viewmodel: viewmodel, post: item, length: postSize())
                        }
                    }
                }.padding(.top, 10)
                
            }.padding(10)
            if viewmodel.isLoading {
                ProgressView()
            }
        }.navigationTitle(String(post.displayName!)).onAppear {
            if let uid = session.session?.uid! {
                self.user.isFollowed = viewmodel.isFolowed(uid: uid)
            }
            let uid = post.uid!
            viewmodel.apiLoadUser(uid: uid)
            viewmodel.apiPostList(uid: uid)
            viewmodel.apiLoadFollowing(uid: uid)
            viewmodel.apiLoadFollowers(uid: uid)
        }
    }
}

struct UserProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileScreen(uid: "uid", post: Post(postId: "postId", caption: "caption", imgPost: "caption"))
    }
}
