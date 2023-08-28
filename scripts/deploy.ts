import { ethers } from "hardhat";

async function main() {

  const fundManager = await ethers.deployContract("FundManager");
  const FundManager = await fundManager.waitForDeployment();
  console.log(
    "fundManager contract is deployed at address: :>> ",
    FundManager.target
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
