import { ethers } from "hardhat";
import { FlexTradeCredits__factory } from "../../../../typechain";
import { getConfig } from "../../utils/config";

const config = getConfig();

async function main() {
  const deployer = (await ethers.getSigners())[0];
  const contract = FlexTradeCredits__factory.connect(config.tokens.traderLoyaltyCredit, deployer);

  const minter = config.hooks.tlc
  console.log(`> FlexTradeCredits Set Minter... ${minter}`);
  await (await contract.setMinter(minter, true)).wait();
  console.log("> FlexTradeCredits Set Minter success!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
