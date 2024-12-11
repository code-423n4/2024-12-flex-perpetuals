// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {ConfigJsonRepo} from "@hmx-script/foundry/utils/ConfigJsonRepo.s.sol";
import {EcoPyth} from "@hmx/oracles/EcoPyth.sol";
import {IConfigStorage} from "@hmx/storages/interfaces/IConfigStorage.sol";

contract SetTradingHooks is ConfigJsonRepo {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        IConfigStorage configStorage = IConfigStorage(getJsonAddress(".storages.config"));
        address tradingStakingHook = getJsonAddress(".hooks.tradingStaking");
        address tlcStakingHook = getJsonAddress(".hooks.tlc");

        address[] memory hooks = new address[](2);
        hooks[0] = tradingStakingHook;
        hooks[1] = tlcStakingHook;

        vm.startBroadcast(deployerPrivateKey);
        configStorage.setTradeServiceHooks(hooks);
        vm.stopBroadcast();
    }
}
