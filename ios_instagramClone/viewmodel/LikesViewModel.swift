
import Foundation

class LikesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var items: [Post] = []
    @Published var followers: [User] = []
    
    func apiLikesList(uid: String) {
        isLoading = true
        items.removeAll()
        
        DatabaseStore().loadLikes(uid: uid, completion: { posts in
            self.items = posts!
            self.isLoading = false
        })
    }
    
    func apiLikePost(uid: String, post: Post) {
        DatabaseStore().likeFeedPost(uid: uid, post: post)
        apiLikesList(uid: uid)
    }
    
    func apiRemovePost(uid: String, post: Post) {
        self.apiLoadFollowers(uid: uid)
        DatabaseStore().removeMyPost(uid: uid, post: post, followers: followers)
        apiLikesList(uid: uid)
    }
    
    func apiLoadFollowers(uid: String) {
        //isLoading = true
        //items.removeAll()
        
        DatabaseStore().loadFollowers(uid: uid, completion: { users in
            self.followers = users!
            //self.isLoading = false
        })
    }
}
