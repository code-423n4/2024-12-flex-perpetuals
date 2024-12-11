import { OrderbookOracle__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import signers from "../../entities/signers";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";
import { passChainArg } from "../../utils/main-fn-wrappers";

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const ownerWrapper = new OwnerWrapper(chainId, signers.deployer(chainId));

  const inputs = [
    { updater: "0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0", isUpdater: true },
    { updater: "0xdb09967dCDC0086f7b5d798f71De664c068e92De", isUpdater: true },
    { updater: "0xdb1c35fD123e2CeDa64F19f419dC4481177d77c7", isUpdater: true },
    { updater: "0xdb2bD1c6498393B1072d1152a1FFF265D8D00665", isUpdater: true },
    { updater: "0xdb3ea875d628496B6EC97691455b53b221FCd963", isUpdater: true },
    { updater: "0xdb42bC3EFd76b82FC5023b11efc4b4eC60ed413c", isUpdater: true },
  ];

  const deployer = signers.deployer(chainId);
  const orderbookOracle = OrderbookOracle__factory.connect(config.oracles.orderbook, deployer);

  console.log("[configs/OrderbookOracle] Proposing to set updaters...");
  await ownerWrapper.authExec(
    orderbookOracle.address,
    orderbookOracle.interface.encodeFunctionData("setUpdaters", [
      inputs.map((each) => each.updater),
      inputs.map((each) => each.isUpdater),
    ])
  );
  console.log("[configs/OrderbookOracle] Set Updaters success!");
}

passChainArg(main)