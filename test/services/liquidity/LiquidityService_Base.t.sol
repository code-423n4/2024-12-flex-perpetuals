// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {BaseTest} from "@hmx-test/base/BaseTest.sol";
import {Deployer} from "@hmx-test/libs/Deployer.sol";

import {ILiquidityService} from "@hmx/services/interfaces/ILiquidityService.sol";

abstract contract LiquidityService_Base is BaseTest {
    ILiquidityService liquidityService;

    function setUp() public virtual {
        // deploy liquidity service
        liquidityService = Deployer.deployLiquidityService(
            address(proxyAdmin),
            address(perpStorage),
            address(vaultStorage),
            address(configStorage)
        );

        // set this Test to be service executor
        configStorage.setServiceExecutor(address(liquidityService), address(this), true);
        configStorage.setConfigExecutor(address(this), true);
        vaultStorage.setServiceExecutors(address(liquidityService), true);

        hlp.setMinter(address(liquidityService), true);
    }
}
