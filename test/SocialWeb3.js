const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SocialWeb3Contract", async function () {
  it("Create NFT Profile successfully", async function () {
    const [owner] = await ethers.getSigners();
    const hardhatToken = await ethers.deployContract("SocialWeb3");
    const profile = await hardhatToken.createProfileNFT([
      owner.address,
      "test",
      "test",
      "test",
      "test",
    ]);

    const ownerBalance = await hardhatToken.balanceOf(owner.address);
    expect(await ownerBalance).to.equal(1);
  });
});

// describe("CCIP test", function () {
//   it("CCIP should be created successfully", async function () {
//     const [owner] = await ethers.getSigners();

//     const hardhatToken = await ethers.deployContract("SocialWeb3");

//     const SourceMinter = await ethers.deployContract("SourceMinter", [
//       "0xd0daae2231e9cb96b94c8512223533293c3693bf",
//       "0x779877A7B0D9E8603169DdbD7836e478b4624789",
//     ]);
//     const DestinationMinter = await ethers.deployContract("DestinationMinter", [
//       "0xeb52e9ae4a9fb37172978642d4c141ef53876f26",
//       "0xdc2CC710e42857672E7907CF474a69B63B93089f",
//     ]);

//     const profile = await SourceMinter.mint(2664363617261496610,msg.sender,);

//   });
// });
