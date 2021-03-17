pragma solidity ^0.5.0;
contract Decentragram {
    struct User {
        uint256 id;
        uint256 friendCount;
        uint256 postCount;
        uint256 chatCount;
        string username;
        string dpIpfsHash;
        mapping (uint256 => Post) posts;
        mapping (address => Message[]) chats;
        mapping (address => bool) friends;
    }
    
    struct Post {
        uint256 id;
        uint256 likeCount;
        uint256 commentCount;
        string ipfsHash;
        string caption;
        mapping (uint256 => Comment) comments;
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
    uint256 public userCount = 0;
    modifier checkUserDoesntExists(address userAddress)
    {
        require(users[userAddress].id == 0, "This user already exists.");
        _;
    }
    
    modifier checkUserExists(address userAddress)
    {
        require(users[userAddress].id != 0, "This user doesn't exist.");
        _;
    }
    
    function createProfile(address userAddress, string memory username, string memory dpIpfsHash) public checkUserDoesntExists(userAddress){
        userCount++;
        users[userAddress].id = userCount;
        users[userAddress].username = username;
        users[userAddress].dpIpfsHash = dpIpfsHash;
    }
    
    function getUserProfile(address userAddress) public checkUserExists(userAddress) view 
    returns (
        uint256 id,
        string memory username,
        string memory dpIpfsHash
        )
    {
        return (users[userAddress].id, users[userAddress].username, users[userAddress].dpIpfsHash);
    }
    
    function getPostCount(address userAddress) public checkUserExists(userAddress) view
    returns (uint256 postCount)
    {
        return users[userAddress].postCount;
    }
    
    function getUserPost(address userAddress, uint256 id) public checkUserExists(userAddress)  view
    returns (
        uint256 userId,
        uint256 likeCount,
        uint256 commentCount,
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
    
    function getPostComment(address userAddress, uint256 postID, uint256 commentID) public view
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