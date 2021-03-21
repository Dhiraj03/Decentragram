pragma solidity ^0.5.0;
contract Decentragram {
    //Structure to represent a user of the network
    struct User {
        //Unique ID for the user
        int256 id;
        string username;
        //The IPFS hash of the display picture of the user
        string dpIpfsHash;
        
        //An array of addresses of the user's friends
        address[] friends;

        //Array of user posts
        Post[] posts;
        uint256 postLength;
        
        //An array of all chats - each chat is represented as the address of the other participant
        address[] interactions;
        //Each chat participant is mapped to a list of messages (custom struct)
        mapping (address => Message[]) chats;
        
    }
    
    struct Post {
        uint256 commentCount;
        string ipfsHash;
        string caption;
        mapping (uint256 => Comment) comments;
        bool isImage;
        address[] likes;
        mapping(address => bool) liked;
        string time;
    }
    
    struct Message {
        string time;
        string ipfsHash;
        bool sender;
    }
    
    struct Comment {
        address userAddress;
        string content;
    }
    
    mapping(address => User) private users;
    int256 public userCount = 0;
    //Allows execution if user does not exist
    modifier checkUserDoesntExists(address userAddress)
    {
        require(users[userAddress].id == 0, "This user already exists.");
        _;
    }
    
    //Allows execution if user exists
    modifier checkUserExists(address userAddress)
    {
        require(users[userAddress].id != 0, "This user doesn't exist.");
        _;
    }
    
    
    modifier checkNotSame(address userAddress, address followAddress) 
    {
        require(userAddress != followAddress, "They are the same users!");
        _;
    }
    
    //Creates a new user profile - username, address and IPFS hash of the profile picture are taken as arguments
    function createProfile(address userAddress, string memory username, string memory dpIpfsHash) public checkUserDoesntExists(userAddress){
        userCount++;
        users[userAddress].id = userCount;
        users[userAddress].username = username;
        users[userAddress].dpIpfsHash = dpIpfsHash;
    }
    
    //Connects two profiles as friends
    function followProfile(address userAddress, address followAddress) public checkUserExists(userAddress) checkUserExists(followAddress) checkNotSame(userAddress, followAddress) {
    users[userAddress].friends.push(followAddress);
    users[followAddress].friends.push(userAddress);
    }
    
    //Retrieves list of friends of a user
    function getFriends(address userAddress) public checkUserExists(userAddress) view returns (address[] memory friends) {
        return users[userAddress].friends;
    }
    
    //Retrieves user details
    function getUserProfile(address userAddress) public checkUserExists(userAddress) view 
    returns (
        int256 id,
        string memory username,
        string memory dpIpfsHash,
        uint256 friendCount,
        uint256 postCount,
        uint256 chatCount
        )
    {
        return (users[userAddress].id, users[userAddress].username, users[userAddress].dpIpfsHash, users[userAddress].friends.length, users[userAddress].posts.length, users[userAddress].interactions.length);
    }
    
    //Checks if two users follow each other
    function doesFollow(address userAddress, address followAddress) public view checkUserExists(userAddress) checkUserExists(followAddress) returns (bool follows)
    {
        for(uint256 i=0;i<users[userAddress].friends.length;i++)
         {
             if(users[userAddress].friends[i] == followAddress)
                return true;
         }
         return false;
    }
    
    //Post Image
    function postImage(address userAddress, string memory ipfsHash, string memory caption, string memory time) public checkUserExists(userAddress) {
        users[userAddress].postLength++;
        address[] memory likes;
        Post memory post = Post({ipfsHash: ipfsHash, caption: caption, commentCount:0,time: time, likes: likes, isImage: true});
        users[userAddress].posts.push(post);
    }
    
    //Upload text-based posts
    function postText(address userAddress, string memory ipfsHash, string memory caption, string memory time) public checkUserExists(userAddress) {
        users[userAddress].postLength++;
        address[] memory likes;
        Post memory post = Post({ipfsHash: ipfsHash, caption: caption, commentCount:0,time: time, likes: likes, isImage: false});
        users[userAddress].posts.push(post);
    }
    
    //Get number of posts
    function getPostCount(address userAddress) public checkUserExists(userAddress) view
    returns (uint256 postCount)
    {
        return users[userAddress].postLength;
    }
    
    //Retrieves details of post
    function getUserPost(address userAddress, uint256 id) public checkUserExists(userAddress)  view
    returns (
        uint256 likeCount,
        uint256 commentCount,
        string memory ipfsHash,
        string memory caption,
        string memory time,
        bool isImage
        )
    {
        return (
            
            users[userAddress].posts[id].likes.length,
            users[userAddress].posts[id].commentCount,
            users[userAddress].posts[id].ipfsHash,
            users[userAddress].posts[id].caption,
            users[userAddress].posts[id].time,
            users[userAddress].posts[id].isImage
            );
    }
    
    //Function to check if a user has already liked a post
    function hasLikedPost(address userAddress, uint256 postID, address followAddress) public view checkUserExists(userAddress) checkUserExists(followAddress) returns (bool hasLiked)
    {
        return users[userAddress].posts[postID].liked[followAddress];
    }
    
    //Function to like a post
    function likePost(address userAddress, uint256 postID, address followAddress) public  checkUserExists(userAddress) checkUserExists(followAddress) {
        users[userAddress].posts[postID].liked[followAddress] = true;
        users[userAddress].posts[postID].likes.push(followAddress);
    }
    
    //Comment on a post - given post ID
    function comment(address userAddress, uint256 postID, address followAddress, string  memory content)public  checkUserExists(userAddress) checkUserExists(followAddress) {
        
        Comment memory _comment = Comment({userAddress: followAddress, content : content});
        users[userAddress].posts[postID].comments[users[userAddress].posts[postID].commentCount] = _comment;
        users[userAddress].posts[postID].commentCount++;
    }
    
    //Retrieves the username and comment of a particulat user - given the post and comment ID
    function getPostComment(address userAddress, uint256 postID, uint256 commentID) public view
    returns (
        string memory _comment,
        string memory username
        )
        {
            return (
                users[userAddress].posts[postID].comments[commentID].content,
                users[users[userAddress].posts[postID].comments[commentID].userAddress].username
                );
        }
    
}
