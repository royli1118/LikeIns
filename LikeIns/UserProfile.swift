//
//  User.swift
//  LikeIns
//
//  Created by Roy Li on 04/09/2018.
//

import Foundation
import Firebase
class UserProfile {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
}

extension UserProfile {
    static func transformUser(dict: [String: Any], key: String) -> UserProfile {
        let user = UserProfile()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.id = key
        return user
    }
}
