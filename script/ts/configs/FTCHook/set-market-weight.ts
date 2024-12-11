import { FTCHook__factory } from "../../../../typechain";
import { loadConfig, loadMarketConfig } from "../../utils/config";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";
import signers from "../../entities/signers";
import SafeWrapper from "../../wrappers/SafeWrapper";
import { passChainArg } from "../../utils/main-fn-wrappers";

type WeightConfig = {
  marketIndex: number;
  weightBPS: number;
};

const BPS = 1e4;

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const marketConfig = loadMarketConfig(chainId);
  const deployer = signers.deployer(chainId);
  // const safeWrapper = new SafeWrapper(chainId, config.safe, deployer);
  const ownerWrapper = new OwnerWrapper(chainId, deployer);

  const weightConfigs: Array<WeightConfig> = [
    {
      marketIndex: 0,
      weightBPS: 2.5 * BPS,
    },
    {
      marketIndex: 1,
      weightBPS: 2.5 * BPS,
    },
  ];

  const flcHook = FTCHook__factory.connect(config.hooks.tlc, deployer);

  console.log("[configs/FTCHook] Adding new market config...");
  for (let i = 0; i < weightConfigs.length; i++) {
    const marketIndex = weightConfigs[i].marketIndex;
    const market = marketConfig.markets[marketIndex];
    console.log(`[configs/FTCHook] Set Weight for Market Index: ${market.name}...`);
    // const tx = await safeWrapper.proposeTransaction(
    //   flcHook.address,
    //   0,
    //   flcHook.interface.encodeFunctionData("setMarketWeight", [marketIndex, weightConfigs[i].weightBPS])
    // );
    await ownerWrapper.authExec(
      flcHook.address,
      flcHook.interface.encodeFunctionData("setMarketWeight", [marketIndex, weightConfigs[i].weightBPS])
    );

    console.log(`[configs/FTCHook]`);
  }
  console.log("[configs/FTCHook] Finished");
}

passChainArg(main)