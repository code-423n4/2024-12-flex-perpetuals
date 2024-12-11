import { ConfigStorage__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import { Command } from "commander";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";
import signers from "../../entities/signers";
import { passChainArg } from "../../utils/main-fn-wrappers";

const liquidityConfig = {
  depositFeeRateBPS: 0, // 0%
  withdrawFeeRateBPS: 30, // 0.3%
  maxHLPUtilizationBPS: 8000, // 80%
  hlpTotalTokenWeight: 0, // DEFAULT
  hlpSafetyBufferBPS: 2000, // 20%
  taxFeeRateBPS: 50, // 0.5%
  flashLoanFeeRateBPS: 0,
  dynamicFeeEnabled: true,
  enabled: true,
};

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);
  const ownerWrapper = new OwnerWrapper(chainId, deployer);
  const configStorage = ConfigStorage__factory.connect(config.storages.config, deployer);

  console.log("[configs/ConfigStorage] Set Liquidity Config...");
  await ownerWrapper.authExec(
    configStorage.address,
    configStorage.interface.encodeFunctionData("setLiquidityConfig", [liquidityConfig])
  );
}

passChainArg(main)