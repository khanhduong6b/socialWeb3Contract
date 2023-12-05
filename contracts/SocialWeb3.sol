// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SocialWeb3 is Ownable, ERC721Enumerable {
    uint256 public profileId;
    uint256 public postId;

    struct ProfileNFTData {
        address owner;
        string handle;
        string name;
        string imageURI;
        string bio;
    }

    struct Post {
        uint256 postId;
        string handle;
        string content;
        uint256 timestamp;
    }

    mapping(address => uint256[]) private userProfiles;
    mapping(uint256 => ProfileNFTData) public profileNFTData;
    mapping(string => bool) private handleExists;
    mapping(uint256 => Post) public posts;
    mapping(string => uint256[]) profilePosts;

    event CreateProfileNFT(ProfileNFTData profileNFTData);
    event CreatePost(Post post);
    event UpdateProfile(uint256 profileId, ProfileNFTData profileData);

    constructor () ERC721("SocialWeb3", "SW3") {
    }

    function createProfileNFT(ProfileNFTData calldata _profileNFTData) public {
        require(handleExists[_profileNFTData.handle], "Handle already exists");
        require(_profileNFTData.owner == msg.sender, "Owner different from msg.sender");
        profileId++;
        profileNFTData[profileId] = _profileNFTData;
        handleExists[_profileNFTData.handle] = true;
        _mint(_profileNFTData.owner, profileId);
        userProfiles[_profileNFTData.owner].push(profileId);
        emit CreateProfileNFT(_profileNFTData);
    }

    function createPost(string calldata _handle, string calldata _content) public {
        require(!handleExists[_handle], "Handle not found");
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

    function getPost(uint256 _postId) public view returns (Post memory) {
        return posts[_postId];
    }
    
    function getPostWithNumber(uint256 _number) public view returns (Post[] memory) {
        Post[] memory postsTemp = new Post[](10);
        for (uint i=1;i<=10;i++)
        postsTemp[i] = posts[_number+i];
        return postsTemp; 
    }

    function getProfilePosts(string calldata _handle) public view returns (Post[] memory) {
        uint256 postslength= profilePosts[_handle].length;
        Post[] memory postsTemp = new Post[](postslength);
        for (uint i=0;i<postslength;i++)
        postsTemp[i] = posts[profilePosts[_handle][i]];
        return postsTemp; 
    }

    function getProfileNFTData(uint256 _profileId) public view returns (ProfileNFTData memory) {
        return profileNFTData[_profileId];
    }

    function getUserProfiles(address _user) public view returns (uint256[] memory) {
        return userProfiles[_user];
    }

    function updateProfile(uint256 _profileId, ProfileNFTData calldata _newProfileData) public onlyOwner {
        require(_profileId <= profileId, "Invalid profile ID");
        profileNFTData[_profileId] = _newProfileData;

        emit UpdateProfile(_profileId, _newProfileData);
    }
}
