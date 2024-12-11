pragma solidity ^0.8.18;

import {Chains} from "@hmx-test/base/Chains.sol";
import {ConfigEnv} from "./ConfigEnv.sol";
import {console} from "forge-std/console.sol";
import {console2} from "forge-std/console2.sol";
import {Deployer} from "@hmx-test/libs/Deployer.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {StdStorage, stdStorage} from "forge-std/StdStorage.sol";
import {Test} from "forge-std/Test.sol";
import {Uint2str} from "@hmx-test/libs/Uint2str.sol";

import {ConfigStorage} from "@hmx/storages/ConfigStorage.sol";

contract DynamicForkBaseTest is Test {
    using stdStorage for StdStorage;
    using Uint2str for uint256;

    StdStorage stdStore;

    address internal constant REWARD_DISTRIBUTOR_FEEDER = 0xddfb5a5D0eF7311E1D706912C38C809Ac1e469d0; // Bot address, hardcoded to check that it's not changed

    address internal ALICE;
    address internal BOB;
    address internal CAROL;
    address internal DAVE;
    address internal FEEVER;
    address internal FEEDER;
    address internal BOT;
    address internal multiSig;
    address internal deployer;
    address internal testUser1;

    ProxyAdmin internal proxyAdmin;

    ConfigEnv internal config;

    bool internal isForkSupported = true;

    ConfigStorage internal configStorage;

    modifier onlyBaseMainnetChain() {
        vm.skip(block.chainid != Chains.BASE_MAINNET_CHAIN_ID);
        _;
    }

    modifier onlyFork() {
        vm.skip(!isForkSupported);
        _;
    }

    function setUp() public virtual {
        ALICE = makeAddr("Alice");
        BOB = makeAddr("BOB");
        CAROL = makeAddr("CAROL");
        DAVE = makeAddr("DAVE");
        FEEVER = makeAddr("FEEVER");
        FEEDER = makeAddr("FEEDER");

        config = new ConfigEnv(block.chainid, vm);

        if (block.chainid == Chains.BASE_MAINNET_CHAIN_ID) {
            _setupBaseCommonChain();
            _setUpBaseMainnetChain();
        } else if (block.chainid == Chains.BASE_SEPOLIA_CHAIN_ID) {
            _setupBaseCommonChain();
            _setUpBaseSepoliaChain();
        } else {
            isForkSupported = false;
        }
    }

    function _setupBaseCommonChain() private {
        multiSig = config.getAddress(".safe");
        proxyAdmin = ProxyAdmin(config.getAddress(".proxyAdmin"));

        configStorage = ConfigStorage(config.getAddress(".storages.config"));
    }

    function _setUpBaseSepoliaChain() private {
        deployer = 0xf0d00E8435E71df33bdA19951B433B509A315aee;
        testUser1 = 0xddf12401Eeb58b76b9158429132183B1ed21A602;
    }

    function _setUpBaseMainnetChain() private {}
}
