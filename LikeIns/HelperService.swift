//
//  HelperService.swift
//  LikeIns
//
//  Created by Roy Li on 04/09/2018.
//
import Foundation
import FirebaseStorage
class HelperService {
    
    static func uploadDataToServer(data: Data, videoUrl: URL? = nil, ratio: CGFloat, caption: String, onSuccess: @escaping () -> Void) {
        // Only upload the Image file, and do not deal with the videos
        uploadImageToFirebaseStorage(data: data) { (photoUrl) in
            self.sendDataToDatabase(photoUrl: photoUrl, ratio: ratio, caption: caption, onSuccess: onSuccess)
        }

    }
    
    // rewrite the function and remove the obsoleted function
    static func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String) -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
        
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil{
                ProgressHUD.showError(error!.localizedDescription)
            }
            storageRef.downloadURL{ (url, error) in
                guard let photoUrl = url?.absoluteString else {
                    // Uh-oh, an error occurred!
                    return
                }
                onSuccess(photoUrl)
            }
        }
    }
    
    static func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, caption: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        
        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                word = word.trimmingCharacters(in: CharacterSet.symbols)
                let newHashReference = Api.HashTag.REF_HASHTAG.child(word.lowercased())
                newHashReference.setValue([newPostId: true])
                //                let hashTagsRef = DataService.dataService.BASE_REF.child("hashTags").child(postKey)
                //                let data = ["to": "", "by": "\(DataService.dataService.currentUserId!)", "hashTag": word.lowercased(), "comment": self.captionTextView.text] as [String : Any]
                //                hashTagsRef.setValue(data)
            }
        }
        
        let currentUserId = currentUser.uid
        // let date = Date()
        var dict = ["uid": currentUserId ,"photoUrl": photoUrl, "caption": caption, "likeCount": 0, "ratio": ratio] as [String : Any]

        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId!).setValue(true)
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
}
