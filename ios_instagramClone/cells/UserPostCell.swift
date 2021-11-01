
import SwiftUI
import SDWebImageSwiftUI

struct UserPostCell: View {
    
    var uid: String
    var viewmodel: UserProfileViewModel
    @State var showingAlert = false
    var post: Post
    var length: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            WebImage(url: URL(string: post.imgPost!)).resizable().frame(width: length, height: length).scaledToFit()
            
            Text("\(post.caption!)")
                .foregroundColor(Color.black)
                .font(.system(size: 16))
                .padding(.top, 10)
                .padding(.bottom, 10)
                .frame(width: length)
        }
    }
}

struct UserPostCell_Previews: PreviewProvider {
    static var previews: some View {
        UserPostCell(uid: "uid", viewmodel: UserProfileViewModel(), post: Post(caption: "asrbek", imgPost: Utils.image2), length: UIScreen.width)
    }
}
