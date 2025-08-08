import PostComponent from "./PostComponent";

export default function ListPostsComponent({ posts }) {
    return (
        <div className="list-posts-component-container">
            {posts.map(post => (
                <PostComponent key={post.id} post={post} />
            ))}
        </div>
    );
}