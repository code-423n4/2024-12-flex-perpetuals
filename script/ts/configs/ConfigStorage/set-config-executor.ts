import { ethers } from "hardhat";
import { ConfigStorage__factory } from "../../../../typechain";
import { getConfig } from "../../utils/config";

const config = getConfig();
const executor = config.handlers.bot;

async function main() {
  const deployer = (await ethers.getSigners())[0];
  const configStorage = ConfigStorage__factory.connect(config.storages.config, deployer);

  console.log("> ConfigStorage: Set Config Executor...");
  await (await configStorage.setConfigExecutor(executor, true)).wait();
  console.log("> ConfigStorage: Set Config Executor success!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
