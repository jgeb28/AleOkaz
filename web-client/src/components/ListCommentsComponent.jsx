import CommentComponent from "./CommentComponent";

import './ListCommentsComponent.css';

export default function ListCommentsComponent({ comments }) {
    return (
        <div className="list-comments-component-container">
            {comments.map(comment => (
                <CommentComponent key={comment.id} comment={comment} />
            ))}
        </div>
    );
}

