// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import {stdJson} from "forge-std/StdJson.sol";
import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";

import {Chains} from "@hmx-test/base/Chains.sol";

contract ConfigEnv {
    string public json;

    using stdJson for string;

    constructor(uint256 chainId, Vm vm) {
        if (chainId == Chains.BASE_MAINNET_CHAIN_ID) {
            _loadBaseMainnetConfig(vm);
        } else if (chainId == Chains.BASE_SEPOLIA_CHAIN_ID) {
            _loadBaseSepoliaConfig(vm);
        } else {
            // Skip fork if chain is not supported
            //      revert("ConfigEnv: fork chain not supported or empty");
        }
    }

    function getAddress(string memory key) public view returns (address _value) {
        bytes memory _bytes = json.parseRaw(key);
        require(_bytes.length > 0, string(abi.encodePacked("ConfigEnv: key not found - ", key)));
        return abi.decode(_bytes, (address));
    }

    function _loadBaseMainnetConfig(Vm vm) private {
        json = vm.readFile("configs/base.mainnet.json");
    }

    function _loadBaseSepoliaConfig(Vm vm) private {
        json = vm.readFile("configs/base.sepolia.json");
    }
}
