// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {BotHandler_Base} from "./BotHandler_Base.t.sol";

import {PositionTester} from "../../testers/PositionTester.sol";

// What is this test DONE
// - success
//   - can close posiiton when hlp not healthy
// - revert
//   - when not bot
//   - when hlp healthy
//   - market delisted
//   - market status from oracle is inactive (market close)
//   - over deleverage

contract BotHandler_Deleverage is BotHandler_Base {
    function setUp() public virtual override {
        super.setUp();
    }

    function testRevert_deleverage_WhenSomeoneCallBotHandler() external {
        vm.prank(ALICE);
        vm.expectRevert(abi.encodeWithSignature("IBotHandler_UnauthorizedSender()"));
        botHandler.deleverage(
            ALICE,
            0,
            ethMarketIndex,
            address(usdt),
            priceUpdateData,
            publishTimeUpdateData,
            block.timestamp,
            keccak256("someEncodedVaas")
        );
    }

    function testRevert_deleverage_WhenValidateError() external {
        // Add Liquidity 120,000 USDT -> 120,000 USD
        // TVL = 120,000 USD
        // AUM = 120,000 USD
        vaultStorage.addHLPLiquidity(address(usdt), 120_000 * 1e6);
        mockCalculator.setHLPValue(120_000 * 1e30);
        mockCalculator.setAUM(120_000 * 1e30);

        // ALICE add collateral 10,000 USD
        // Free collateral 10,000 USD
        mockCalculator.setEquity(ALICE, 10_000 * 1e30);
        mockCalculator.setFreeCollateral(10_000 * 1e30);

        // ETH price 1,500 USD
        mockOracle.setPrice(wethAssetId, 1_500 * 1e30);

        // ALICE open position Long ETH 1,000,000
        tradeService.increasePosition(ALICE, 0, ethMarketIndex, 1_000_000 * 1e30, 0);

        // ETH price 1,560 USD
        mockOracle.setPrice(wethAssetId, 1_560 * 1e30);

        // ALICE's position profit 40,000 USD
        // AUM = 120,000 - 40,000 = 80,000
        mockCalculator.setAUM((80_000) * 1e30);

        // HLP safety buffer = 1 + ((80,000 - 120,000) / 120,000) = 0.6666666666666667

        vm.expectRevert(abi.encodeWithSignature("ITradeService_HlpHealthy()"));
        botHandler.deleverage(
            ALICE,
            0,
            ethMarketIndex,
            address(usdt),
            priceUpdateData,
            publishTimeUpdateData,
            block.timestamp,
            keccak256("someEncodedVaas")
        );
    }

    function testRevert_deleverage_WhenValidatePass() external {
        // Add Liquidity 120,000 USDT -> 120,000 USD
        // TVL = 120,000 USD
        // AUM = 120,000 USD
        vaultStorage.addHLPLiquidity(address(usdt), 120_000 * 1e6);
        mockCalculator.setHLPValue(120_000 * 1e30);
        mockCalculator.setAUM(120_000 * 1e30);

        // ALICE add collateral 10,000 USD
        // Free collateral 10,000 USD
        mockCalculator.setEquity(ALICE, 10_000 * 1e30);
        mockCalculator.setFreeCollateral(10_000 * 1e30);

        // ETH price 1,500 USD
        mockOracle.setPrice(wethAssetId, 1_500 * 1e30);

        // ALICE open position Long ETH 1,000,000
        tradeService.increasePosition(ALICE, 0, ethMarketIndex, 1_000_000 * 1e30, 0);

        // ETH price 1,620 USD
        mockOracle.setPrice(wethAssetId, 1_620 * 1e30);

        // ALICE's position profit 80,000 USD
        // AUM = 120,000 - 80,000 = 40,000
        mockCalculator.setAUM((40_000) * 1e30);

        // HLP safety buffer = 1 + ((40,000 - 120,000) / 120,000) = 0.33333333333333337
        botHandler.deleverage(
            ALICE,
            0,
            ethMarketIndex,
            address(usdt),
            priceUpdateData,
            publishTimeUpdateData,
            block.timestamp,
            keccak256("someEncodedVaas")
        );
    }

    function testRevert_deleverage_WhenOverDeleverage() external {
        // Add Liquidity 120,000 USDT -> 120,000 USD
        // TVL = 160,000 USD
        // AUM = 160,000 USD
        vaultStorage.addHLPLiquidity(address(usdt), 160_000 * 1e6);
        mockCalculator.setHLPValue(160_000 * 1e30);
        mockCalculator.setAUM(160_000 * 1e30);

        // ALICE add collateral 20,000 USD
        // Free collateral 20,000 USD
        mockCalculator.setEquity(ALICE, 20_000 * 1e30);
        mockCalculator.setFreeCollateral(20_000 * 1e30);

        // ETH price 1,500 USD
        mockOracle.setPrice(wethAssetId, 1_500 * 1e30);
        // BTC price 25,000 USD
        mockOracle.setPrice(wbtcAssetId, 25_000 * 1e30);

        // ALICE open position Long ETH 1,000,000
        tradeService.increasePosition(ALICE, 0, ethMarketIndex, 1_000_000 * 1e30, 0);
        // ALICE open position Long BTC 1,000,000
        tradeService.increasePosition(ALICE, 0, btcMarketIndex, 400_000 * 1e30, 0);

        // ETH price 1,620 USD
        mockOracle.setPrice(wethAssetId, 1_620 * 1e30);

        // ALICE's position profit 80,000 USD
        // AUM = 160,000 - 80,000 = 80,000
        mockCalculator.setAUM((80_000) * 1e30);

        // HLP safety buffer = 1 + ((80,000 - 160,000) / 160,000) = 0.5
        botHandler.deleverage(
            ALICE,
            0,
            ethMarketIndex,
            address(usdt),
            priceUpdateData,
            publishTimeUpdateData,
            block.timestamp,
            keccak256("someEncodedVaas")
        );
        // After deleverage settle profit to ALICE
        // TVL = 160,000 - 80,000 = 80,000
        mockCalculator.setHLPValue(80_000 * 1e30);

        // HLP safety buffer = 1 + ((80,000 - 80,000) / 80,000) = 1
        vm.expectRevert(abi.encodeWithSignature("ITradeService_HlpHealthy()"));
        botHandler.deleverage(
            ALICE,
            0,
            btcMarketIndex,
            address(usdt),
            priceUpdateData,
            publishTimeUpdateData,
            block.timestamp,
            keccak256("someEncodedVaas")
        );
    }
}
