import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import '@openzeppelin/hardhat-upgrades';
import dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    develop: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
    },
    mumbai: {
      url: process.env.MUMBAI_ALCHEMY,
      accounts: [
        process.env.PRIVATE_KEY_ADMIN ? process.env.PRIVATE_KEY_ADMIN : "",
      ],
      // gasPrice: 50000000000,
    },
  },
  etherscan: {
    apiKey: process.env.POLYGON_API_KEY,
  },
};

export default config;
