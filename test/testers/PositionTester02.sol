// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {IPerpStorage} from "@hmx/storages/interfaces/IPerpStorage.sol";

import {StdAssertions} from "forge-std/StdAssertions.sol";

contract PositionTester02 is StdAssertions {
    struct PositionAssertionData {
        int256 size;
        uint256 avgPrice;
        uint256 reserveValue;
        uint256 lastIncreaseTimestamp;
    }

    IPerpStorage perpStorage;

    constructor(IPerpStorage _perpStorage) {
        perpStorage = _perpStorage;
    }

    function assertPosition(bytes32 _positionId, PositionAssertionData memory _data) external {
        IPerpStorage.Position memory _position = perpStorage.getPositionById(_positionId);

        assertEq(_position.positionSizeE30, _data.size, "position size");
        assertEq(_position.avgEntryPriceE30, _data.avgPrice, "avg entry price ");
        assertEq(_position.reserveValueE30, _data.reserveValue, "reserve value");
        assertEq(_position.lastIncreaseTimestamp, _data.lastIncreaseTimestamp, "last increase timestamp");
    }
}
