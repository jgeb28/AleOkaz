export default function ReactionsComponent({ reactions }) {
    return (
        <div className="reactions-component-container">
            <p className="reactions-likes">
                {reactions.likes} Likes
            </p>
            <p className="reactions-wows">
                {reactions.wows} Wows
            </p>
            <p className="reactions-hearts">
                {reactions.hearts} Hearts
            </p>
            <p className="reactions-laughs">
                {reactions.laughs} Laughs
            </p>
            <p className="reactions-fish">
                {reactions.fish} Fish
            </p>
            <p className="user-reaction">
                Your reaction: {reactions.userReaction || "None"}
            </p>
        </div>
    );
}