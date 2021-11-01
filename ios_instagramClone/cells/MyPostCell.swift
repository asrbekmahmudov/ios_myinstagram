
import SwiftUI
import SDWebImageSwiftUI

struct MyPostCell: View {
    
    var uid: String
    var viewmodel: ProfileViewModel
    @State var showingAlert = false
    var post: Post
    var length: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            WebImage(url: URL(string: post.imgPost!)).resizable().frame(width: length, height: length).scaledToFit()
                .onTapGesture {
                    self.showingAlert = true
                    print("hello")
                }
                .actionSheet(isPresented: $showingAlert) {
                    return ActionSheet(title: Text("Delete Post"), message: Text("post_delete_permission"), buttons: [.destructive(Text("Delete")) {
                            viewmodel.apiRemovePost(uid: uid, post: post)
                        }, .cancel()])
                }
//                .alert(isPresented: $showingAlert) {
//                    return Alert(title: Text("Delete Post"), message: Text("post_delete_permission"), primaryButton: .destructive(Text("Delete"), action: {
//                        viewmodel.apiRemovePost(uid: uid, post: post)
//                    }), secondaryButton: .cancel())
//                }
            
            Text("\(post.caption!)")
                .foregroundColor(Color.black)
                .font(.system(size: 16))
                .padding(.top, 10)
                .padding(.bottom, 10)
                .frame(width: length)
        }
    }
}

struct MyPostCell_Previews: PreviewProvider {
    static var previews: some View {
        MyPostCell(uid: "uid", viewmodel: ProfileViewModel(), post: Post(caption: "asrbek", imgPost: Utils.image2), length: UIScreen.width)
    }
}
