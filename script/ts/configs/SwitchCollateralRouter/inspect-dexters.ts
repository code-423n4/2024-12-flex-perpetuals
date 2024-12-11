import { loadConfig } from "../../utils/config";
import signers from "../../entities/signers";
import { SwitchCollateralRouter__factory } from "../../../../typechain";
import { getDexterConfig } from "./inspect-dexters-configs";
import { ethers } from "ethers";
import { passChainArg } from "../../utils/main-fn-wrappers";

export type SetDexter = {
  tokenIn: string;
  tokenOut: string;
  dexter: string;
};

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);
  const swithCollateralRouter = SwitchCollateralRouter__factory.connect(
    config.extension.switchCollateralRouter,
    deployer
  );

  const dexters: Array<SetDexter> = getDexterConfig(chainId);

  console.log("[cmds/SwitchCollateralRouter] Setting dexter ...");
  for (let i = 0; i < dexters.length; i++) {
    const dexter: SetDexter = dexters[i];

    if (!dexter.dexter) throw new Error(`Dexter not found for #${i} (${dexter.tokenIn}, ${dexter.tokenOut}, ${dexter.dexter})`);
    if (!dexter.tokenOut) throw new Error(`Token out not found for #${i} (${dexter.tokenIn}, ${dexter.tokenOut}, ${dexter.dexter})`);
    if (!dexter.tokenIn) throw new Error(`Token in not found for #${i} (${dexter.tokenIn}, ${dexter.tokenOut}, ${dexter.dexter})`);

    const dexterAddr = await swithCollateralRouter.dexterOf(dexter.tokenIn, dexter.tokenOut);

    if (dexterAddr && dexterAddr !== ethers.constants.AddressZero) {
      console.log(`[cmds/SwitchCollateralRouter] Dexter of (${dexter.tokenIn}, ${dexter.tokenOut}) is set as ${dexterAddr}. Skip`);
      continue;
    }

    console.log(`[cmds/SwitchCollateralRouter] Setting dexter of (${dexter.tokenIn} -> ${dexter.tokenOut}) by dexter ${dexter.dexter})...`);

    const tx = await swithCollateralRouter.setDexterOf(dexter.tokenIn, dexter.tokenOut, dexter.dexter, {
      gasLimit: 10000000,
    });

    console.log(
      `[cmds/SwitchCollateralRouter] Tx - Set Dexter of (${dexter.tokenIn}, ${dexter.tokenOut}): ${tx.hash}`
    );
    await tx.wait(1);

  }


  console.log("[cmds/SwitchCollateralRouter] Finished");

}

passChainArg(main);