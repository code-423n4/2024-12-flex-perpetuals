import { ethers, run, tenderly, upgrades, network } from "hardhat";
import { getConfig, writeConfigFile } from "../../utils/config";
import { getImplementationAddress } from "@openzeppelin/upgrades-core";

const BigNumber = ethers.BigNumber;
const config = getConfig();

// const minExecutionFee = ethers.utils.parseEther("0.0003"); // 0.0003 ether
const minExecutionFee = ethers.utils.parseEther("0.001"); // 0.001 ETH
const minExecutionTimestamp = 60 * 60 * 5; // 5 minutes

async function main() {
  const deployer = (await ethers.getSigners())[0];

  const Contract = await ethers.getContractFactory("LimitTradeHandler", deployer);
  const contract = await upgrades.deployProxy(
    Contract,
    [
      config.tokens.weth, config.services.trade, config.oracles.ecoPyth2,
      minExecutionFee, minExecutionTimestamp
    ],
    {
      unsafeAllow: ["delegatecall"],
    }
  );
  await contract.deployed();
  console.log(`Deploying LimitTradeHandler Contract`);
  console.log(`Deployed at: ${contract.address}`);

  config.handlers.limitTrade = contract.address;
  writeConfigFile(config);

  await tenderly.verify({
    address: await getImplementationAddress(network.provider, config.handlers.limitTrade),
    name: "LimitTradeHandler",
  });

  await run("verify:verify", {
    address: await getImplementationAddress(network.provider, config.handlers.limitTrade),
    constructorArguments: [],
  });

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
