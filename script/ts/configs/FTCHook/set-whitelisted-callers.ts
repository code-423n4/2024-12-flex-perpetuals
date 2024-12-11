import { FTCHook__factory } from "../../../../typechain";
import { loadConfig, loadMarketConfig } from "../../utils/config";
import { Command } from "commander";
import signers from "../../entities/signers";
import SafeWrapper from "../../wrappers/SafeWrapper";
import { compareAddress } from "../../utils/address";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";
import { passChainArg } from "../../utils/main-fn-wrappers";

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);

  const whitelistedCallers = [
    {
      caller: config.services.trade,
      isWhitelisted: true,
    },
    {
      caller: config.services.liquidation,
      isWhitelisted: true,
    },
  ];

  const ftcHook = FTCHook__factory.connect(config.hooks.tlc, deployer);
  const owner = await ftcHook.owner();
  console.log(`[configs/FTCHook] Set Whitelisted Callers`);
  if (compareAddress(owner, config.safe)) {
    const safeWrapper = new SafeWrapper(chainId, config.safe, deployer);
    const tx = await safeWrapper.proposeTransaction(
      ftcHook.address,
      0,
      ftcHook.interface.encodeFunctionData("setWhitelistedCallers", [
        whitelistedCallers.map((each) => each.caller),
        whitelistedCallers.map((each) => each.isWhitelisted),
      ])
    );
    console.log(`[configs/FTCHook] Proposed tx: ${tx}`);
  } else {
    const tx = await ftcHook.setWhitelistedCallers(
      whitelistedCallers.map((each) => each.caller),
      whitelistedCallers.map((each) => each.isWhitelisted)
    );
    console.log(`[configs/FTCHook] Tx: ${tx}`);
    await tx.wait();
  }
  console.log("[configs/FTCHook] Finished");
}

passChainArg(main)