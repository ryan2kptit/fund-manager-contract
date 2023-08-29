import { ethers, upgrades } from "hardhat";

async function main() {
  // Step 1: Deploy proxy contract
  const proxy_factory = await ethers.getContractFactory(
    "FundManagerUpgradeable"
  );
  const proxy_contract = await upgrades.deployProxy(proxy_factory);
  await proxy_contract.deployed();

  console.log(`Proxy contract deployed at ${proxy_contract.address}`);

  // Step 2: Deploy marketplace handler
  const fund_factory = await ethers.getContractFactory("FundManagerImpl");
  const fund_contract = await upgrades.deployImplementation(fund_factory);

  console.log(`Fund Manager contract deployed at ${fund_contract}`);

  // Step 3: Set marketplace
  let setting = await proxy_contract.setFundManagerImpl(fund_contract);
  await setting.wait();

  console.log(`Fund impl set to ${await proxy_contract.implementation()}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
