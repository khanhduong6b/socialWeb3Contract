// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./interfaces/IProfile.sol";

import "./libraries/DataTypes.sol";
import "./libraries/Events.sol";

contract Profile is  Ownable, ERC721Enumerable, IProfile{
     using Strings for uint256;
    /**
        * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
        * token will be the concatenation of the `baseURI` and the `tokenId`.
    */
    string _baseTokenURI;

    constructor(string memory baseURI) ERC721("SocialWeb3", "SW3") {
        _baseTokenURI = baseURI;
    }

    modifier handleAlreadyExists(string calldata _handle){
        require(handleExists[_handle], "Handle not found");
        _;
    }

    modifier isOwner(address _owner) {
        require(_owner == msg.sender, "Owner different from msg.sender");
        _;
    }

    /**
    * @dev _baseURI overrides the Openzeppelin's ERC721 implementation which by default
    * returned an empty string for the baseURI
    */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function updateProfile(uint256 _profileId, ProfileNFTData calldata _newProfileData)
        external virtual override
        onlyOwner
    {
        profileNFTData[_profileId] = _newProfileData;
        emit UpdateProfile(_profileId, _newProfileData);
    }


    function createPost(string calldata _handle, string calldata _content) external {
        if (!handleExists[_handle]) revert Errors.HandleNotFound();
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

    function getPost(uint256 _postId) external view returns (DataTypes.Post memory) {
        return posts[_postId];
    }

    function getProfilePosts(string calldata _handle) external view returns (DataTypes.Post[] memory) {
        uint256 postslength = profilePosts[_handle].length;
        Post[] memory postsTemp = new Post[](postslength);
        for (uint256 i = 0; i < postslength; i++)
            postsTemp[i] = posts[profilePosts[_handle][i]];
        return postsTemp;
    }

    /**
    * @dev tokenURI overrides the Openzeppelin's ERC721 implementation for tokenURI function
    * This function returns the URI from where we can extract the metadata for a given tokenId
    */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        // Here it checks if the length of the baseURI is greater than 0, if it is return the baseURI and attach
        // the tokenId and `.json` to it so that it knows the location of the metadata json file for a given
        // tokenId stored on IPFS
        // If baseURI is empty return an empty string
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }
}