//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/**
 * @title DataTypes
 * @author SocialWeb3
 *
 * @notice A standard library of data types used throughout the SocialWeb3.
 */
library DataTypes {
    struct Post {
        uint256 postId;
        string handle;
        string content;
        uint256 timestamp;
    }
    
    struct ProfileNFTData {
        address owner;
        string handle;
        string name;
        string imageURI;
        string bio;
    }
}
