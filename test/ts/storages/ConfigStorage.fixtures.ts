import { ethers } from "ethers";
import assetClasses from "../../../script/ts/entities/asset-classes";

export type AddMarketConfig = {
  assetId: string;
  increasePositionFeeRateBPS: number;
  decreasePositionFeeRateBPS: number;
  initialMarginFractionBPS: number;
  maintenanceMarginFractionBPS: number;
  maxProfitRateBPS: number;
  assetClass: number;
  allowIncreasePosition: boolean;
  active: boolean;
  fundingRate: {
    maxSkewScaleUSD: ethers.BigNumber;
    maxFundingRate: ethers.BigNumber;
  };
  maxLongPositionSize: ethers.BigNumber;
  maxShortPositionSize: ethers.BigNumber;
  isAdaptiveFeeEnabled: boolean;
};

export const MARKET_CONFIG_BY_TOKEN: Record<string, AddMarketConfig> = {
  ETH: {
    assetId: ethers.utils.formatBytes32String("ETH"),
    maxLongPositionSize: ethers.utils.parseUnits("1000000", 30),
    maxShortPositionSize: ethers.utils.parseUnits("1000000", 30),
    increasePositionFeeRateBPS: 4, // 0.04%
    decreasePositionFeeRateBPS: 4, // 0.04%
    initialMarginFractionBPS: 100, // IMF = 1%, Max leverage = 100
    maintenanceMarginFractionBPS: 50, // MMF = 0.5%
    maxProfitRateBPS: 350000, // 3500%
    assetClass: assetClasses.crypto,
    allowIncreasePosition: true,
    active: true,
    fundingRate: {
      maxSkewScaleUSD: ethers.utils.parseUnits("2000000000", 30), // 2000 M
      maxFundingRate: ethers.utils.parseUnits("8", 18) // 900% per day
    },
    isAdaptiveFeeEnabled: false
  },
  BTC: {
    assetId: ethers.utils.formatBytes32String("BTC"),
    maxLongPositionSize: ethers.utils.parseUnits("1000000", 30),
    maxShortPositionSize: ethers.utils.parseUnits("1000000", 30),
    increasePositionFeeRateBPS: 4, // 0.04%
    decreasePositionFeeRateBPS: 4, // 0.04%
    initialMarginFractionBPS: 100, // IMF = 1%, Max leverage = 100
    maintenanceMarginFractionBPS: 50, // MMF = 0.5%
    maxProfitRateBPS: 350000, // 3500%
    assetClass: assetClasses.crypto,
    allowIncreasePosition: true,
    active: true,
    fundingRate: {
      maxSkewScaleUSD: ethers.utils.parseUnits("3000000000", 30), // 3000 M
      maxFundingRate: ethers.utils.parseUnits("8", 18) // 900% per day
    },
    isAdaptiveFeeEnabled: false
  },
  JPY: {
    assetId: ethers.utils.formatBytes32String("JPY"),
    maxLongPositionSize: ethers.utils.parseUnits("1000000", 30),
    maxShortPositionSize: ethers.utils.parseUnits("1000000", 30),
    increasePositionFeeRateBPS: 1, // 0.01%
    decreasePositionFeeRateBPS: 1, // 0.01%
    initialMarginFractionBPS: 10, // IMF = 0.1%, Max leverage = 1000
    maintenanceMarginFractionBPS: 5, // MMF = 0.05%
    maxProfitRateBPS: 500000, // 5000%
    assetClass: assetClasses.forex,
    allowIncreasePosition: true,
    active: true,
    fundingRate: {
      maxSkewScaleUSD: ethers.utils.parseUnits("10000000000", 30), // 10B
      maxFundingRate: ethers.utils.parseUnits("1", 18) // 100% per day
    },
    isAdaptiveFeeEnabled: false
  },
  XAU: {
    assetId: ethers.utils.formatBytes32String("XAU"),
    maxLongPositionSize: ethers.utils.parseUnits("1000000", 30),
    maxShortPositionSize: ethers.utils.parseUnits("1000000", 30),
    increasePositionFeeRateBPS: 5, // 0.05%
    decreasePositionFeeRateBPS: 5, // 0.05%
    initialMarginFractionBPS: 200, // IMF = 2%, Max leverage = 50
    maintenanceMarginFractionBPS: 100, // MMF = 1%
    maxProfitRateBPS: 75000, // 750%
    assetClass: assetClasses.commodities,
    allowIncreasePosition: true,
    active: true,
    fundingRate: {
      maxSkewScaleUSD: ethers.utils.parseUnits("10000000000", 30), // 10B
      maxFundingRate: ethers.utils.parseUnits("1", 18) // 100% per day
    },
    isAdaptiveFeeEnabled: false
  }

};
// const marketConfigs: Array<AddMarketConfig> = [];
