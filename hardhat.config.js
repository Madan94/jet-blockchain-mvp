require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    mumbai: {
      url: "https://polygon-amoy.infura.io/v3/325bd28639c9484381b3b0dba697aebb",
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
