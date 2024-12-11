import { ethers, tenderly, upgrades, network } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";
import { getImplementationAddress } from "@openzeppelin/upgrades-core";

const config = getConfig();

async function main() {

  await tenderly.verify({
    address: await getImplementationAddress(network.provider, config.hooks.tlc),
    name: "FTCHook",
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
