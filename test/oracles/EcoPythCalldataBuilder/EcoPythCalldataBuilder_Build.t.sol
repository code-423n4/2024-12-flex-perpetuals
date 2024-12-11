// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

import {EcoPythCalldataBuilder_BaseTest} from "@hmx-test/oracles/EcoPythCalldataBuilder/EcoPythCalldataBuilder_BaseTest.t.sol";
import {IEcoPythCalldataBuilder} from "@hmx/oracles/interfaces/IEcoPythCalldataBuilder.sol";
import {PythStructs} from "pyth-sdk-solidity/IPyth.sol";

contract EcoPythCalldataBuilder_BuildTest is EcoPythCalldataBuilder_BaseTest {
    function setUp() public override {
        super.setUp();

        ecoPyth.insertAssetId("0");
        ecoPyth.insertAssetId("1");
        ecoPyth.insertAssetId("GLP");

        // Initialized prices
        int24[] memory _prices = new int24[](3);
        _prices[0] = int24(0);
        _prices[1] = int24(98527);
        _prices[2] = int24(0);
        bytes32[] memory priceUpdateDatas = ecoPyth.buildPriceUpdateData(_prices);
        uint24[] memory _publishTime = new uint24[](3);
        _publishTime[0] = uint24(0);
        _publishTime[1] = uint24(0);
        _publishTime[2] = uint24(0);
        bytes32[] memory publishTimeUpdateDatas = ecoPyth.buildPublishTimeUpdateData(_publishTime);
        ecoPyth.updatePriceFeeds(priceUpdateDatas, publishTimeUpdateDatas, 1600, keccak256("pyth"));

        // Assuming GLP price is 1
        mockGlpManager.setMinAum(1e30);
        mockGlpManager.setMaxAum(1e30);
    }

    function testRevert_WhenNewPriceLessThanAllowDiff() external {
        // Assuming the new price of "0" is 0.49999999 which less than maxDiffBps
        IEcoPythCalldataBuilder.BuildData[] memory _data = new IEcoPythCalldataBuilder.BuildData[](2);
        _data[0] = IEcoPythCalldataBuilder.BuildData({
            assetId: "0",
            priceE8: 49999999,
            publishTime: 0,
            maxDiffBps: 15000
        });
        _data[1] = IEcoPythCalldataBuilder.BuildData({
            assetId: "1",
            priceE8: 19_000.25 * 10 ** 8,
            publishTime: 0,
            maxDiffBps: 15000
        });

        // Expect revert
        vm.expectRevert("OVER_DIFF");
        ecoPythCalldataBuilder.build(_data);
    }

    function testRevert_WhenNewPriceMoreThanAllowDiff() external {
        // Assuming the new price of "0" is 1.50000001 which more than maxDiffBps
        IEcoPythCalldataBuilder.BuildData[] memory _data = new IEcoPythCalldataBuilder.BuildData[](2);
        _data[0] = IEcoPythCalldataBuilder.BuildData({
            assetId: "0",
            priceE8: 150000001,
            publishTime: 0,
            maxDiffBps: 15000
        });
        _data[1] = IEcoPythCalldataBuilder.BuildData({
            assetId: "1",
            priceE8: 19_000.25 * 10 ** 8,
            publishTime: 0,
            maxDiffBps: 15000
        });

        // Expect revert
        vm.expectRevert("OVER_DIFF");
        ecoPythCalldataBuilder.build(_data);
    }

    function testCorrectness_WhenNewPriceIsValid() external {
        IEcoPythCalldataBuilder.BuildData[] memory _data = new IEcoPythCalldataBuilder.BuildData[](3);
        _data[0] = IEcoPythCalldataBuilder.BuildData({
            assetId: "0",
            priceE8: 1.5 * 10 ** 8,
            publishTime: 1688,
            maxDiffBps: 15000
        });
        _data[1] = IEcoPythCalldataBuilder.BuildData({
            assetId: "1",
            priceE8: 19_000.25 * 10 ** 8,
            publishTime: 1689,
            maxDiffBps: 15000
        });
        _data[2] = IEcoPythCalldataBuilder.BuildData({
            assetId: "GLP",
            priceE8: 1.01 * 1e8,
            publishTime: 0,
            maxDiffBps: 15000
        });

        (
            uint256 _minPublishTimestamp,
            bytes32[] memory _priceUpdateDatas,
            bytes32[] memory _publishTimeDiffDatas
        ) = ecoPythCalldataBuilder.build(_data);
        ecoPyth.updatePriceFeeds(_priceUpdateDatas, _publishTimeDiffDatas, _minPublishTimestamp, keccak256("pyth"));

        PythStructs.Price memory _priceInfo = ecoPyth.getPriceUnsafe("0");
        assertEq(_priceInfo.price, int64(149987194));
        assertEq(_priceInfo.publishTime, 1688);

        _priceInfo = ecoPyth.getPriceUnsafe("1");
        assertEq(_priceInfo.price, int64(1900024965577));
        assertEq(_priceInfo.publishTime, 1689);

        // This should be overrided by the price from GLP Manager
        _priceInfo = ecoPyth.getPriceUnsafe("GLP");
        assertEq(_priceInfo.price, int64(100000000));
        assertEq(_priceInfo.publishTime, 0);
    }
}
