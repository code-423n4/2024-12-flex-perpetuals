import { ConfigStorage__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import SafeWrapper from "../../wrappers/SafeWrapper";
import { Command } from "commander";
import signers from "../../entities/signers";
import { compareAddress } from "../../utils/address";
import { passChainArg } from "../../utils/main-fn-wrappers";

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);
  const safeWrapper = new SafeWrapper(chainId, config.safe, deployer);
  const configStorage = ConfigStorage__factory.connect(config.storages.config, deployer);

  console.log("[config/ConfigStorage] ConfigStorage setSwitchCollateralRouter...");
  const owner = await configStorage.owner();
  if (compareAddress(owner, config.safe)) {
    const tx = await safeWrapper.proposeTransaction(
      configStorage.address,
      0,
      configStorage.interface.encodeFunctionData("setSwitchCollateralRouter", [config.extension.switchCollateralRouter])
    );
    console.log(`[config/ConfigStorage] Proposed ${tx} to setSwitchCollateralRouter`);
  } else {
    const tx = await configStorage.setSwitchCollateralRouter(config.extension.switchCollateralRouter);
    console.log(`[config/ConfigStorage] setSwitchCollateralRouter Done at ${tx.hash}`);
    await tx.wait();
  }
}

passChainArg(main)