import { ethers, upgrades } from "hardhat";

async function main() {
  // Step 1: Deploy proxy contract
  const proxy_factory = await ethers.getContractFactory(
    "FundManagerUpgradeable"
  );
  const proxy_contract = await upgrades.deployProxy(proxy_factory);
  await proxy_contract.deployed();

  console.log(`Proxy contract deployed at ${proxy_contract.address}`);

  // Step 2: Deploy marketplace impl
  const FundManagerImpl = await ethers.getContractFactory("FundManagerImpl");
  let fundManagerImpl = await FundManagerImpl.deploy();

  console.log(`Fund Manager contract deployed at ${fundManagerImpl}`);

  // fundManagerImpl = FundManagerImpl.attach(proxy_contract.address);
  // Step 3: Set marketplace
  let setting = await proxy_contract._upgradeTo(fundManagerImpl);
  await setting.wait();

  // console.log(`Fund impl set to ${await proxy_contract.implementation()}`);

  const RecordExpenseHandler = await ethers.getContractFactory("RecordExpenseHandler");
  const recordExpenseHandler = await RecordExpenseHandler.deploy();
  console.log(`RecordExpenseHandler: ${recordExpenseHandler.address}`);

  const SettleDebtHandler = await ethers.getContractFactory("SettleDebtHandler");
  const settleDebtHandler = await SettleDebtHandler.deploy();
  console.log(`SettleDebtHandler: ${settleDebtHandler.address}`);

  await fundManagerImpl.setRecordExpenesHandlerAddress(recordExpenseHandler.address);
  await fundManagerImpl.setSettleDebtHandlerAddress(settleDebtHandler.address);
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
