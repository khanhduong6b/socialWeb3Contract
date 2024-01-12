// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DataTypes} from '../libraries/DataTypes.sol';

/**
 * @title IProfile
 * @author Social Web3
 *
 * @notice This is the standard interface for Profile.
 */
interface IProfile{
    function updateProfile(uint256 _profileId, DataTypes.ProfileNFTData calldata _newProfileData) external;
    function createPost(string calldata _handle, string calldata _content) external;
    function getPost(uint256 _postId) external view returns (DataTypes.Post memory);
    function getProfilePosts() external view returns (DataTypes.Post[] memory);
}