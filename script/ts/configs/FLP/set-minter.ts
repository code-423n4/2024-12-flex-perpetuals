import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";
import { FLP__factory } from "../../../../typechain";
import { getConfig } from "../../utils/config";

const config = getConfig();

const minter = config.services.liquidity;

async function main() {
  const deployer = (await ethers.getSigners())[0];
  const contract = FLP__factory.connect(config.tokens.hlp, deployer);

  console.log(`> FLP Set Minter... ${minter}`);
  await (await contract.setMinter(minter, true)).wait();
  console.log("> FLP Set Minter success!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
