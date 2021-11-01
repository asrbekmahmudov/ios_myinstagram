
import Foundation

struct User: Hashable {
    var uid: String?
    var email: String?
    var displayName: String?
    var password: String?
    var imgUser: String?
    var isFollowed: Bool = false
    
    init() {
        
    }
    
    init(uid: String, email: String?, displayname: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayname
    }
    
    init(email: String?, displayname: String?, password: String?, imgUser: String?) {
        self.email = email
        self.displayName = displayname
        self.password = password
        self.imgUser = imgUser
    }
    
    init(email: String?, displayname: String?, imgUser: String?) {
        self.email = email
        self.displayName = displayname
        self.imgUser = imgUser
    }
    
    init(uid: String, email: String?,displayName: String?, imgUser: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.imgUser = imgUser
    }
    
}
