// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./libraries/DataTypes.sol";
import "./libraries/Events.sol";
import "./libraries/Errors.sol";
import "./Profile.sol";

contract SocialWeb3 {

    uint256 public postId;
    
    bool public _paused;

    mapping(uint256 => address) private profile;
    mapping(uint256 => DataTypes.Post) private posts;
    mapping(string => uint256[]) private profilePosts;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

    /**
    * @dev mint allows an user to mint 1 ProfileNFT per transaction.
    */
    function createProfileNFT(ProfileNFTData calldata _profileNFTData)
        external payable virtual override
        isOwner(_profileNFTData.owner)
    {
        if (!handleExists[_profileNFTData.handle]) revert Errors.HandleNotFound();
        require(msg.value >= _price, "Ether sent is not correct");
        profileId++;
        profileNFTData[profileId] = _profileNFTData;
        userHandles[msg.sender].push(_profileNFTData.handle);
        handleExists[_profileNFTData.handle] = true;
        _safeMint(msg.sender, profileId);
        userProfiles[msg.sender].push(profileId);
        emit CreateProfileNFT(_profileNFTData);
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
