
import SwiftUI
import SDWebImageSwiftUI

struct FeedPostCell: View {
    
    @EnvironmentObject var session: SessionStore
    @State private var showingAlert = false
    @State private var isSharePresented = false
    @State private var isUserPageOpen = false
    var uid: String
    var viewmodel: FeedViewModel
    @State var post: Post
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack {
                    if !post.imgUser!.isEmpty {
                        WebImage(url: URL(string: post.imgUser!))
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
                    Text(post.displayName!).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium)
                        .onTapGesture {
                            self.isUserPageOpen = true
                        }
                        .background(NavigationLink(isActive: $isUserPageOpen, destination: {UserProfileScreen(uid: uid, post: post)}, label: {}).opacity(0))
                    Text(post.time!).foregroundColor(.gray).font(.system(size: 15))
                }.padding(.leading, 15)
                Spacer()
                
                if uid == post.uid {
                    Image(systemName: "ellipsis")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                        .onTapGesture {
                            self.showingAlert = true
                        }
                        .alert(isPresented: $showingAlert) {
                        return Alert(title: Text("Delete Post"), message: Text("post_delete_permission"), primaryButton: .destructive(Text("Delete"), action: {
                            viewmodel.apiRemovePost(uid: uid, post: post)
                        }), secondaryButton: .cancel())
                        }
                }
            }.padding(.leading, 15)
            .padding(.trailing, 15)
            .padding(.top, 15)
            
            WebImage(url: URL(string: post.imgPost!)).resizable().scaledToFit().padding(.top, 15)
            
            HStack(spacing: 0) {
                VStack {
                    if post.isLiked! {
                        Image(systemName: "heart.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25).foregroundColor(Color.red)
                    } else {
                        Image(systemName: "heart").resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                    }
                }.onTapGesture {
                    if post.isLiked! {
                        post.isLiked = false
                    } else {
                        post.isLiked = true
                    }
                    viewmodel.apiLikePost(uid: uid, post: post)
                }
                Image("ic_share").resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                    .onTapGesture {
                        self.isSharePresented = true
                    }.sheet(isPresented: $isSharePresented, onDismiss: {
                        print("Dismiss")
                    }, content: {
                        ActivityViewController(activityItems: [URL(string: "https://www.apple.com")!])
                    })
                Spacer()
            }.padding(15)
            
            HStack(spacing: 0) {
                Text(post.caption!).foregroundColor(.black).font(.system(size: 16))
                Spacer()
            }.padding(.all, 15)
        }
    }
}

struct FeedPostCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedPostCell(uid: "uid", viewmodel: FeedViewModel(), post: Post(caption: "symbolic", imgPost: Utils.image1))
    }
}
