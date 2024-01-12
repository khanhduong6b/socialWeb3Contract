/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });
// Go to https://alchemy.com, sign up, create a new App in
// its dashboard, and replace "KEY" with its key

const QUICKNODE_HTTP_URL = process.env.QUICKNODE_HTTP_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  solidity: "0.8.19",
  settings: {
    optimizer: {
      enabled: true,
      runs: 0,
    },
  },
  etherscan: {
    apiKey: "M7MZW79EKR2WV1Q81QTSBKP78JCSTJEDST",
  },
  networks: {
    sepolia: {
      url: QUICKNODE_HTTP_URL,
      accounts: [PRIVATE_KEY],
    },
  },
};
