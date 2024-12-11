import { ethers, tenderly, upgrades, network, run } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";
import { getImplementationAddress } from "@openzeppelin/upgrades-core";

const BigNumber = ethers.BigNumber;
const config = getConfig();

const tradeService = config.services.trade;
const tlc = config.tokens.traderLoyaltyCredit;
const tlcStaking = config.staking.tlc;

async function main() {
  const deployer = (await ethers.getSigners())[0];

  const Contract = await ethers.getContractFactory("FTCHook", deployer);

  const contract = await upgrades.deployProxy(Contract, [tradeService, tlc, tlcStaking]);
  await contract.deployed();
  console.log(`Deploying FTCHook Contract`);
  console.log(`Deployed at: ${contract.address}`);

  config.hooks.tlc = contract.address;
  writeConfigFile(config);

  await tenderly.verify({
    address: await getImplementationAddress(network.provider, contract.address),
    name: "FTCHook",
  });

  await run("verify:verify", {
    address: await getImplementationAddress(network.provider, config.hooks.tlc),
    contract: "src/staking/FTCHook.sol:FTCHook",
    constructorArguments: [],
  });

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
