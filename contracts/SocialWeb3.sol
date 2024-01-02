// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Profile.sol";

contract SocialWeb3 is Profile {
    uint256 public postId;
    
    bool public _paused;

    struct Post {
        uint256 postId;
        string handle;
        string content;
        uint256 timestamp;
    }


    mapping(uint256 => Post) private posts;
    mapping(string => uint256[]) private profilePosts;

    
    event CreatePost(Post post);

    constructor(string memory baseURI)
        Profile(baseURI) {
    }


    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

    function createPost(string calldata _handle, string calldata _content) external handleAlreadyExists(_handle) {
        postId++;
        posts[postId] = Post({
            postId: postId,
            handle: _handle,
            content: _content,
            timestamp: block.timestamp
        });
        profilePosts[_handle].push(postId);
        emit CreatePost(posts[postId]);
    }

    function getPost(uint256 _postId) external view returns (Post memory) {
        return posts[_postId];
    }

    function getPostWithNumber(uint256 _number) external view returns (Post[] memory) {
        Post[] memory postsTemp = new Post[](10);
        for (uint256 i = 1; i <= 10; i++) postsTemp[i - 1] = posts[_number + i];
        return postsTemp;
    }

    function getProfilePosts(string calldata _handle) external view returns (Post[] memory) {
        uint256 postslength = profilePosts[_handle].length;
        Post[] memory postsTemp = new Post[](postslength);
        for (uint256 i = 0; i < postslength; i++)
            postsTemp[i] = posts[profilePosts[_handle][i]];
        return postsTemp;
    }


    /**
    * @dev setPaused makes the contract paused or unpaused
        */
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    /**
    * @dev withdraw sends all the ether in the contract
    * to the owner of the contract
        */
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
