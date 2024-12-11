// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;
import {IGmxRewardRouterV2} from "@hmx/interfaces/gmx/IGmxRewardRouterV2.sol";

contract MockGmxRewardRouterV2 is IGmxRewardRouterV2 {
    function mintAndStakeGlp(
        address /*_token*/,
        uint256 /*_amount*/,
        uint256 /*_minUsdg*/,
        uint256 /*_minGlp*/
    ) external pure returns (uint256) {
        return 0;
    }

    function mintAndStakeGlpETH(uint256 /*_minUsdg*/, uint256 /*_minGlp*/) external payable returns (uint256) {
        return 0;
    }

    function unstakeAndRedeemGlp(
        address /*_tokenOut*/,
        uint256 /*_glpAmount*/,
        uint256 /*_minOut*/,
        address /*_receiver*/
    ) external pure returns (uint256) {
        return 0;
    }
}
