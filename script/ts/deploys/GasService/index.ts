import { ethers, run, upgrades, network } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";
import { getImplementationAddress } from "@openzeppelin/upgrades-core";

const config = getConfig();

async function main() {
  const deployer = (await ethers.getSigners())[0];

  const executionFeeInUsd = ethers.utils.parseUnits("0.2", 30);
  const executionFeeTreasury = "0xfd1556DF7f07fD308d4809FBB34170F21E725C0E";

  const Contract = await ethers.getContractFactory("GasService", deployer);

  const contract = await upgrades.deployProxy(Contract, [
    config.storages.vault,
    config.storages.config,
    executionFeeInUsd,
    executionFeeTreasury,
  ]);
  await contract.deployed();
  console.log(`Deploying GasService Contract`);
  console.log(`Deployed at: ${contract.address}`);

  config.services.gas = contract.address;
  writeConfigFile(config);

  await run("verify:verify", {
    address: await getImplementationAddress(network.provider, contract.address),
    constructorArguments: [],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
