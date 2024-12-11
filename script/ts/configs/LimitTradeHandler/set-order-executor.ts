import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";
import { EvmPriceServiceConnection } from "@pythnetwork/pyth-evm-js";
import {
  IPyth__factory,
  LimitTradeHandler__factory,
  MockPyth__factory,
  PythAdapter__factory,
} from "../../../../typechain";
import { getConfig } from "../../utils/config";

const config = getConfig();
const BigNumber = ethers.BigNumber;
const parseUnits = ethers.utils.parseUnits;

const orderExecutors = [
  "0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0",
  "0xdb09967dCDC0086f7b5d798f71De664c068e92De",
  "0xdb1c35fD123e2CeDa64F19f419dC4481177d77c7",
  "0xdb2bD1c6498393B1072d1152a1FFF265D8D00665",
  "0xdb3ea875d628496B6EC97691455b53b221FCd963",
  "0xdb42bC3EFd76b82FC5023b11efc4b4eC60ed413c",
];

async function main() {
  const deployer = (await ethers.getSigners())[0];

  console.group("[config/LimitTradeHandler] Set");
  for(const orderExecutor of orderExecutors) {
    console.log(`> LimitTradeHandler: Set Order Executor ${orderExecutor}...`);
    const limitTradeHandler = LimitTradeHandler__factory.connect(config.handlers.limitTrade, deployer);
    let transaction = await limitTradeHandler.setOrderExecutor(orderExecutor, true);
    await transaction.wait(2);
    console.log("> LimitTradeHandler: Set Order Executor success! Tx:", transaction.hash);
  }
  console.groupEnd();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
