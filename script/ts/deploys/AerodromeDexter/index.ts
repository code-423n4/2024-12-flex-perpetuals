import { ethers, run, tenderly } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";

const config = getConfig();

async function main() {
  const deployer = (await ethers.getSigners())[0];
  const contract = await ethers.deployContract(
    "AerodromeDexter",
    [config.vendors.aerodrome.router!],
    deployer
  );

  await contract.deployed();
  console.log(`[deploys/Dexter] Deploying AerodromeDexter Contract`);
  console.log(`[deploys/Dexter] Deployed at: ${contract.address}`);

  config.extension.dexter.aerodrome = contract.address;
  writeConfigFile(config);

  await tenderly.verify({
    address: contract.address,
    name: "AerodromeDexter",
  });

  await run("verify:verify", {
    address: config.extension.dexter.aerodrome,
    constructorArguments: [config.vendors.aerodrome.router!],
  });

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
