//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DataTypes} from './DataTypes.sol';

library Events {
    event CreatePost(DataTypes.Post post);

    event CreateProfileNFT(DataTypes.ProfileNFTData profileNFTData);
    event UpdateProfile(uint256 profileId, DataTypes.ProfileNFTData profileData);
}