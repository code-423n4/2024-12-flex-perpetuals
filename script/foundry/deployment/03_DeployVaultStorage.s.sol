// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {ConfigJsonRepo} from "@hmx-script/foundry/utils/ConfigJsonRepo.s.sol";
import {VaultStorage} from "@hmx/storages/VaultStorage.sol";
import {Deployer} from "@hmx-test/libs/Deployer.sol";

contract DeployVaultStorage is ConfigJsonRepo {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        address proxyAdmin = getJsonAddress(".proxyAdmin");

        vm.startBroadcast(deployerPrivateKey);

        address vaultStorageAddress = address(Deployer.deployVaultStorage(address(proxyAdmin)));

        vm.stopBroadcast();

        updateJson(".storages.vault", vaultStorageAddress);
    }
}
