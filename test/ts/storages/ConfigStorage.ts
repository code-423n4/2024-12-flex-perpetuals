import { ethers } from "hardhat";
import hre from "hardhat";
import { pipeFixturesFactory } from "../utils/createFixtureFactory";
import {
  loadFixture
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { MARKET_CONFIG_BY_TOKEN } from "./ConfigStorage.fixtures";
import { expect } from "chai";
import "@nomicfoundation/hardhat-chai-matchers/withArgs";
import "@nomicfoundation/hardhat-chai-matchers";
import { ConfigStorage__factory } from "../../../typechain";
import type { PromiseOrValue } from "../../../typechain/common";
import type { BigNumberish, BytesLike } from "ethers";

async function deployConfigStorage(fixtures: any) {

  // const { owner } = fixtures

  const ConfigStorage = await ethers.getContractFactory("ConfigStorage");
  // const adminAddress = await hre.upgrades.deployProxyAdmin(ConfigStorage.signer, {});
  // const proxyAdmin = await ethers.getContractAt('ProxyAdmin', adminAddress)
  const configStorage = await hre.upgrades.deployProxy(ConfigStorage, [], {
    gasLimit: 30_000_000,
    kind: "transparent",
    initializer: "initialize"
  });
  await configStorage.deployed();

  return { configStorage };

}

describe("ConfigStorage", function() {

  describe("Deployment", async function() {

    beforeEach(async function() {
      const fixtures = await loadFixture(pipeFixturesFactory([
        deployConfigStorage
      ]));
      this.fixtures = fixtures;
    });

    it("Should deploy", async function() {
      const [owner] = await hre.ethers.getSigners();
      const { configStorage } = this.fixtures;
      expect(await configStorage.owner()).to.equal(owner.address);
    });

    it("Remove Market Test", async function() {
      const [deployer] = await hre.ethers.getSigners();
      const { configStorage } = this.fixtures;

      expect(await configStorage.getMarketConfigsLength()).to.equal(0);
      expect(await configStorage.getAssetClassConfigsLength()).to.equal(0);

      // Crypto, 0.01% per hour
      await (await configStorage.addAssetClassConfig({ baseBorrowingRate: 27777777777 })).wait(1);
      // EQUITY, 0.01% per hour
      await (await configStorage.addAssetClassConfig({ baseBorrowingRate: 27777777777 })).wait(1);
      // FOREX, 0.01% per hour
      await (await configStorage.addAssetClassConfig({ baseBorrowingRate: 27777777777 })).wait(1);
      // COMMODITY, 0.01% per hour
      await (await configStorage.addAssetClassConfig({ baseBorrowingRate: 27777777777 })).wait(1);

      expect(await configStorage.getAssetClassConfigsLength()).to.equal(4);

      const marketConfigs = [
        MARKET_CONFIG_BY_TOKEN.ETH,
        MARKET_CONFIG_BY_TOKEN.BTC,
        MARKET_CONFIG_BY_TOKEN.JPY,
        MARKET_CONFIG_BY_TOKEN.XAU,
      ];

      for (let i = 0; i < marketConfigs.length; i++) {
        await configStorage.addMarketConfig(marketConfigs[i], marketConfigs[i].isAdaptiveFeeEnabled);
      }

      expect(await configStorage.getMarketConfigsLength()).to.equal(4);

      await (await configStorage.deleteLastMarket()).wait(1);
      await (await configStorage.deleteLastMarket()).wait(1);

      // Remove Crypto Market Config
      expect(await configStorage.getMarketConfigsLength()).to.equal(2);

    });

  });

});