// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {MockErc20} from "@hmx-test/mocks/MockErc20.sol";
import {BaseTest} from "@hmx-test/base/BaseTest.sol";
import {Deployer} from "@hmx-test/libs/Deployer.sol";
import {ITradingStaking} from "@hmx/staking/interfaces/ITradingStaking.sol";
import {PerpStorage} from "@hmx/storages/PerpStorage.sol";
import {IPerpStorage} from "@hmx/storages/interfaces/IPerpStorage.sol";
import {console2} from "forge-std/console2.sol";

abstract contract PerpStorage_Base is BaseTest {
    PerpStorage internal pStorage;

    function setUp() public virtual {
        pStorage = PerpStorage(address(Deployer.deployPerpStorage(address(proxyAdmin))));
        pStorage.setServiceExecutors(address(this), true);
    }

    function _savePosition(address _subAccount, bytes32 _positionId) internal {
        IPerpStorage.Position memory _position;
        _position.positionSizeE30 = 1 ether;
        pStorage.savePosition(_subAccount, _positionId, _position);
    }

    function _removePosition(address _subAccount, bytes32 _positionId) internal {
        pStorage.removePositionFromSubAccount(_subAccount, _positionId);
    }
}
