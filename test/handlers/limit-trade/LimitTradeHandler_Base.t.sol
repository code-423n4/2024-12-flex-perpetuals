// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {Deployer} from "@hmx-test/libs/Deployer.sol";
import {BaseTest, IPerpStorage, IConfigStorage} from "@hmx-test/base/BaseTest.sol";
import {LimitOrderTester} from "@hmx-test/testers/LimitOrderTester.sol";
import {ILimitTradeHandler} from "@hmx/handlers/interfaces/ILimitTradeHandler.sol";
import {MockAccountAbstraction} from "../../mocks/MockAccountAbstraction.sol";
import {MockEntryPoint} from "../../mocks/MockEntryPoint.sol";

contract LimitTradeHandler_Base is BaseTest {
    uint8 internal constant INCREASE = 0;
    uint8 internal constant DECREASE = 1;

    ILimitTradeHandler limitTradeHandler;
    LimitOrderTester limitOrderTester;
    MockEntryPoint entryPoint;

    function setUp() public virtual {
        limitTradeHandler = Deployer.deployLimitTradeHandler(
            address(proxyAdmin),
            address(weth),
            address(mockTradeService),
            address(ecoPyth),
            0.1 ether,
            5 * 60
        );

        mockTradeService.setConfigStorage(address(configStorage));
        mockTradeService.setPerpStorage(address(mockPerpStorage));

        limitOrderTester = new LimitOrderTester(limitTradeHandler);

        ecoPyth.setUpdater(address(limitTradeHandler), true);

        limitTradeHandler.setGuaranteeLimitPrice(true);

        entryPoint = new MockEntryPoint();
    }

    // =========================================
    // | ------- common function ------------- |
    // =========================================

    function _getSubAccount(address primary, uint8 subAccountId) internal pure returns (address) {
        return address(uint160(primary) ^ uint160(subAccountId));
    }
}
