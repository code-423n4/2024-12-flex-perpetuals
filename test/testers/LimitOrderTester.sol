// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {StdAssertions} from "forge-std/StdAssertions.sol";

import {ILimitTradeHandler} from "@hmx/handlers/interfaces/ILimitTradeHandler.sol";

contract LimitOrderTester is StdAssertions {
    struct LimitOrderAssertData {
        address account;
        address tpToken;
        bool triggerAboveThreshold;
        bool reduceOnly;
        int256 sizeDelta;
        uint8 subAccountId;
        uint256 marketIndex;
        uint256 triggerPrice;
        uint256 acceptablePrice;
        uint256 executionFee;
    }

    ILimitTradeHandler limitTradeHandler;

    constructor(ILimitTradeHandler _handler) {
        limitTradeHandler = _handler;
    }

    function assertLimitOrder(
        address _subAccount,
        uint256 _orderIndex,
        LimitOrderAssertData calldata _expected
    ) external {
        ILimitTradeHandler.LimitOrder memory _limitOrder;
        // separate scope to prevent stack too deep
        {
            (
                _limitOrder.account,
                _limitOrder.tpToken,
                _limitOrder.triggerAboveThreshold,
                _limitOrder.reduceOnly,
                _limitOrder.sizeDelta,
                _limitOrder.subAccountId,
                ,
                _limitOrder.marketIndex,
                _limitOrder.triggerPrice,
                ,
                ,

            ) = limitTradeHandler.limitOrders(_subAccount, _orderIndex);
        }
        {
            (, , , , , , , , , , _limitOrder.executionFee, ) = limitTradeHandler.limitOrders(_subAccount, _orderIndex);
        }
        assertEq(_limitOrder.account, _expected.account, "check account in order");
        assertEq(_limitOrder.tpToken, _expected.tpToken, "check tpToken in order");
        assertEq(
            _limitOrder.triggerAboveThreshold,
            _expected.triggerAboveThreshold,
            "check triggerAboveThreshold in order"
        );
        assertEq(_limitOrder.reduceOnly, _expected.reduceOnly, "check reduceOnly in order");
        assertEq(_limitOrder.sizeDelta, _expected.sizeDelta, "check sizeDelta in order");
        assertEq(_limitOrder.subAccountId, _expected.subAccountId, "check subAccountId in order");
        assertEq(_limitOrder.marketIndex, _expected.marketIndex, "check marketIndex in order");
        assertEq(_limitOrder.triggerPrice, _expected.triggerPrice, "check triggerPrice in order");
        assertEq(_limitOrder.executionFee, _expected.executionFee, "check executionFee in order");
    }
}
