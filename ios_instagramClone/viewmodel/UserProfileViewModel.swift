
import Foundation
import SwiftUI

class UserProfileViewModel: ObservableObject {
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
    
    func apiLoadUser(uid: String) {
        DatabaseStore().loadUser(uid: uid, comletion: { user in
            self.email = (user?.email)!
            self.displayName = (user?.displayName)!
            self.imgUser = (user?.imgUser)!
            self.isLoading = false
        })
    }
    
    func apiUploadUserImage(uid: String, image: UIImage, post: [Post]) {
        isLoading = true
        StorageStore().uploadUserImage(uid: uid, image, completion: { downloadUrl in
            self.apiLoadUser(uid: uid)
        })
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
    
    func apiFollowUser(uid: String, to: User) {
        DatabaseStore().loadUser(uid: uid) { me in
            DatabaseStore().followUser(me: me!, to: to) { isFollowed in
               
            }
        }
    }
    
    func apiUnFollowUser(uid: String, to: User) {
        DatabaseStore().loadUser(uid: uid) { me in
            DatabaseStore().unFollowUser(me: me!, to: to) { isFollowed in
                 
            }
        }
    }
    
    func isFolowed(uid: String) -> Bool{
        for follower in followers {
            if uid == follower.uid {
                return true
            }
        }
        return false
    }
    
}

