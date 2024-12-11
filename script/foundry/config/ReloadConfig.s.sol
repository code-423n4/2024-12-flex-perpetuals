// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {ConfigJsonRepo} from "@hmx-script/foundry/utils/ConfigJsonRepo.s.sol";
import {ITradeService} from "@hmx/services/interfaces/ITradeService.sol";
import {Calculator} from "@hmx/contracts/Calculator.sol";

contract ReloadConfig is ConfigJsonRepo {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ITradeService tradeHelper = ITradeService(getJsonAddress(".helpers.trade"));
        ITradeService liquidationService = ITradeService(getJsonAddress(".services.liquidation"));
        ITradeService tradeService = ITradeService(getJsonAddress(".services.trade"));
        Calculator calculator = Calculator(getJsonAddress(".calculator"));

        tradeHelper.reloadConfig();
        liquidationService.reloadConfig();
        tradeService.reloadConfig();
        calculator.setOracle(getJsonAddress(".oracles.middleware"));

        vm.stopBroadcast();
    }
}
