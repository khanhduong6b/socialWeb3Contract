// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Profile is  Ownable, ERC721Enumerable{
     using Strings for uint256;
    /**
        * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
        * token will be the concatenation of the `baseURI` and the `tokenId`.
    */
    string _baseTokenURI;

    uint256 public _price = 0.01 ether;


    uint256 public profileId;
    struct ProfileNFTData {
        address owner;
        string handle;
        string name;
        string imageURI;
        string bio;
    }

    mapping(address => uint256[]) private userProfiles;
    mapping(address => string[]) private userHandles;
    mapping(uint256 => ProfileNFTData) private profileNFTData;
    mapping(string => bool) private handleExists;

    event CreateProfileNFT(ProfileNFTData profileNFTData);
    event UpdateProfile(uint256 profileId, ProfileNFTData profileData);

    constructor(string memory baseURI) ERC721("SocialWeb3", "SW3") {
        _baseTokenURI = baseURI;
    }


    modifier handleDoesNotExist(string calldata _handle) {
        require(!handleExists[_handle], "Handle already exists");
        _;
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
    * @dev mint allows an user to mint 1 ProfileNFT per transaction.
    */
    function createProfileNFT(ProfileNFTData calldata _profileNFTData)
        external payable
        handleDoesNotExist(_profileNFTData.handle)
        isOwner(_profileNFTData.owner)
    {
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
    * @dev _baseURI overrides the Openzeppelin's ERC721 implementation which by default
    * returned an empty string for the baseURI
    */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function getAllProfileNFTData() external view returns (ProfileNFTData[] memory)
    {
        ProfileNFTData[] memory temp = new ProfileNFTData[](profileId);
        for (uint256 i = 1; i <= profileId; i++)
            temp[i] = profileNFTData[i];
        return temp;
    }

    function getProfileNFTData(uint256 _profileId) external view returns (ProfileNFTData memory) {
        return profileNFTData[_profileId];
    }

    function getUserProfiles(address _user) external view returns (uint256[] memory) {
        return userProfiles[_user];
    }

    function updateProfile(uint256 _profileId, ProfileNFTData calldata _newProfileData)
        external
        onlyOwner
    {
        profileNFTData[_profileId] = _newProfileData;
        emit UpdateProfile(_profileId, _newProfileData);
    }

    function getUserHandles(address _owner) external view returns (string[] memory){
        return userHandles[_owner];
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