
import Foundation

class FeedViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showUserScreen = false
    @Published var items: [Post] = []
    @Published var followers: [User] = []
    
    func apiFeedList(uid: String) {
        isLoading = true
        items.removeAll()
        
        DatabaseStore().loadFeeds(uid: uid, completion: { posts in
            self.items = posts!
            self.isLoading = false
        })
    }
    
    func apiLikePost(uid: String, post: Post) {
        DatabaseStore().likeFeedPost(uid: uid, post: post)
    }
    
    func apiRemovePost(uid: String, post: Post) {
        DatabaseStore().removeMyPost(uid: uid, post: post, followers: followers)
        apiFeedList(uid: uid)
    }
    
    func apiLoadFollowers(uid: String) {
        DatabaseStore().loadFollowers(uid: uid, completion: { users in
            self.followers = users!
        })
    }
}
