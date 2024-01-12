// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DataTypes} from '../libraries/DataTypes.sol';

/**
 * @title ISocialWeb3
 * @author Social Web3
 *
 * @notice This is the standard interface for SocialWeb3.
 */
interface ISocialWeb3{
    function createProfileNFT(DataTypes.ProfileNFTData calldata _profileNFTData) external payable;
    function getAllProfileNFTData() external view returns (DataTypes.ProfileNFTData[] memory);

    function getUserProfiles(address _user) external view returns (uint256[] memory);
    function getProfileNFTData(uint256 _profileId) external view returns (DataTypes.ProfileNFTData memory);
}