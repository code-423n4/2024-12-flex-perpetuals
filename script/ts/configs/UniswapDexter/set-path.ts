import { loadConfig } from "../../utils/config";
import signers from "../../entities/signers";
import { UniswapDexter__factory } from "../../../../typechain";
import { ethers } from "ethers";
import { passChainArg } from "../../utils/main-fn-wrappers";

export type SetPathConfig = {
  tokenIn: string;
  tokenOut: string;
  path: string;
};

async function main(chainId: number) {
  const config = loadConfig(chainId) as any;
  const deployer = signers.deployer(chainId);
  const dexter = UniswapDexter__factory.connect(config.extension.dexter.uniswapV3!, deployer);

  console.log("[cmds/UniswapDexter]");

  const params: Array<SetPathConfig> = [
    // {
    //   tokenIn: config.tokens.usdc,
    //   tokenOut: config.tokens.wstEth,
    //   path: ethers.utils.solidityPack(
    //     ["address", "uint24", "address", "uint24", "address"],
    //     [config.tokens.usdc, 500, config.tokens.weth, 100, config.tokens.wstEth]
    //   ),
    // },
    {
      tokenIn: config.tokens.usdc,
      tokenOut: config.tokens.weth,
      path: ethers.utils.solidityPack(
        ["address", "uint24", "address"],
        [config.tokens.usdc, 500, config.tokens.weth]
      )
    },
    {
      tokenIn: config.tokens.weth,
      tokenOut: config.tokens.usdc,
      path: ethers.utils.solidityPack(
        ["address", "uint24", "address"],
        [config.tokens.weth, 500, config.tokens.usdc]
      )
    },
    {
      tokenIn: config.tokens.wbtc,
      tokenOut: config.tokens.usdc,
      path: ethers.utils.solidityPack(
        ["address", "uint24", "address"],
        [config.tokens.wbtc, 500, config.tokens.usdc]
      )
    },
    {
      tokenIn: config.tokens.usdc,
      tokenOut: config.tokens.wbtc,
      path: ethers.utils.solidityPack(
        ["address", "uint24", "address"],
        [config.tokens.usdc, 500, config.tokens.wbtc]
      )
    },
  ];

  console.log("Setting path config...");
  for (let i = 0; i < params.length; i++) {
    console.log(`Path ${params[i].tokenIn} -> ${params[i].tokenOut}: ${params[i].path}`);

    const tx = await dexter.setPathOf(params[i].tokenIn, params[i].tokenOut, params[i].path, {
      gasLimit: 10000000
    });

    console.log(`[cmds/UniswapDexter] Tx - Set Path of (${params[i].tokenIn}, ${params[i].tokenOut}): ${tx.hash}`);
    await tx.wait(2);
  }

  console.groupEnd();
}

passChainArg(main);