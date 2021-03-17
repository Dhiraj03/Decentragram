pragma solidity ^0.5.0;
contract Decentragram {
    struct User {
        int256 id;
        int256 friendCount;
        int256 postCount;
        int256 chatCount;
        string username;
        string dpIpfsHash;
        mapping (int256 => Post) posts;
        mapping (address => Message[]) chats;
    address[] friends;
    }
    
    struct Post {
        int256 id;
        int256 likeCount;
        int256 commentCount;
        string ipfsHash;
        string caption;
        mapping (int256 => Comment) comments;
        mapping (address => bool) likes;
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
    
    //Creates a new user profile - username, address and IPFS hash of the profile picture are taken as arguments
    function createProfile(address userAddress, string memory username, string memory dpIpfsHash) public checkUserDoesntExists(userAddress){
        userCount++;
        users[userAddress].id = userCount;
        users[userAddress].username = username;
        users[userAddress].dpIpfsHash = dpIpfsHash;
    }
    
    function followProfile(address userAddress, address followAddress) public checkUserExists(userAddress) checkUserExists(followAddress)  {
   
    users[userAddress].friends.push(followAddress);
    users[followAddress].friends.push(userAddress);
    }
    
    function getFriends(address userAddress) public checkUserExists(userAddress) view returns (address[] memory friends) {
        return users[userAddress].friends;
    }
    
    function getUserProfile(address userAddress) public checkUserExists(userAddress) view 
    returns (
        int256 id,
        string memory username,
        string memory dpIpfsHash
        )
    {
        return (users[userAddress].id, users[userAddress].username, users[userAddress].dpIpfsHash);
    }
    
    function getPostCount(address userAddress) public checkUserExists(userAddress) view
    returns (int256 postCount)
    {
        return users[userAddress].postCount;
    }
    
    function getUserPost(address userAddress, int256 id) public checkUserExists(userAddress)  view
    returns (
        int256 userId,
        int256 likeCount,
        int256 commentCount,
        string memory ipfsHash,
        string memory caption,
        string memory time
        )
    {
        return (
            users[userAddress].posts[id].id,
            users[userAddress].posts[id].likeCount,
            users[userAddress].posts[id].commentCount,
            users[userAddress].posts[id].ipfsHash,
            users[userAddress].posts[id].caption,
            users[userAddress].posts[id].time);
    }
    
    function getPostComment(address userAddress, int256 postID, int256 commentID) public view
    returns (
        string memory comment,
        string memory username
        )
        {
            return (
                users[userAddress].posts[postID].comments[commentID].content,
                users[users[userAddress].posts[postID].comments[commentID].userAddress].username
                );
        }
        

    
}