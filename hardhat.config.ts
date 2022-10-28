import { HardhatUserConfig, task } from "hardhat/config";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import "@nomicfoundation/hardhat-toolbox";

task(
  "accounts",
  "Prints the list of accounts",
  async (args, hre): Promise<void> => {
      const accounts: SignerWithAddress[] = await hre.ethers.getSigners();
      accounts.forEach((account: SignerWithAddress): void => {
          console.log(account.address);
      });
  }
);

const config: HardhatUserConfig = {
  solidity: {
    compilers: [{
      version: "0.8.0",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
          details: {
            yul: true,
            yulDetails : {
              stackAllocation : true
            },
          },
        },
      },
    },{
      version: "0.8.17",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
          details: {
            yul: true,
            yulDetails : {
              stackAllocation : true
            },
          },
        },
      },
    }],
  },
};

export default config;
