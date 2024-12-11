import { Command } from "commander";
import { loadConfig } from "../../utils/config";
import signers from "../../entities/signers";
import { AerodromeDexter__factory } from "../../../../typechain";
import { passChainArg } from "../../utils/main-fn-wrappers";

type Route = {
  from: string;
  to: string;
  stable: boolean;
  factory: string;
}

type SetRouteConfig = {
  tokenIn: string;
  tokenOut: string;
  route: Route[];
};

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const deployer = signers.deployer(chainId);
  const dexter = AerodromeDexter__factory.connect(config.extension.dexter.aerodrome, deployer);

  const params: Array<SetRouteConfig> = [
    {
      tokenIn: config.tokens.usdc,
      tokenOut: config.tokens.wstEth,
      route: [
        {
          from: config.tokens.usdc,
          to: config.tokens.weth,
          stable: false,
          factory: config.vendors.aerodrome.factory
        },
        {
          from: config.tokens.weth,
          to: config.tokens.wstEth,
          stable: false,
          factory: config.vendors.aerodrome.factory
        },
      ]
    },
  ];

  console.log("[cmds/AerodromeDexter] Setting path config...");
  for (let i = 0; i < params.length; i++) {
    console.log(params[i].route);
    const tx = await dexter.setRouteOf(params[i].tokenIn, params[i].tokenOut, params[i].route, {
      gasLimit: 10000000,
    });
    console.log(`[cmds/AerodromeDexter] Tx - Set Path of (${params[i].tokenIn}, ${params[i].tokenOut}): ${tx.hash}`);
    await tx.wait(1);
  }

  console.log("[cmds/AerodromeDexter] Finished");
}

passChainArg(main)