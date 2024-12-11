// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {BaseIntTest_WithActions} from "@hmx-test/integration/99_BaseIntTest_WithActions.i.sol";

contract BotHandler_CheckLiquidation is BaseIntTest_WithActions {
    function testIntegration_WhenCallCheckLiquidation() external {
        // set new trust price age
        uint32 _confidenceThresholdE6 = 2500; // 2.5% for test only
        uint32 _trustPriceAge = 15; // 15 seconds

        oracleMiddleWare.setAssetPriceConfig(wethAssetId, _confidenceThresholdE6, _trustPriceAge, address(pythAdapter));
        oracleMiddleWare.setAssetPriceConfig(wbtcAssetId, _confidenceThresholdE6, _trustPriceAge, address(pythAdapter));
        oracleMiddleWare.setAssetPriceConfig(daiAssetId, _confidenceThresholdE6, _trustPriceAge, address(pythAdapter));
        oracleMiddleWare.setAssetPriceConfig(usdcAssetId, _confidenceThresholdE6, _trustPriceAge, address(pythAdapter));
        oracleMiddleWare.setAssetPriceConfig(usdtAssetId, _confidenceThresholdE6, _trustPriceAge, address(pythAdapter));
        oracleMiddleWare.setAssetPriceConfig(
            appleAssetId,
            _confidenceThresholdE6,
            _trustPriceAge,
            address(pythAdapter)
        );
        oracleMiddleWare.setAssetPriceConfig(jpyAssetId, _confidenceThresholdE6, _trustPriceAge, address(pythAdapter));

        vm.deal(ALICE, 1 ether);
        /**
         * T0: Initialized state
         */
        vm.warp(block.timestamp + 100);
        uint8 SUB_ACCOUNT_ID = 1;
        address SUB_ACCOUNT = getSubAccount(ALICE, SUB_ACCOUNT_ID);
        address TP_TOKEN = address(wbtc); // @note settle with WBTC that be treated as GLP token
        // Make LP contains some liquidity
        {
            vm.deal(BOB, 1 ether); //deal with out of gas
            wbtc.mint(BOB, 10 * 1e8);
            addLiquidity(BOB, wbtc, 10 * 1e8, executionOrderFee, tickPrices, publishTimeDiff, block.timestamp, true);
        }
        // Mint tokens to Alice
        {
            // Mint USDT token to ALICE
            usdt.mint(ALICE, 100_000 * 1e6);
            // Mint USDC token to ALICE
            usdc.mint(ALICE, 100_000 * 1e6);
            // Mint WBTC token to ALICE
            wbtc.mint(ALICE, 0.5 * 1e8);
            assertEq(usdt.balanceOf(ALICE), 100_000 * 1e6, "USDT Balance Of");
            assertEq(usdc.balanceOf(ALICE), 100_000 * 1e6, "USDC Balance Of");
            assertEq(wbtc.balanceOf(ALICE), 0.5 * 1e8, "WBTC Balance Of");
        }

        /**
         * T1: Alice deposits 100,000(USD) USDT, 100,000(USD) USDC and 10,000(USD) WBTC as collaterals
         */
        vm.warp(block.timestamp + 100);
        {
            // Before Alice start depositing, VaultStorage must has 0 amount of all collateral tokens
            assertEq(vaultStorage.traderBalances(SUB_ACCOUNT, address(usdt)), 0, "ALICE's USDT Balance");
            assertEq(vaultStorage.traderBalances(SUB_ACCOUNT, address(usdc)), 0, "ALICE's USDC Balance");
            assertEq(vaultStorage.traderBalances(SUB_ACCOUNT, address(wbtc)), 0, "ALICE's WBTC Balance");
            assertEq(usdt.balanceOf(address(vaultStorage)), 0, "Vault's USDT Balance");
            assertEq(usdc.balanceOf(address(vaultStorage)), 0, "Vault's USDC Balance");
            assertEq(wbtc.balanceOf(address(vaultStorage)), 10 * 1e8, "Vault's WBTC Balance");
            // Alice deposits 100,000(USD) of USDT
            depositCollateral(ALICE, SUB_ACCOUNT_ID, usdt, 100_000 * 1e6);
            // Alice deposits 100,000(USD) of USDC
            depositCollateral(ALICE, SUB_ACCOUNT_ID, usdc, 100_000 * 1e6);
            // Alice deposits 10,000(USD) of WBTC
            depositCollateral(ALICE, SUB_ACCOUNT_ID, wbtc, 0.5 * 1e8);
            // After Alice deposited all collaterals, VaultStorage must contain some tokens
            assertEq(vaultStorage.traderBalances(SUB_ACCOUNT, address(usdt)), 100_000 * 1e6, "ALICE's USDT Balance");
            assertEq(vaultStorage.traderBalances(SUB_ACCOUNT, address(usdc)), 100_000 * 1e6, "ALICE's USDC Balance");
            assertEq(vaultStorage.traderBalances(SUB_ACCOUNT, address(wbtc)), 0.5 * 1e8, "ALICE's WBTC Balance");
            assertEq(usdt.balanceOf(address(vaultStorage)), 100_000 * 1e6, "Vault's USDT Balance");
            assertEq(usdc.balanceOf(address(vaultStorage)), 100_000 * 1e6, "Vault's USDC Balance");
            assertEq(wbtc.balanceOf(address(vaultStorage)), (0.5 + 10) * 1e8, "Vault's WBTC Balance");
            // After Alice deposited all collaterals, Alice must have no token left
            assertEq(usdt.balanceOf(ALICE), 0, "USDT Balance Of");
            assertEq(usdc.balanceOf(ALICE), 0, "USDC Balance Of");
            assertEq(wbtc.balanceOf(ALICE), 0, "WBTC Balance Of");
        }

        /**
         * T2: Alice open short ETHUSD at 2000.981234381823 USD, priced at 1500 USD
         */
        {
            // Check states Before Alice opening SHORT position
            // Calculate assert data
            // ALICE's Equity = 100_000 + 100_000 + 8_000 = 208_000 USD
            //   | WETH collateral value = amount * price * collateralFactor = 100_000 * 1 * 1 = 100_000
            //   | USDC collateral value = amount * price * collateralFactor = 100_000 * 1 * 1 = 100_000
            //   | WBTC collateral value = amount * price * collateralFactor = 0.5 * 20_000 * 0.8 = 8_000
            // ALICE's IMR & MMR must be 0
            assertEq(calculator.getIMR(SUB_ACCOUNT), 0, "ALICE's IMR");
            assertEq(calculator.getMMR(SUB_ACCOUNT), 0, "ALICE's MMR");
            uint256 sellSizeE30 = 280_000.981234381823 * 1e30;
            // ALICE opens SHORT position with WETH Market Price = 1500 USD
            marketSell(
                ALICE,
                SUB_ACCOUNT_ID,
                wethMarketIndex,
                sellSizeE30,
                TP_TOKEN,
                tickPrices,
                publishTimeDiff,
                block.timestamp
            );
            // Check states After Alice opened SHORT position
            // Alice's Equity must be upper IMR level
            assertTrue(
                uint256(calculator.getEquity(SUB_ACCOUNT, 0, 0)) > calculator.getIMR(SUB_ACCOUNT),
                "ALICE's Equity > ALICE's IMR?"
            );
        }

        /**
         * T3: Try calling check liquidate on ALICE's account with injected prices -> not liquidate
         */
        vm.warp(block.timestamp + 100);
        {
            bytes32[] memory assetIds = new bytes32[](7);
            assetIds[0] = 0x5745544855534400000000000000000000000000000000000000000000000000; // WETHUSD
            assetIds[1] = 0x5742544355534400000000000000000000000000000000000000000000000000; // BTCUSD
            assetIds[2] = 0x4441490000000000000000000000000000000000000000000000000000000000; // DAI
            assetIds[3] = 0x5553444355534400000000000000000000000000000000000000000000000000; // USDCUSD
            assetIds[4] = 0x5553445455534400000000000000000000000000000000000000000000000000; // USDTUSD
            assetIds[5] = 0x4141504c00000000000000000000000000000000000000000000000000000000; // AAPL
            assetIds[6] = 0x4a50590000000000000000000000000000000000000000000000000000000000; // JPY

            uint256[] memory prices = new uint256[](7);
            prices[0] = 0x59e9218cf46b6a69470e08000000; // 1823.605
            prices[1] = 0x0542c53c815869e31d0bba70000000; // 27315.75
            prices[2] = 0x0c9f13cc110438ea1162000000; // 0.99997
            prices[3] = 0x0c9f21fff494e1eb3ee9400000; // 0.99998717
            prices[4] = 0x0c9f203470a556ebfdd1000000; // 0.999985
            prices[5] = 0x0883a77bfb5616897d8c50000000; // 172.69
            prices[6] = 0x06c791d94f4996b0cabed0000000; // 137.506

            // Check states
            // Alice's Equity must be upper IMR level
            // Equity = 199432.21863017822
            // IMR = 1400.0049061719092
            vm.expectRevert(abi.encodeWithSignature("IOracleMiddleware_PriceStale()"));
            calculator.getEquity(SUB_ACCOUNT, 0, 0);

            bool isShouldLiquidate = botHandler.checkLiquidation(SUB_ACCOUNT, assetIds, prices);
            assertFalse(isShouldLiquidate);
        }

        /**
         * T4: Try injecting ETH price according ALICE is now opening short position on ETH market
         */
        vm.warp(block.timestamp + 100);
        {
            bytes32[] memory assetIds = new bytes32[](7);
            assetIds[0] = 0x5745544855534400000000000000000000000000000000000000000000000000; // WETHUSD
            assetIds[1] = 0x5742544355534400000000000000000000000000000000000000000000000000; // BTCUSD
            assetIds[2] = 0x4441490000000000000000000000000000000000000000000000000000000000; // DAI
            assetIds[3] = 0x5553444355534400000000000000000000000000000000000000000000000000; // USDCUSD
            assetIds[4] = 0x5553445455534400000000000000000000000000000000000000000000000000; // USDTUSD
            assetIds[5] = 0x4141504c00000000000000000000000000000000000000000000000000000000; // AAPL
            assetIds[6] = 0x4a50590000000000000000000000000000000000000000000000000000000000; // JPY

            uint256[] memory prices = new uint256[](7);
            prices[0] = 0x7B426FAB61F010A9EE89BB140000; // 2500 <<<<< Increase ETH price (increase Alice's loss on Pnl)
            prices[1] = 0x0542c53c815869e31d0bba70000000; // 27315.75
            prices[2] = 0x0c9f13cc110438ea1162000000; // 0.99997
            prices[3] = 0xABA7F854AA249CA3A50000000; // 0.85 <<<<< Decrease USDC price (decrease Alice's collateral value)
            prices[4] = 0xB9CAE29DE554CDAE1C0000000; // 0.92 <<<<< Decrease USDT price (decrease Alice's collateral value)
            prices[5] = 0x0883a77bfb5616897d8c50000000; // 172.69
            prices[6] = 0x06c791d94f4996b0cabed0000000; // 137.506

            // Check states
            // Alice's Equity must be lower IMR level
            // Equity = 477.9248314849694
            // IMR = 1400.0049061719092
            vm.expectRevert(abi.encodeWithSignature("IOracleMiddleware_PriceStale()"));
            calculator.getEquity(SUB_ACCOUNT, 0, 0);

            bool isShouldLiquidate = botHandler.checkLiquidation(SUB_ACCOUNT, assetIds, prices);
            assertTrue(isShouldLiquidate);
        }
    }
}
