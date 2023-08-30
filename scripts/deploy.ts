import { ethers, upgrades } from "hardhat";

async function main() {
    // Step 2: Deploy marketplace impl
    const FundManagerImpl = await ethers.getContractFactory("FundManagerImpl");
    let fundManagerImpl = await FundManagerImpl.deploy();
   await fundManagerImpl.deployed();

  
    console.log(`Fund Manager contract deployed at ${fundManagerImpl.address}`);
  // Step 1: Deploy proxy contract
  const Proxy = await ethers.getContractFactory(
    "FundManagerUpgradeable"
  );
  const proxy = await Proxy.deploy(fundManagerImpl.address, "0x");
  await proxy.deployed();

  console.log(`Proxy contract deployed at ${proxy.address}`);



  // fundManagerImpl = FundManagerImpl.attach(proxy_contract.address);

  // console.log(`Fund impl set to ${await proxy_contract.implementation()}`);

  const RecordExpenseHandler = await ethers.getContractFactory("RecordExpenseHandler");
  const recordExpenseHandler = await RecordExpenseHandler.deploy();
  await recordExpenseHandler.deployed()
  console.log(`RecordExpenseHandler: ${recordExpenseHandler.address}`);

  const SettleDebtHandler = await ethers.getContractFactory("SettleDebtHandler");
  const settleDebtHandler = await SettleDebtHandler.deploy();
  await settleDebtHandler.deployed()
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
