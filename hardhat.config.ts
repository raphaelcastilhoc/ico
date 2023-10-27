import * as dotenv from "dotenv";

import "@nomicfoundation/hardhat-foundry";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-gas-reporter";

dotenv.config();

// Dear Student,
//
// This hardhat.config.ts file differs from the Hardhat project boilerplate generated
// when you run `npx hardhat` in a new directory. We suggest you add these same lines
// of code to your future projects, in order to easily setup:
// - environment variables via `dotenv` (you'll need to `mv .env.example .env`)
// - Etherscan source verification
//
// Love,
// Macro Instruction Team

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    hardhat: {
      accounts: {
        count: 20,
        accountsBalance: "10000000000000000000000", // 10ETH (Default)
      },
    },
  },
  gasReporter: {
    enabled: !!process.env.REPORT_GAS,
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
