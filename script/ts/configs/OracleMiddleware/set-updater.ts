import { ethers } from "hardhat";
import { OracleMiddleware__factory } from "../../../../typechain";
import { getConfig } from "../../utils/config";

const config = getConfig();

const updaters = [
  "0xf0d00E8435E71df33bdA19951B433B509A315aee",
  "0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0",
  "0xdb09967dCDC0086f7b5d798f71De664c068e92De",
  "0xdb1c35fD123e2CeDa64F19f419dC4481177d77c7",
  "0xdb2bD1c6498393B1072d1152a1FFF265D8D00665",
  "0xdb3ea875d628496B6EC97691455b53b221FCd963",
  "0xdb42bC3EFd76b82FC5023b11efc4b4eC60ed413c",
];


async function main() {
  const deployer = (await ethers.getSigners())[0];
  const oracle = OracleMiddleware__factory.connect(config.oracles.middleware, deployer);

  console.group(`[configs/OracleMiddleware]`);
  for(const updater of updaters) {
    console.log("Set Updater...", updater);
    const transaction = await oracle.setUpdater(updater, true);
    console.log("> OracleMiddleware Set Updater success!");
    await transaction.wait(2);
    console.log("Set Updater for Order Executor success! Tx:", transaction.hash);
  }
  console.groupEnd();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
