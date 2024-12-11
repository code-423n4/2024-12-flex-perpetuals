import { BotHandler__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import { Command } from "commander";
import signers from "../../entities/signers";
import SafeWrapper from "../../wrappers/SafeWrapper";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";
import { passChainArg } from "../../utils/main-fn-wrappers";

const positionManagers = [
  "0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0",
  "0xdb09967dCDC0086f7b5d798f71De664c068e92De",
  "0xdb1c35fD123e2CeDa64F19f419dC4481177d77c7",
  "0xdb2bD1c6498393B1072d1152a1FFF265D8D00665",
  "0xdb3ea875d628496B6EC97691455b53b221FCd963",
  "0xdb42bC3EFd76b82FC5023b11efc4b4eC60ed413c",
];

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);
  const ownerWrapper = new OwnerWrapper(chainId, deployer);
  const botHandler = BotHandler__factory.connect(config.handlers.bot, deployer);

  console.log("[configs/BotHandler] Proposing tx to set position managers");
  await ownerWrapper.authExec(
    botHandler.address,
    botHandler.interface.encodeFunctionData("setPositionManagers", [positionManagers, true])
  );
}

passChainArg(main)