// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {ILimitTradeHandler} from "@hmx/handlers/interfaces/ILimitTradeHandler.sol";

contract MockAccountAbstraction {
    address public owner;
    address public entryPoint;

    constructor(address _entryPoint) {
        owner = msg.sender;
        entryPoint = _entryPoint;
    }

    function setOwner(address _owner) external {
        owner = _owner;
    }

    function setEntryPoint(address _entryPoint) external {
        entryPoint = _entryPoint;
    }

    function _requireFromEntryPointOrOwner() internal view {
        require(msg.sender == address(entryPoint) || msg.sender == owner, "account: not Owner or EntryPoint");
    }

    function createOrder(
        address target,
        address _mainAccount,
        uint8 _subAccountId,
        uint256 _marketIndex,
        int256 _sizeDelta,
        uint256 _triggerPrice,
        uint256 _acceptablePrice,
        bool _triggerAboveThreshold,
        uint256 _executionFee,
        bool _reduceOnly,
        address _tpToken
    ) external payable {
        _requireFromEntryPointOrOwner();
        ILimitTradeHandler(target).createOrder{value: msg.value}(
            _mainAccount,
            _subAccountId,
            _marketIndex,
            _sizeDelta,
            _triggerPrice,
            _acceptablePrice,
            _triggerAboveThreshold,
            _executionFee,
            _reduceOnly,
            _tpToken
        );
    }
}
