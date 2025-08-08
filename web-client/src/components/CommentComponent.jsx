import MiniUserComponent from "./MiniUserComponent";
import CreateCommentComponent from "./CreateCommentComponent";
import ListCommentsComponent from "./ListCommentsComponent";

import './CommentComponent.css';

export default function CommentComponent({ comment }) {

    return (
        <div className="comment-component-container">
            <div className="comment-container">
                <MiniUserComponent userId={comment.authorId} />:
                <p className="content">{comment.content}</p>
            </div>
            <CreateCommentComponent parentId={comment.id} />
            {comment.comments && comment.comments.length > 0 && (
                <div className="replies-container">
                    <ListCommentsComponent comments={comment.comments} parentId={comment.id} />
                </div>
            )}
        </div>
    );
}