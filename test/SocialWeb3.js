// test/SocialWeb3.test.js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Profile", function () {
  let SocialWeb3;
  let socialWeb3;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy the contract
    SocialWeb3 = await ethers.getContractFactory("SocialWeb3");
    socialWeb3 = await ethers.deployContract("SocialWeb3"); // Ensure the contract is mined
  });

  it("Should create a profile NFT", async function () {
    const profileData = {
      owner: owner.address,
      handle: "test_handle",
      name: "Test Name",
      imageURI: "test_image_uri",
      bio: "Test Bio",
    };

    await socialWeb3.createProfileNFT(profileData);

    // Get the created profile data
    const retrievedProfile = await socialWeb3.getProfileNFTData(1);

    // Verify the created profile data
    expect(retrievedProfile.owner).to.equal(profileData.owner);
    expect(retrievedProfile.handle).to.equal(profileData.handle);
    expect(retrievedProfile.name).to.equal(profileData.name);
    expect(retrievedProfile.imageURI).to.equal(profileData.imageURI);
    expect(retrievedProfile.bio).to.equal(profileData.bio);
  });

  it("Should update a profile", async function () {
    const handle = "test_handle";
    const newName = "Updated Name";
    const newImageURI = "updated_image_uri";

    await socialWeb3.createProfileNFT({
      owner: owner.address,
      handle: handle,
      name: "Test Name",
      imageURI: "test_image_uri",
      bio: "Test Bio",
    });

    // Update the profile
    await socialWeb3.updateProfile(1, {
      owner: owner.address,
      handle: handle,
      name: newName,
      imageURI: newImageURI,
      bio: "Updated Bio",
    });

    // Get the updated profile data
    const updatedProfile = await socialWeb3.getProfileNFTData(1);

    // Verify the updated profile data
    expect(updatedProfile.name).to.equal(newName);
    expect(updatedProfile.imageURI).to.equal(newImageURI);
  });
  it("Should not allow creating a profile with an existing handle", async function () {
    const handle = "test_handle";
    const profileData = {
      owner: owner.address,
      handle: handle,
      name: "Test Name",
      imageURI: "test_image_uri",
      bio: "Test Bio",
    };

    // Create a profile with the given handle
    await socialWeb3.createProfileNFT(profileData);

    // Try to create another profile with the same handle (should fail)
    await expect(socialWeb3.createProfileNFT(profileData)).to.be.revertedWith(
      "Handle already exists"
    );
  });
});

describe("Post", function () {
  let SocialWeb3;
  let socialWeb3;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy the contract
    SocialWeb3 = await ethers.getContractFactory("SocialWeb3");
    socialWeb3 = await ethers.deployContract("SocialWeb3"); // Ensure the contract is mined
  });

  it("Should create a post", async function () {
    const handle = "test_handle";
    const content = "Test content";

    await socialWeb3.createProfileNFT({
      owner: owner.address,
      handle: handle,
      name: "Test Name",
      imageURI: "test_image_uri",
      bio: "Test Bio",
    });

    await socialWeb3.createPost(handle, content);

    // Get the created post
    const retrievedPost = await socialWeb3.getPost(1);

    // Verify the created post
    expect(retrievedPost.handle).to.equal(handle);
    expect(retrievedPost.content).to.equal(content);
  });

  it("Should get profile posts", async function () {
    const handle = "test_handle";
    const content1 = "Test content 1";
    const content2 = "Test content 2";

    await socialWeb3.createProfileNFT({
      owner: owner.address,
      handle: handle,
      name: "Test Name",
      imageURI: "test_image_uri",
      bio: "Test Bio",
    });

    await socialWeb3.createPost(handle, content1);
    await socialWeb3.createPost(handle, content2);

    // Get profile posts
    const profilePosts = await socialWeb3.getProfilePosts(handle);

    // Verify the number of posts and their content
    expect(profilePosts.length).to.equal(2);
    expect(profilePosts[0].content).to.equal(content1);
    expect(profilePosts[1].content).to.equal(content2);
  });
  it("Should not allow creating a post with a non-existing handle", async function () {
    const nonExistingHandle = "non_existing_handle";
    const content = "Test content";

    // Try to create a post with a handle that does not exist (should fail)
    await expect(
      socialWeb3.createPost(nonExistingHandle, content)
    ).to.be.revertedWith("Handle not found");
  });
});
