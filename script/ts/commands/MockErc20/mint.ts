import { Command } from "commander";
import { loadConfig } from "../../utils/config";
import signers from "../../entities/signers";
import { LiquidityHandler__factory, ERC20__factory, MockErc20__factory } from "../../../../typechain";
import { ethers } from "ethers";

async function main(chainId: number) {
  const config = loadConfig(chainId);
  const signer = signers.deployer(chainId);

  const tokenAddress = config.tokens.wbtc;
  const mintTo = "0xf0d00E8435E71df33bdA19951B433B509A315aee";

  console.log("[MockErc20] mint...");
  const token = MockErc20__factory.connect(tokenAddress, signer);
  const amount = ethers.utils.parseUnits(String(10_000), await token.decimals());
  await (await token.mint(mintTo, amount)).wait();
}

const prog = new Command();

prog.requiredOption("--chain-id <chainId>", "chain id", parseInt);

prog.parse(process.argv);

const opts = prog.opts();

main(opts.chainId)
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
