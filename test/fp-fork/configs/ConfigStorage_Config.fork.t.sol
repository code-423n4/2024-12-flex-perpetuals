// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {console} from "forge-std/Test.sol";
import {SafeCastUpgradeable} from "@openzeppelin-upgradeable/contracts/utils/math/SafeCastUpgradeable.sol";
import {IRewarder} from "@hmx/staking/interfaces/IRewarder.sol";
import {DynamicForkBaseTest} from "../bases/DynamicForkBaseTest.sol";

contract ConfigStorage_Config is DynamicForkBaseTest {
    using SafeCastUpgradeable for uint256;

    function setUp() public override {
        super.setUp();
    }

    function testCorrectness_configStorage_config() external {
        assertEq(configStorage.getTradeServiceHooks().length, 1);
    }
}
