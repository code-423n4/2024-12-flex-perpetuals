import { ConfigStorage__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import SafeWrapper from "../../wrappers/SafeWrapper";
import { Command } from "commander";
import signers from "../../entities/signers";
import { passChainArg } from "../../utils/main-fn-wrappers";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";

async function main(chainId: number) {
  console.group('[config/ConfigStorage]')
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);
  // const safeWrapper = new SafeWrapper(chainId, deployer);
  const ownerWrapper = new OwnerWrapper(chainId, deployer);
  const configStorage = ConfigStorage__factory.connect(config.storages.config, deployer);

  console.log(" ConfigStorage setTradeServiceHooks...");
  await ownerWrapper.authExec(
    configStorage.address,
    configStorage.interface.encodeFunctionData("setTradeServiceHooks", [
      [config.hooks.tlc, config.hooks.tradingStaking],
    ])
  );

  console.groupEnd()
}

passChainArg(main)