import { ethers, run, upgrades, network } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";
import { getImplementationAddress } from "@openzeppelin/upgrades-core";

const BigNumber = ethers.BigNumber;
const config = getConfig();

const maxTrustPriceAge = 60 * 60 * 24 * 7; // 7 Days

async function main() {
  const deployer = (await ethers.getSigners())[0];

  const OracleMiddleware = await ethers.getContractFactory("OracleMiddleware", deployer);
  const contract = await upgrades.deployProxy(OracleMiddleware, [maxTrustPriceAge]);
  await contract.deployed();
  console.log(`Deploying OracleMiddleware Contract`);
  console.log(`Deployed at: ${contract.address}`);

  config.oracles.middleware = contract.address;
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
