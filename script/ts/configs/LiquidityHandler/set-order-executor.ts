import { ethers } from "hardhat";
import { LiquidityHandler__factory } from "../../../../typechain";
import { getConfig } from "../../utils/config";

const config = getConfig();

const orderExecutors = [
  "0xf0d00e8435e71df33bda19951b433b509a315aee",
  "0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0",
  "0xdb09967dCDC0086f7b5d798f71De664c068e92De",
  "0xdb1c35fD123e2CeDa64F19f419dC4481177d77c7",
  "0xdb2bD1c6498393B1072d1152a1FFF265D8D00665",
  "0xdb3ea875d628496B6EC97691455b53b221FCd963",
  "0xdb42bC3EFd76b82FC5023b11efc4b4eC60ed413c",
];


async function main() {
  const deployer = (await ethers.getSigners())[0];

  console.group(`[configs/LiquidityHandler]`);
  for(const orderExecutor of orderExecutors) {
    console.log("Set Order Executor...", orderExecutor);
    const handler = LiquidityHandler__factory.connect(config.handlers.liquidity, deployer);
    let transaction = await handler.setOrderExecutor(orderExecutor, true);
    await transaction.wait(2);
    console.log("Set Order Executor success! Tx:", transaction.hash);
  }
  console.groupEnd();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
