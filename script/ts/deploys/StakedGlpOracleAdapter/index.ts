import { ethers, tenderly, upgrades, network } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";
import { getImplementationAddress } from "@openzeppelin/upgrades-core";

const BigNumber = ethers.BigNumber;
const config = getConfig();

async function main() {
  const deployer = (await ethers.getSigners())[0];

  const Contract = await ethers.getContractFactory("StakedGlpOracleAdapter", deployer);
  const contract = await upgrades.deployProxy(Contract, [
    config.tokens.sglp,
    config.yieldSources.gmx.glpManager,
    ethers.utils.formatBytes32String("GLP"),
  ]);
  await contract.deployed();
  console.log(`Deploying StakedGlpOracleAdapter Contract`);
  console.log(`Deployed at: ${contract.address}`);

  config.oracles.sglpStakedAdapter = contract.address;
  writeConfigFile(config);

  await tenderly.verify({
    address: await getImplementationAddress(network.provider, contract.address),
    name: "StakedGlpOracleAdapter",
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
