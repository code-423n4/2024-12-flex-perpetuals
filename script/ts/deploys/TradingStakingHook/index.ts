import { ethers, tenderly, upgrades, network, run } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";
import { getImplementationAddress } from "@openzeppelin/upgrades-core";
import { runMainAsAsync } from "../../utils/main-fn-wrappers";

const config = getConfig();

async function main() {
  const deployer = (await ethers.getSigners())[0];

  const Contract = await ethers.getContractFactory("TradingStakingHook", deployer);

  const contract = await upgrades.deployProxy(Contract, [
    config.staking.trading, config.services.trade
  ]);
  console.log(`Deploying TradingStakingHook Contract...`);
  await contract.deployed();
  console.log(`Deployed at: ${contract.address}`);

  config.hooks.tradingStaking = contract.address;
  writeConfigFile(config);

  await tenderly.verify({
    address: await getImplementationAddress(network.provider, contract.address),
    name: "TradingStakingHook",
  });

  await run("verify:verify", {
    address: await getImplementationAddress(network.provider, contract.address),
    constructorArguments: [],
  });

}

runMainAsAsync(main)