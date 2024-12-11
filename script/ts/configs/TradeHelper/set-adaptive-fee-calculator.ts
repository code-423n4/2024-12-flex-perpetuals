import { TradeHelper__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import { Command } from "commander";
import signers from "../../entities/signers";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";
import { passChainArg } from "../../utils/main-fn-wrappers";

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);
  const ownerWrapper = new OwnerWrapper(chainId, deployer);

  const tradeHelper = TradeHelper__factory.connect(config.helpers.trade, deployer);
  console.log(`[configs/TradeHelper] setAdaptiveFeeCalculator`);
  await ownerWrapper.authExec(
    tradeHelper.address,
    tradeHelper.interface.encodeFunctionData("setAdaptiveFeeCalculator", [config.adaptiveFeeCalculator])
  );
  console.log("[configs/TradeHelper] Finished");
}

passChainArg(main);