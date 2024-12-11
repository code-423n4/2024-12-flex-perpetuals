import { VaultStorage__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import signers from "../../entities/signers";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";
import { passChainArg } from "../../utils/main-fn-wrappers";

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const inputs = [
    {
      executorAddress: config.services.liquidity,
      isServiceExecutor: true,
    },
    {
      executorAddress: config.services.crossMargin,
      isServiceExecutor: true,
    },
    {
      executorAddress: config.services.trade,
      isServiceExecutor: true,
    },
    {
      executorAddress: config.helpers.trade,
      isServiceExecutor: true,
    },
    {
      executorAddress: config.services.liquidation,
      isServiceExecutor: true,
    },
    // {
    //   executorAddress: config.strategies.stakedGlpStrategy,
    //   isServiceExecutor: true,
    // },
    {
      executorAddress: config.rewardDistributor,
      isServiceExecutor: true,
    },
    {
      executorAddress: config.handlers.bot,
      isServiceExecutor: true,
    },
    {
      executorAddress: config.services.gas,
      isServiceExecutor: true,
    },
  ];

  const deployer = signers.deployer(chainId);
  const ownerWrapper = new OwnerWrapper(chainId, deployer);
  const vaultStorage = VaultStorage__factory.connect(config.storages.vault, deployer);

  console.log("[configs/VaultStorage] Set the service executors...");
  await ownerWrapper.authExec(
    vaultStorage.address,
    vaultStorage.interface.encodeFunctionData("setServiceExecutorBatch", [
      inputs.map((each) => each.executorAddress),
      inputs.map((each) => each.isServiceExecutor),
    ])
  );
  console.log(`[configs/VaultStorage] Done`);
}

passChainArg(main)