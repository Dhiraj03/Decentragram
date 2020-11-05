pragma solidity ^0.5.0;
contract Decentragram {
    struct User {
        uint256 id;
        string username;
        address user_address;
        mapping (uint256 => Post) posts;
        mapping (address => Message[]) chats;
    }
    
    struct Post {
        uint256 id;
        string ipfs_hash;
        string caption;
        mapping (address => string) comments;
        mapping (address => bool) likes;
        string time;
    }
    
    struct Message {
        string time;
        string ipfs_hash;
        bool sender;
    }
}