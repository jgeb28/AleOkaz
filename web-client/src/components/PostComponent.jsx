import { useState } from "react";

import MiniUserComponent from "./MiniUserComponent";
import CreateCommentComponent from "./CreateCommentComponent";
import ListCommentsComponent from "./ListCommentsComponent";

import './PostComponent.css';
import backend_url from "../services/backend";

export default function PostComponent({ post }) {
    const [showComments, setShowComments] = useState(false);

    return (
        <div className="post-component-container">
            <MiniUserComponent userId={post.authorId} />
            <p className="post-content">{post.content}</p>
            <img src={backend_url().slice(0,-4)+post.imageUrl.slice(21)} alt={post.title} className="post-image" />
            <div className="post-actions">
                <CreateCommentComponent parentId={post.id} className="post-component-create-comment" />
            </div>
            <div className="post-comments">
                {post.comments && post.comments.length > 0 ? (
                    <>
                        <h3 className="toggle-comments" onClick={() => setShowComments(!showComments)}>Comments</h3>
                        {showComments && <ListCommentsComponent comments={post.comments} parentId={post.id} />}
                    </>
                ) : (
                    <p>No comments yet.</p>
                )}
            </div>
        </div>
    );
}