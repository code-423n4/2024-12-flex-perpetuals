import { EcoPyth__factory } from "../../../../typechain";
import { loadConfig } from "../../utils/config";
import signers from "../../entities/signers";
import { Command } from "commander";
import { compareAddress } from "../../utils/address";
import { OwnerWrapper } from "../../wrappers/OwnerWrapper";
import { findChainByName } from "../../entities/chains";

async function main(chainId: number) {
  const config = loadConfig(chainId);

  // const inputs = [{ updater: "0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0", isUpdater: true }];
  const inputs = [
    { updater: config.handlers.bot!, isUpdater: true },
    { updater: config.handlers.crossMargin!, isUpdater: true },
    { updater: config.handlers.liquidity!, isUpdater: true },
    { updater: config.handlers.intent!, isUpdater: true },
    { updater: config.handlers.limitTrade!, isUpdater: true },
    { updater: config.handlers.ext01!, isUpdater: true },
    { updater: "0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0", isUpdater: true }, // Testnet onl
    { updater: "0xf0d00E8435E71df33bdA19951B433B509A315aee", isUpdater: true }, // Testnet onl
  ];

  const deployer = signers.deployer(chainId);
  const ownerWrapper = new OwnerWrapper(chainId, deployer);
  const ecoPyth = EcoPyth__factory.connect(config.oracles.ecoPyth2, deployer);
  console.log("[configs/EcoPyth] Proposing to set updaters...");
  await ownerWrapper.authExec(
    ecoPyth.address,
    ecoPyth.interface.encodeFunctionData("setUpdaters", [
      inputs.map((each) => each.updater),
      inputs.map((each) => each.isUpdater),
    ])
  );
  console.log("[configs/EcoPyth] Set Updaters success!");
}

const program = new Command();

program.requiredOption("--chain <chain>", "chain alias");

const opts = program.parse(process.argv).opts();

const chain = findChainByName(opts.chain);
main(chain.id!).catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
