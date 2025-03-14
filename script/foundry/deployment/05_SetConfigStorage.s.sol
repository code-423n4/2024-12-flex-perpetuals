// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {ConfigJsonRepo} from "@hmx-script/foundry/utils/ConfigJsonRepo.s.sol";

import {IConfigStorage} from "@hmx/storages/interfaces/IConfigStorage.sol";

contract SetConfigStorage is ConfigJsonRepo {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        IConfigStorage configStorage = IConfigStorage(getJsonAddress(".storages.config"));
        address calculatorAddress = getJsonAddress(".calculator");
        address hlpAddress = getJsonAddress(".tokens.hlp");
        address wethAddress = getJsonAddress(".tokens.weth");
        address oracleMiddlewareAddress = getJsonAddress(".oracles.middleware");

        configStorage.setCalculator(calculatorAddress);
        configStorage.setHLP(hlpAddress);
        configStorage.setOracle(oracleMiddlewareAddress);
        configStorage.setWeth(wethAddress);

        vm.stopBroadcast();
    }
}
