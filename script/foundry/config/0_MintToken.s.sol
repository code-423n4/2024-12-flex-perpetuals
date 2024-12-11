// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {ConfigJsonRepo} from "@hmx-script/foundry/utils/ConfigJsonRepo.s.sol";
import {ConfigStorage} from "@hmx/storages/ConfigStorage.sol";
import {MockErc20} from "@hmx-test/mocks/MockErc20.sol";

// for local only
contract MintToken is ConfigJsonRepo {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MockErc20 token = MockErc20(getJsonAddress(".tokens.wbtc"));
        token.mint(0x6629eC35c8Aa279BA45Dbfb575c728d3812aE31a, 10_000_000 * 1e8);

        vm.stopBroadcast();
    }
}
