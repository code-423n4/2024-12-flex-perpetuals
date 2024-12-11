// SPDX-License-Identifier: BUSL-1.1
// This code is made available under the terms and conditions of the Business Source License 1.1 (BUSL-1.1).
// The act of publishing this code is driven by the aim to promote transparency and facilitate its utilization for educational purposes.

pragma solidity 0.8.18;

// bases
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// interfaces
import {IRouter} from "@hmx/interfaces/aerodrome/IRouter.sol";
import {IDexter} from "@hmx/extensions/dexters/interfaces/IDexter.sol";

contract AerodromeDexter is Ownable, IDexter {
    using SafeERC20 for ERC20;

    error AerodromeRouterSwitchCollateralExt_BadPath();

    IRouter public router;
    mapping(address => mapping(address => IRouter.Route[])) public routeOf;

    event LogSetRouteOf(
        address indexed tokenIn,
        address indexed tokenOut,
        IRouter.Route[] prevPath,
        IRouter.Route[] path
    );

    constructor(address _router) {
        router = IRouter(_router);
    }

    /// @notice Run the extension logic to swap on Uniswap V3.
    /// @param _tokenIn The token to swap from.
    /// @param _tokenOut The token to swap to.
    /// @param _amountIn The amount of _tokenIn to swap.
    function run(
        address _tokenIn,
        address _tokenOut,
        uint256 _amountIn
    ) external override returns (uint256 _amountOut) {
        // Check
        if (routeOf[_tokenIn][_tokenOut].length == 0) {
            revert AerodromeRouterSwitchCollateralExt_BadPath();
        }

        // Approve tokenIn to Router if needed
        ERC20 _tIn = ERC20(_tokenIn);
        if (_tIn.allowance(address(this), address(router)) < _amountIn)
            _tIn.safeApprove(address(router), type(uint256).max);
        // Approve UniUniversalRouter to spend tokenIn in Permit2 if needed

        uint256 _balanceBefore = ERC20(_tokenOut).balanceOf(address(this));
        router.swapExactTokensForTokens(_amountIn, 0, routeOf[_tokenIn][_tokenOut], address(this), block.timestamp);
        _amountOut = ERC20(_tokenOut).balanceOf(address(this)) - _balanceBefore;

        // Transfer tokenOut back to msg.sender
        ERC20(_tokenOut).safeTransfer(msg.sender, _amountOut);
    }

    /*
     * Setters
     */

    /// @notice Set swap route from tokenIn to tokenOut
    /// @dev It will also add reverse path from tokenOut to tokenIn
    /// @param _tokenIn The token to swap from
    /// @param _tokenOut The token to swap to
    /// @param _route The swap route
    function setRouteOf(address _tokenIn, address _tokenOut, IRouter.Route[] calldata _route) external onlyOwner {
        // Emit the event with the current old route
        emit LogSetRouteOf(_tokenIn, _tokenOut, routeOf[_tokenIn][_tokenOut], _route);

        // Delete the old route
        delete routeOf[_tokenIn][_tokenOut];

        // Copy the new route from calldata to storage
        for (uint256 i = 0; i < _route.length; i++) {
            routeOf[_tokenIn][_tokenOut].push(_route[i]);
        }
    }
}
