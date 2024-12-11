import { Ext01Handler__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import SafeWrapper from "../../wrappers/SafeWrapper";
import { Command } from "commander";
import signers from "../../entities/signers";
import { compareAddress } from "../../utils/address";
import { ethers } from "ethers";
import { findChainByName } from "../../entities/chains";
import { passChainArg } from "../../utils/main-fn-wrappers";

// OrderType 1 = Create switch collateral order
const SWITCH_COLLATERAL_ORDER_TYPE = 1;

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);
  const safeWrapper = new SafeWrapper(chainId, config.safe, deployer);
  const ext01Handler = Ext01Handler__factory.connect(config.handlers.ext01, deployer);

  const orderExecutors = [
    "0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0",
    "0xdb09967dCDC0086f7b5d798f71De664c068e92De",
    "0xdb1c35fD123e2CeDa64F19f419dC4481177d77c7",
    "0xdb2bD1c6498393B1072d1152a1FFF265D8D00665",
    "0xdb3ea875d628496B6EC97691455b53b221FCd963",
    "0xdb42bC3EFd76b82FC5023b11efc4b4eC60ed413c",
  ];
  const isAllow = true;

  console.group("[config/Ext01Handler]");
  for (const orderExecutor of orderExecutors) {
    console.log("Ext01Handler setOrderExecutor...", orderExecutor);
    const owner = await ext01Handler.owner();
    if (compareAddress(owner, config.safe)) {
      const tx = await safeWrapper.proposeTransaction(
        ext01Handler.address,
        0,
        ext01Handler.interface.encodeFunctionData("setOrderExecutor", [orderExecutor, isAllow])
      );
      console.log(`Proposed ${tx} to setOrderExecutor`);
    } else {
      const tx = await ext01Handler.setOrderExecutor(orderExecutor, isAllow);
      console.log(`setOrderExecutor Done at ${tx.hash}`);
      await tx.wait();
    }
  }

  console.groupEnd();

}

passChainArg(main)