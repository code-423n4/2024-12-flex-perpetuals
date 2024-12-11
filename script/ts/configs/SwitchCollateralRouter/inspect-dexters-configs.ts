import { BASE_SEPOLIA_CHAIN_ID } from "../../entities/chains";
import { loadConfig } from "../../utils/config";

export function getDexterConfig(chainId: number) {
  const config = loadConfig(chainId) as any
  switch (chainId) {
    case BASE_SEPOLIA_CHAIN_ID:
      return [
        {
          tokenIn: config.tokens.weth,
          tokenOut: config.tokens.usdc,
          dexter: config.extension.dexter.uniswapV3,
        },
        {
          tokenIn: config.tokens.wbtc,
          tokenOut: config.tokens.usdc,
          dexter: config.extension.dexter.uniswapV3,
        },
        // {
        //   tokenIn: config.tokens.usdcNative,
        //   tokenOut: config.tokens.sglp,
        //   dexter: config.extension.dexter.uniswapV3,
        // },
      ]
    default:
      throw new Error(`Chain not supported: ${chainId}`)
  }
}