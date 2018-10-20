
//
//  HomeTableViewCell.swift
//  LikeIns
//
//  Created by Roy Li on 04/09/2018.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseCore

protocol HomeTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var heightConstraintPhoto: NSLayoutConstraint!
    
    var delegate: HomeTableViewCellDelegate?
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: UserProfile? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        captionLabel.text = post?.caption
        if let ratio = post?.ratio {
            heightConstraintPhoto.constant = UIScreen.main.bounds.width / ratio
            layoutIfNeeded()
            
        }
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        
        self.updateLike(post: self.post!)
    }
    
    func updateLike(post: Post) {
        
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        guard let people = post.likes else {
            return
        }
        var wholikeLabel : String = ""
        for eachPeople in people {
            Api.User.observeUser(withId: eachPeople.key, completion: {
                user in
                    wholikeLabel.append(user.username!)
            })
            
        }
        if count != 0 {
            likeCountButton.setTitle("\(count) likes \(wholikeLabel)", for: UIControl.State.normal)
        } else {
            likeCountButton.setTitle("Be the first like this", for: UIControl.State.normal)
        }
        
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        
    }
    
    
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    
    @objc func likeImageView_TouchUpInside() {
        Api.Post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
        
    }
    
    @objc func commentImageView_TouchUpInside() {
        print("commentImageView_TouchUpInside")
        if let id = post?.id {
            delegate?.goToCommentVC(postId: id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
