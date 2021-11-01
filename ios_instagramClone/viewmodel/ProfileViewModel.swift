
import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var items: [Post] = []
    @Published var following: [User] = []
    @Published var followers: [User] = []
    @Published var email = ""
    @Published var displayName = ""
    @Published var imgUser = ""
    
    func apiPostList(uid: String) {
        isLoading = true
        items.removeAll()

        DatabaseStore().loadPosts(uid: uid, completion: { posts in
            self.items = posts!
            self.isLoading = false
        })
    }
    
    func apiSignOut() {
        SessionStore().signOut()
    }
    
    func apiLoadUser(uid: String) {
        DatabaseStore().loadUser(uid: uid, comletion: { user in
            self.email = (user?.email)!
            self.displayName = (user?.displayName)!
            self.imgUser = (user?.imgUser)!
            self.isLoading = false
        })
    }
    
    func apiUploadMyImage(uid: String, image: UIImage, post: [Post]) {
        isLoading = true
        StorageStore().uploadUserImage(uid: uid, image, completion: { downloadUrl in
            self.apiUpdateMyImage(uid: uid, imgUser: downloadUrl, post: post)
            self.apiLoadUser(uid: uid)
        })
    }
    
    func apiUpdateMyImage(uid: String, imgUser: String?, post: [Post]) {
        DatabaseStore().updateMyImage(uid: uid, imgUser: imgUser, posts: post, followers: followers)
    }
    
    func apiLoadFollowing(uid: String) {
        isLoading = true
        items.removeAll()
        
        DatabaseStore().loadFollowing(uid: uid, completion: { users in
            self.following = users!
            self.isLoading = false
        })
    }
    
    func apiLoadFollowers(uid: String) {
        isLoading = true
        items.removeAll()
        
        DatabaseStore().loadFollowers(uid: uid, completion: { users in
            self.followers = users!
            self.isLoading = false
        })
    }
    
    func apiRemovePost(uid: String, post: Post) {
        DatabaseStore().removeMyPost(uid: uid, post: post, followers: followers)
    }
}
