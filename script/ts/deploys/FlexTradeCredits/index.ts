import { ethers, run, upgrades, network } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";
import { getImplementationAddress } from "@openzeppelin/upgrades-core";

const config = getConfig();

async function main() {
  const deployer = (await ethers.getSigners())[0];

  const Contract = await ethers.getContractFactory("FlexTradeCredits", deployer);
  const contract = await upgrades.deployProxy(Contract, []);
  await contract.deployed();
  console.log(`Deploying FlexTradeCredits Contract`);
  console.log(`Deployed at: ${contract.address}`);

  config.tokens.flexTradeCredits = contract.address;
  config.tokens.traderLoyaltyCredit = contract.address;
  writeConfigFile(config);

  await run("verify:verify", {
    address: await getImplementationAddress(network.provider, config.tokens.flexTradeCredits),
    constructorArguments: [],
  });

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
