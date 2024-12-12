# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 6 |
| [GAS-2](#GAS-2) | Use assembly to check for `address(0)` | 14 |
| [GAS-3](#GAS-3) | Comparing to a Boolean constant | 1 |
| [GAS-4](#GAS-4) | Using bools for storage incurs overhead | 10 |
| [GAS-5](#GAS-5) | Cache array length outside of loop | 9 |
| [GAS-6](#GAS-6) | State variables should be cached in stack variables rather than re-reading them from storage | 1 |
| [GAS-7](#GAS-7) | Use calldata instead of memory for function arguments that do not get mutated | 7 |
| [GAS-8](#GAS-8) | For Operations that will not overflow, you could use unchecked | 95 |
| [GAS-9](#GAS-9) | Avoid contract existence checks by using low level calls | 3 |
| [GAS-10](#GAS-10) | Stack variable used as a cheaper cache for a state variable is only used once | 1 |
| [GAS-11](#GAS-11) | State variables only set in the constructor should be declared `immutable` | 1 |
| [GAS-12](#GAS-12) | Functions guaranteed to revert when called by normal users can be marked `payable` | 36 |
| [GAS-13](#GAS-13) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 1 |
| [GAS-14](#GAS-14) | Using `private` rather than `public` for constants, saves gas | 3 |
| [GAS-15](#GAS-15) | `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas | 2 |
| [GAS-16](#GAS-16) | Increments/decrements can be unchecked in for-loops | 1 |
| [GAS-17](#GAS-17) | WETH address definition can be use directly | 1 |
### <a name="GAS-1"></a>[GAS-1] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)
This saves **16 gas per instance.**

*Instances (6)*:
```solidity
File: src/storages/ConfigStorage.sol

300:             hlpTotalTokenWeight += assetHlpTokenConfigs[hlpAssetIds[i]].targetWeight;

405:             hlpTotalTokenWeight += assetHlpTokenConfigs[hlpAssetIds[i]].targetWeight;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

213:             _balances[epochTimestamp][to] += amount;

237:         _totalSupply += amount;

238:         totalSupplyByEpoch[thisEpochTimestamp] += amount;

242:             _balances[getCurrentEpochTimestamp()][account] += amount;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="GAS-2"></a>[GAS-2] Use assembly to check for `address(0)`
*Saves 6 gas per instance*

*Instances (14)*:
```solidity
File: src/handlers/IntentHandler.sol

256:         if (_executor == address(0)) revert IntentHandler_InvalidAddress();

267:         if (_pyth == address(0)) revert IntentHandler_InvalidAddress();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/storages/ConfigStorage.sol

281:         if (_hlp == address(0)) revert IConfigStorage_InvalidAddress();

330:             _contractAddress == address(0) ||

331:             _executorAddress == address(0) ||

448:             _curCollateralTokenConfig.settleStrategy == address(0) &&

486:         if (_token != address(0)) {

642:             if (_newHooks[i] == address(0)) revert IConfigStorage_InvalidAddress();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

202:         if (from == address(0)) revert TLC_TransferFromZeroAddress();

203:         if (to == address(0)) revert TLC_TransferToZeroAddress();

231:         if (account == address(0)) revert TLC_MintToZeroAddress();

261:         if (account == address(0)) revert TLC_BurnFromZeroAddress();

293:         if (user == address(0)) revert TLC_ApproveFromZeroAddress();

294:         if (spender == address(0)) revert TLC_ApproveToZeroAddress();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="GAS-3"></a>[GAS-3] Comparing to a Boolean constant
Comparing to a constant (`true` or `false`) is a bit more expensive than directly checking the returned boolean value.

Consider using `if(directValue)` instead of `if(directValue == true)` and `if(!directValue)` instead of `if(directValue == false)`

*Instances (1)*:
```solidity
File: src/storages/ConfigStorage.sol

450:             _curCollateralTokenConfig.accepted == false

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="GAS-4"></a>[GAS-4] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (10)*:
```solidity
File: src/contracts/FLP.sol

15:     mapping(address user => bool isMinter) public minters;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/handlers/IntentHandler.sol

35:     mapping(bytes32 key => bool executed) executedIntents;

36:     mapping(address executor => bool isAllow) public intentExecutors; // The allowed addresses to execute intents

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

29:     mapping(address whitelisted => bool isWhitelisted) public whitelistedCallers;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

74:     mapping(address => bool) public allowedLiquidators; // allowed contract to execute liquidation service

75:     mapping(address => mapping(address => bool)) public serviceExecutors; // service => handler => isOK, to allowed executor for service layer

101:     mapping(address => bool) public configExecutors;

107:     mapping(uint256 marketIndex => bool isEnabled) public isAdaptiveFeeEnabledByMarketIndex;

110:     mapping(uint256 marketIndex => bool isStepMinProfitEnabled) public isStepMinProfitEnabledByMarketIndex;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

24:     mapping(address => bool) public minter;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="GAS-5"></a>[GAS-5] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (9)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

80:         for (uint256 i = 0; i < _route.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/staking/FTCHook.sol

92:         for (uint256 i = 0; i < _callers.length; ) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

299:         for (uint256 i = 0; i < hlpAssetIds.length; ) {

349:         for (uint256 i = 0; i < _contractAddresses.length; ) {

404:         for (uint256 i = 0; i < hlpAssetIds.length; ) {

429:         for (uint256 i = 0; i < _assetIds.length; ) {

467:         for (uint256 i = 0; i < _assetIds.length; ) {

641:         for (uint256 i = 0; i < _newHooks.length; ) {

661:         for (uint256 i; i < _marketIndexs.length; ) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="GAS-6"></a>[GAS-6] State variables should be cached in stack variables rather than re-reading them from storage
The instances below point to the second+ access of a state variable within a function. Caching of a state variable replaces each Gwarmaccess (100 gas) with a much cheaper stack read. Other less obvious fixes/optimizations include having local memory caches of state variable structs, or having local caches of state variable contracts/addresses.

*Saves 100 gas per instance*

*Instances (1)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

52:             _tIn.safeApprove(address(router), type(uint256).max);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

### <a name="GAS-7"></a>[GAS-7] Use calldata instead of memory for function arguments that do not get mutated
When a function with a `memory` array is called externally, the `abi.decode()` step has to use a for-loop to copy each index of the `calldata` to the `memory` index. Each iteration of this for-loop costs at least 60 gas (i.e. `60 * <mem_array>.length`). Using `calldata` directly bypasses this loop. 

If the array is passed to an `internal` function which passes the array to another internal function where the array is modified and therefore `memory` is used in the `external` call, it's still more gas-efficient to use `calldata` when the `external` function uses modifiers, since the modifiers may prevent the internal functions from being called. Structs have the same overhead as an array of length one. 

 *Saves 60 gas per instance*

*Instances (7)*:
```solidity
File: src/handlers/IntentHandler.sol

65:     function execute(ExecuteIntentInputs memory inputs) external onlyIntentExecutors {

229:     function getDigest(IIntentHandler.TradeOrder memory _tradeOrder) public view returns (bytes32 _digest) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/storages/ConfigStorage.sol

674:     function addStepMinProfitDuration(StepMinProfitDuration[] memory _stepMinProfitDurations) external onlyOwner {

688:         uint256[] memory indexes,

689:         StepMinProfitDuration[] memory _stepMinProfitDurations

734:         uint256[] memory marketIndexes,

735:         bool[] memory isEnableds

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="GAS-8"></a>[GAS-8] For Operations that will not overflow, you could use unchecked

*Instances (95)*:
```solidity
File: src/contracts/FLP.sol

7: import {ReentrancyGuardUpgradeable} from "@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ERC20Upgradeable} from "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";

12: import {IHLP} from "./interfaces/IHLP.sol";

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

8: import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

9: import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

10: import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

13: import {IRouter} from "@hmx/interfaces/aerodrome/IRouter.sol";

14: import {IDexter} from "@hmx/extensions/dexters/interfaces/IDexter.sol";

57:         _amountOut = ERC20(_tokenOut).balanceOf(address(this)) - _balanceBefore;

80:         for (uint256 i = 0; i < _route.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ReentrancyGuardUpgradeable} from "@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

10: import {EIP712Upgradeable} from "@openzeppelin-upgradeable/contracts/utils/cryptography/EIP712Upgradeable.sol";

11: import {HMXLib} from "@hmx/libraries/HMXLib.sol";

12: import {ECDSAUpgradeable} from "@openzeppelin-upgradeable/contracts/utils/cryptography/ECDSAUpgradeable.sol";

15: import {VaultStorage} from "@hmx/storages/VaultStorage.sol";

16: import {ConfigStorage} from "@hmx/storages/ConfigStorage.sol";

17: import {OracleMiddleware} from "@hmx/oracles/OracleMiddleware.sol";

18: import {WordCodec} from "@hmx/libraries/WordCodec.sol";

19: import {TradeOrderHelper} from "@hmx/helpers/TradeOrderHelper.sol";

20: import {GasService} from "@hmx/services/GasService.sol";

23: import {IEcoPyth} from "@hmx/oracles/interfaces/IEcoPyth.sol";

24: import {IIntentHandler} from "@hmx/handlers/interfaces/IIntentHandler.sol";

25: import {ITradeOrderHelper} from "@hmx/helpers/interfaces/ITradeOrderHelper.sol";

36:     mapping(address executor => bool isAllow) public intentExecutors; // The allowed addresses to execute intents

84:                 _vars.order.sizeDelta = inputs.cmds[_i].decodeInt(11, 54) * 1e22;

85:                 _vars.order.triggerPrice = inputs.cmds[_i].decodeUint(65, 54) * 1e22;

86:                 _vars.order.acceptablePrice = inputs.cmds[_i].decodeUint(119, 54) * 1e22;

100:                         ++_i;

108:                         ++_i;

122:                         ++_i;

133:                         ++_i;

167:                 ++_i;

193:         } catch Panic(uint /*errorCode*/) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

7: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

8: import {ITradeServiceHook} from "../services/interfaces/ITradeServiceHook.sol";

9: import {ITradeService} from "../services/interfaces/ITradeService.sol";

10: import {ITradingStaking} from "./interfaces/ITradingStaking.sol";

11: import {TraderLoyaltyCredit} from "@hmx/tokens/TraderLoyaltyCredit.sol";

12: import {TLCStaking} from "@hmx/staking/TLCStaking.sol";

13: import {FullMath} from "@hmx/libraries/FullMath.sol";

78:         uint256 _mintAmount = _sizeDelta.mulDiv(weight, 1e16); // 1e16 = (1e30 / 1e18) * BPS, optimized math

98:                 ++i;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ERC20Upgradeable} from "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";

10: import {AddressUpgradeable} from "@openzeppelin-upgradeable/contracts/utils/AddressUpgradeable.sol";

13: import {IConfigStorage} from "@hmx/storages/interfaces/IConfigStorage.sol";

14: import {ICalculator} from "@hmx/contracts/interfaces/ICalculator.sol";

15: import {IOracleMiddleware} from "@hmx/oracles/interfaces/IOracleMiddleware.sol";

16: import {ISwitchCollateralRouter} from "@hmx/extensions/switch-collateral/interfaces/ISwitchCollateralRouter.sol";

64:     uint256 public constant MAX_FEE_BPS = 0.3 * 1e4; // 30%

74:     mapping(address => bool) public allowedLiquidators; // allowed contract to execute liquidation service

75:     mapping(address => mapping(address => bool)) public serviceExecutors; // service => handler => isOK, to allowed executor for service layer

81:     uint32 public pnlFactorBPS; // factor that calculate unrealized PnL after collateral factor

201:                 ++_i;

223:                 ++_i;

300:             hlpTotalTokenWeight += assetHlpTokenConfigs[hlpAssetIds[i]].targetWeight;

303:                 ++i;

352:                 ++i;

386:         if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();

405:             hlpTotalTokenWeight += assetHlpTokenConfigs[hlpAssetIds[i]].targetWeight;

408:                 ++i;

433:                 ++i;

471:                 ++i;

544:                     ++_j;

553:                     (liquidityConfig.hlpTotalTokenWeight - assetHlpTokenConfigs[_assetId].targetWeight) +

568:                 ++_i;

592:         if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();

609:         emit LogDeleteMarket(marketConfigs.length - 1);

619:         liquidityConfig.hlpTotalTokenWeight -= assetHlpTokenConfigs[_assetId].targetWeight;

625:                 hlpAssetIds[_i] = hlpAssetIds[_len - 1];

631:                 ++_i;

645:                 ++i;

669:                 ++i;

680:             emit LogSetStepMinProfitDuration(stepMinProfitDurations.length - 1, _stepMinProfitDurations[i]);

682:                 ++i;

699:                 ++i;

706:             stepMinProfitDurations.length - 1,

723:                 ++i;

743:                 ++i;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

7: import {ITraderLoyaltyCredit} from "@hmx/tokens/interfaces/ITraderLoyaltyCredit.sol";

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

158:         _approve(user, spender, allowance(user, spender) + addedValue);

181:             _approve(user, spender, currentAllowance - subtractedValue);

210:             _balances[epochTimestamp][from] = fromBalance - amount;

213:             _balances[epochTimestamp][to] += amount;

237:         _totalSupply += amount;

238:         totalSupplyByEpoch[thisEpochTimestamp] += amount;

242:             _balances[getCurrentEpochTimestamp()][account] += amount;

268:             _balances[epochTimestamp][account] = accountBalance - amount;

270:             _totalSupply -= amount;

271:             totalSupplyByEpoch[epochTimestamp] -= amount;

313:                 _approve(user, spender, currentAllowance - amount);

351:         return (block.timestamp / epochLength) * epochLength;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="GAS-9"></a>[GAS-9] Avoid contract existence checks by using low level calls
Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (3)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

55:         uint256 _balanceBefore = ERC20(_tokenOut).balanceOf(address(this));

57:         _amountOut = ERC20(_tokenOut).balanceOf(address(this)) - _balanceBefore;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

221:         address _recoveredSigner = ECDSAUpgradeable.recover(getDigest(_tradeOrder), _signature);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

### <a name="GAS-10"></a>[GAS-10] Stack variable used as a cheaper cache for a state variable is only used once
If the variable is only accessed once, it's cheaper to use the state variable directly that one time, and save the **3 gas** the extra stack assignment would spend

*Instances (1)*:
```solidity
File: src/storages/ConfigStorage.sol

214:         mapping(bytes32 => AssetConfig) storage _assetConfigs = assetConfigs;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="GAS-11"></a>[GAS-11] State variables only set in the constructor should be declared `immutable`
Variables only set in the constructor and never edited afterwards should be marked as immutable, as it would avoid the expensive storage-writing operation in the constructor (around **20 000 gas** per variable) and replace the expensive storage-reading operations (around **2100 gas** per reading) to a less expensive value reading (**3 gas**)

*Instances (1)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

32:         router = IRouter(_router);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

### <a name="GAS-12"></a>[GAS-12] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (36)*:
```solidity
File: src/contracts/FLP.sol

36:     function setMinter(address minter, bool isMinter) external onlyOwner {

41:     function mint(address to, uint256 amount) external onlyMinter {

45:     function burn(address from, uint256 amount) external onlyMinter {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

72:     function setRouteOf(address _tokenIn, address _tokenOut, IRouter.Route[] calldata _route) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

65:     function execute(ExecuteIntentInputs memory inputs) external onlyIntentExecutors {

255:     function setIntentExecutor(address _executor, bool _isAllow) external nonReentrant onlyOwner {

261:     function setTradeOrderHelper(address _newTradeOrderHelper) external nonReentrant onlyOwner {

266:     function setPyth(address _pyth) external nonReentrant onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

85:     function setMarketWeight(uint256 _marketIndex, uint256 _weight) external onlyOwner {

90:     function setWhitelistedCallers(address[] calldata _callers, bool[] calldata _isWhitelisteds) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

253:     function setConfigExecutor(address _executorAddress, bool _isServiceExecutor) external onlyOwner {

259:     function setMinimumPositionSize(uint256 _minimumPositionSize) external onlyOwner {

264:     function setCalculator(address _calculator) external onlyOwner {

272:     function setOracle(address _oracle) external onlyOwner {

280:     function setHLP(address _hlp) external onlyOwner {

287:     function setLiquidityConfig(LiquidityConfig calldata _liquidityConfig) external onlyOwner {

310:     function setLiquidityEnabled(bool _enabled) external onlyWhitelistedExecutor {

315:     function setDynamicEnabled(bool _enabled) external onlyOwner {

357:     function setPnlFactor(uint32 _pnlFactorBPS) external onlyOwner {

362:     function setSwapConfig(SwapConfig calldata _newConfig) external onlyOwner {

367:     function setTradingConfig(TradingConfig calldata _newConfig) external onlyOwner {

374:     function setLiquidationConfig(LiquidationConfig calldata _newConfig) external onlyOwner {

465:     function setAssetConfigs(bytes32[] calldata _assetIds, AssetConfig[] calldata _newConfigs) external onlyOwner {

496:     function setWeth(address _weth) external onlyOwner {

503:     function setSGlp(address _sglp) external onlyOwner {

512:     function setSwitchCollateralRouter(address _newSwitchCollateralRouter) external onlyOwner {

573:     function addAssetClassConfig(AssetClassConfig calldata _newConfig) external onlyOwner returns (uint256 _index) {

580:     function setAssetClassConfigByIndex(uint256 _index, AssetClassConfig calldata _newConfig) external onlyOwner {

603:     function delistMarket(uint256 _marketIndex) external onlyOwner {

608:     function deleteLastMarket() external onlyOwner {

615:     function removeAcceptedToken(address _token) external onlyOwner {

640:     function setTradeServiceHooks(address[] calldata _newHooks) external onlyOwner {

674:     function addStepMinProfitDuration(StepMinProfitDuration[] memory _stepMinProfitDurations) external onlyOwner {

704:     function removeLastStepMinProfitDuration() external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

230:     function mint(address account, uint256 amount) external onlyMinter {

354:     function setMinter(address _minter, bool _mintable) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="GAS-13"></a>[GAS-13] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)
Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (1)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

80:         for (uint256 i = 0; i < _route.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

### <a name="GAS-14"></a>[GAS-14] Using `private` rather than `public` for constants, saves gas
If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (3)*:
```solidity
File: src/storages/ConfigStorage.sol

63:     uint256 public constant BPS = 1e4;

64:     uint256 public constant MAX_FEE_BPS = 0.3 * 1e4; // 30%

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

22:     uint256 public constant epochLength = 1 weeks;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="GAS-15"></a>[GAS-15] `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas
https://soliditydeveloper.com/bitmaps

https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol

- [BitMaps.sol#L5-L16](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol#L5-L16):

```solidity
/**
 * @dev Library for managing uint256 to bool mapping in a compact and efficient way, provided the keys are sequential.
 * Largely inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
 *
 * BitMaps pack 256 booleans across each bit of a single 256-bit slot of `uint256` type.
 * Hence booleans corresponding to 256 _sequential_ indices would only consume a single slot,
 * unlike the regular `bool` which would consume an entire slot for a single value.
 *
 * This results in gas savings in two ways:
 *
 * - Setting a zero value to non-zero only once every 256 times
 * - Accessing the same warm slot for every 256 _sequential_ indices
 */
```

*Instances (2)*:
```solidity
File: src/storages/ConfigStorage.sol

107:     mapping(uint256 marketIndex => bool isEnabled) public isAdaptiveFeeEnabledByMarketIndex;

110:     mapping(uint256 marketIndex => bool isStepMinProfitEnabled) public isStepMinProfitEnabledByMarketIndex;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="GAS-16"></a>[GAS-16] Increments/decrements can be unchecked in for-loops
In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (1)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

80:         for (uint256 i = 0; i < _route.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

### <a name="GAS-17"></a>[GAS-17] WETH address definition can be use directly
WETH is a wrap Ether contract with a specific address in the Ethereum network, giving the option to define it may cause false recognition, it is healthier to define it directly.

    Advantages of defining a specific contract directly:
    
    It saves gas,
    Prevents incorrect argument definition,
    Prevents execution on a different chain and re-signature issues,
    WETH Address : 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2

*Instances (1)*:
```solidity
File: src/storages/ConfigStorage.sol

83:     address public weth;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Missing checks for `address(0)` when assigning values to address state variables | 8 |
| [NC-2](#NC-2) | Constants should be in CONSTANT_CASE | 3 |
| [NC-3](#NC-3) | `constant`s should be defined rather than using magic numbers | 12 |
| [NC-4](#NC-4) | Control structures do not follow the Solidity Style Guide | 49 |
| [NC-5](#NC-5) | Consider disabling `renounceOwnership()` | 6 |
| [NC-6](#NC-6) | Event missing indexed field | 19 |
| [NC-7](#NC-7) | Events that mark critical parameter changes should contain both the old and the new value | 29 |
| [NC-8](#NC-8) | Function ordering does not follow the Solidity style guide | 4 |
| [NC-9](#NC-9) | Functions should not be longer than 50 lines | 83 |
| [NC-10](#NC-10) | Change uint to uint256 | 1 |
| [NC-11](#NC-11) | Lack of checks in setters | 21 |
| [NC-12](#NC-12) | Lines are too long | 1 |
| [NC-13](#NC-13) | Missing Event for critical parameters change | 8 |
| [NC-14](#NC-14) | NatSpec is completely non-existent on functions that should have them | 49 |
| [NC-15](#NC-15) | Incomplete NatSpec: `@param` is missing on actually documented functions | 7 |
| [NC-16](#NC-16) | Incomplete NatSpec: `@return` is missing on actually documented functions | 6 |
| [NC-17](#NC-17) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 5 |
| [NC-18](#NC-18) | Constant state variables defined more than once | 2 |
| [NC-19](#NC-19) | Consider using named mappings | 13 |
| [NC-20](#NC-20) | Adding a `return` statement when the function defines a named return variable, is redundant | 14 |
| [NC-21](#NC-21) | `require()` / `revert()` statements should have descriptive reason strings | 1 |
| [NC-22](#NC-22) | Take advantage of Custom Error's return value property | 50 |
| [NC-23](#NC-23) | Avoid the use of sensitive terms | 14 |
| [NC-24](#NC-24) | Contract does not follow the Solidity style guide's suggested layout ordering | 4 |
| [NC-25](#NC-25) | Internal and private variables and functions names should begin with an underscore | 1 |
| [NC-26](#NC-26) | Event is missing `indexed` fields | 34 |
| [NC-27](#NC-27) | Constants should be defined rather than using magic numbers | 9 |
| [NC-28](#NC-28) | `public` functions not called by the contract should be declared `external` instead | 5 |
| [NC-29](#NC-29) | Variables need not be initialized to zero | 12 |
### <a name="NC-1"></a>[NC-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (8)*:
```solidity
File: src/staking/FTCHook.sol

42:         tradeService = _tradeService;

43:         tlc = _tlc;

44:         tlcStaking = _tlcStaking;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

266:         calculator = _calculator;

274:         oracle = _oracle;

500:         weth = _weth;

507:         sglp = _sglp;

514:         switchCollateralRouter = _newSwitchCollateralRouter;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="NC-2"></a>[NC-2] Constants should be in CONSTANT_CASE
For `constant` variable names, each word should use all capital letters, with underscores separating each word (CONSTANT_CASE)

*Instances (3)*:
```solidity
File: src/tokens/FlexTradeCredits.sol

20:     string private constant _name = "Flex Trade Credits";

21:     string private constant _symbol = "FTC";

22:     uint256 public constant epochLength = 1 weeks;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-3"></a>[NC-3] `constant`s should be defined rather than using magic numbers
Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (12)*:
```solidity
File: src/handlers/IntentHandler.sol

78:             _localVars.mainAccount = address(uint160(inputs.accountAndSubAccountIds[_i].decodeUint(0, 160)));

79:             _localVars.subAccountId = uint8(inputs.accountAndSubAccountIds[_i].decodeUint(160, 8));

80:             _localVars.cmd = Command(inputs.cmds[_i].decodeUint(0, 3));

83:                 _vars.order.marketIndex = inputs.cmds[_i].decodeUint(3, 8);

84:                 _vars.order.sizeDelta = inputs.cmds[_i].decodeInt(11, 54) * 1e22;

85:                 _vars.order.triggerPrice = inputs.cmds[_i].decodeUint(65, 54) * 1e22;

86:                 _vars.order.acceptablePrice = inputs.cmds[_i].decodeUint(119, 54) * 1e22;

89:                 _vars.order.tpToken = _localVars.tpTokens[uint256(inputs.cmds[_i].decodeUint(175, 7))];

90:                 _vars.order.createdTimestamp = inputs.cmds[_i].decodeUint(182, 32);

91:                 _vars.order.expiryTimestamp = inputs.cmds[_i].decodeUint(214, 32);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/storages/ConfigStorage.sol

659:         uint256 MAX_DURATION = 30 minutes;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

64:         return 18;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-4"></a>[NC-4] Control structures do not follow the Solidity Style Guide
See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (49)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

51:         if (_tIn.allowance(address(this), address(router)) < _amountIn)

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

40:         if (!intentExecutors[msg.sender]) revert IntentHandler_Unauthorized();

66:         if (inputs.accountAndSubAccountIds.length != inputs.cmds.length) revert IntentHandler_BadLength();

256:         if (_executor == address(0)) revert IntentHandler_InvalidAddress();

267:         if (_pyth == address(0)) revert IntentHandler_InvalidAddress();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

32:         if (!whitelistedCallers[msg.sender]) revert TLCHook_Forbidden();

91:         if (_callers.length != _isWhitelisteds.length) revert TLCHook_BadArgs();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

117:         if (!configExecutors[msg.sender]) revert IConfigStorage_NotWhiteListed();

132:         if (!serviceExecutors[_contractAddress][_executorAddress]) revert IConfigStorage_NotWhiteListed();

136:         if (!assetHlpTokenConfigs[tokenAssetIds[_token]].accepted) revert IConfigStorage_NotAcceptedLiquidity();

142:         if (!assetCollateralTokenConfigs[tokenAssetIds[_token]].accepted) revert IConfigStorage_NotAcceptedCollateral();

254:         if (!_executorAddress.isContract()) revert IConfigStorage_InvalidAddress();

281:         if (_hlp == address(0)) revert IConfigStorage_InvalidAddress();

288:         if (

294:         if (_liquidityConfig.maxHLPUtilizationBPS > BPS) revert IConfigStorage_ExceedLimitSetting();

329:         if (

344:         if (

368:         if (_newConfig.fundingInterval == 0 || _newConfig.devFeeRateBPS > MAX_FEE_BPS)

384:         if (_newConfig.increasePositionFeeRateBPS > MAX_FEE_BPS || _newConfig.decreasePositionFeeRateBPS > MAX_FEE_BPS)

386:         if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();

387:         if (_newConfig.initialMarginFractionBPS < _newConfig.maintenanceMarginFractionBPS)

428:         if (_assetIds.length != _newConfigs.length) revert IConfigStorage_BadLen();

442:         if (_newConfig.collateralFactorBPS == 0) revert IConfigStorage_ExceedLimitSetting();

447:         if (

466:         if (_assetIds.length != _newConfigs.length) revert IConfigStorage_BadLen();

480:         if (!_newConfig.tokenAddress.isContract()) revert IConfigStorage_BadArgs();

497:         if (!_weth.isContract()) revert IConfigStorage_BadArgs();

504:         if (!_sglp.isContract()) revert IConfigStorage_BadArgs();

590:         if (_newConfig.increasePositionFeeRateBPS > MAX_FEE_BPS || _newConfig.decreasePositionFeeRateBPS > MAX_FEE_BPS)

592:         if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();

593:         if (_newConfig.initialMarginFractionBPS < _newConfig.maintenanceMarginFractionBPS)

642:             if (_newHooks[i] == address(0)) revert IConfigStorage_InvalidAddress();

657:         if (_marketIndexs.length != _minProfitDurations.length) revert IConfigStorage_BadArgs();

662:             if (_minProfitDurations[i] > MAX_DURATION) revert IConfigStorage_MaxDurationForMinProfit();

677:             if (_stepMinProfitDurations[i].fromSize >= _stepMinProfitDurations[i].toSize)

691:         if (indexes.length != _stepMinProfitDurations.length) revert IConfigStorage_BadLen();

694:             if (_stepMinProfitDurations[i].fromSize >= _stepMinProfitDurations[i].toSize)

737:         if (marketIndexes.length != isEnableds.length) revert IConfigStorage_BadLen();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

27:         if (!minter[msg.sender]) revert TLC_NotMinter();

179:         if (currentAllowance < subtractedValue) revert TLC_AllowanceBelowZero();

202:         if (from == address(0)) revert TLC_TransferFromZeroAddress();

203:         if (to == address(0)) revert TLC_TransferToZeroAddress();

208:         if (fromBalance < amount) revert TLC_TransferAmountExceedsBalance();

231:         if (account == address(0)) revert TLC_MintToZeroAddress();

261:         if (account == address(0)) revert TLC_BurnFromZeroAddress();

266:         if (accountBalance < amount) revert TLC_BurnAmountExceedsBalance();

293:         if (user == address(0)) revert TLC_ApproveFromZeroAddress();

294:         if (spender == address(0)) revert TLC_ApproveToZeroAddress();

311:             if (currentAllowance < amount) revert TLC_InsufficientAllowance();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-5"></a>[NC-5] Consider disabling `renounceOwnership()`
If the plan for your project does not include eventually giving up all ownership control, consider overwriting OpenZeppelin's `Ownable`'s `renounceOwnership()` function in order to disable it.

*Instances (6)*:
```solidity
File: src/contracts/FLP.sol

14: contract FLP is ReentrancyGuardUpgradeable, OwnableUpgradeable, ERC20Upgradeable {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

16: contract AerodromeDexter is Ownable, IDexter {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

28: contract IntentHandler is OwnableUpgradeable, ReentrancyGuardUpgradeable, EIP712Upgradeable, IIntentHandler {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

15: contract FTCHook is ITradeServiceHook, OwnableUpgradeable {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

20: contract ConfigStorage is IConfigStorage, OwnableUpgradeable {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

10: contract FlexTradeCredits is OwnableUpgradeable, ITraderLoyaltyCredit {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-6"></a>[NC-6] Event missing indexed field
Index event fields make the field more quickly accessible [to off-chain tools](https://ethereum.stackexchange.com/questions/40396/can-somebody-please-explain-the-concept-of-event-indexing) that parse events. This is especially useful when it comes to filtering based on an address. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Where applicable, each `event` should use three `indexed` fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three applicable fields, all of the applicable fields should be indexed.

*Instances (19)*:
```solidity
File: src/staking/FTCHook.sol

36:     event LogSetMarketWeight(uint256 marketIndex, uint256 oldWeight, uint256 newWeight);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

31:     event LogSetDynamicEnabled(bool enabled);

32:     event LogSetPnlFactor(uint32 oldPnlFactorBPS, uint32 newPnlFactorBPS);

36:     event LogSetMarketConfig(uint256 marketIndex, MarketConfig oldConfig, MarketConfig newConfig);

37:     event LogSetHlpTokenConfig(address token, HLPTokenConfig oldConfig, HLPTokenConfig newConfig);

38:     event LogSetCollateralTokenConfig(

43:     event LogSetAssetConfig(bytes32 assetId, AssetConfig oldConfig, AssetConfig newConfig);

45:     event LogSetAssetClassConfigByIndex(uint256 index, AssetClassConfig oldConfig, AssetClassConfig newConfig);

46:     event LogSetLiquidityEnabled(bool oldValue, bool newValue);

47:     event LogSetMinimumPositionSize(uint256 oldValue, uint256 newValue);

49:     event LogAddAssetClassConfig(uint256 index, AssetClassConfig newConfig);

50:     event LogAddMarketConfig(uint256 index, MarketConfig newConfig);

51:     event LogRemoveUnderlying(address token);

52:     event LogDelistMarket(uint256 marketIndex);

53:     event LogDeleteMarket(uint256 marketIndex);

54:     event LogAddOrUpdateHLPTokenConfigs(address _token, HLPTokenConfig _config, HLPTokenConfig _newConfig);

55:     event LogSetTradeServiceHooks(address[] oldHooks, address[] newHooks);

56:     event LogSetSwitchCollateralRouter(address prevRouter, address newRouter);

58:     event LogSetStepMinProfitDuration(uint256 index, StepMinProfitDuration _stepMinProfitDuration);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="NC-7"></a>[NC-7] Events that mark critical parameter changes should contain both the old and the new value
This should especially be done if the new value is not required to be different from the old value

*Instances (29)*:
```solidity
File: src/contracts/FLP.sol

36:     function setMinter(address minter, bool isMinter) external onlyOwner {
            minters[minter] = isMinter;
            emit SetMinter(minter, isMinter);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

72:     function setRouteOf(address _tokenIn, address _tokenOut, IRouter.Route[] calldata _route) external onlyOwner {
            // Emit the event with the current old route
            emit LogSetRouteOf(_tokenIn, _tokenOut, routeOf[_tokenIn][_tokenOut], _route);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

60:     function setDelegate(address _delegate) external {
            delegations[msg.sender] = _delegate;
            emit LogSetDelegate(msg.sender, _delegate);

255:     function setIntentExecutor(address _executor, bool _isAllow) external nonReentrant onlyOwner {
             if (_executor == address(0)) revert IntentHandler_InvalidAddress();
             intentExecutors[_executor] = _isAllow;
             emit LogSetIntentExecutor(_executor, _isAllow);

261:     function setTradeOrderHelper(address _newTradeOrderHelper) external nonReentrant onlyOwner {
             emit LogSetTradeOrderHelper(address(tradeOrderHelper), _newTradeOrderHelper);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

85:     function setMarketWeight(uint256 _marketIndex, uint256 _weight) external onlyOwner {
            emit LogSetMarketWeight(_marketIndex, marketWeights[_marketIndex], _weight);

90:     function setWhitelistedCallers(address[] calldata _callers, bool[] calldata _isWhitelisteds) external onlyOwner {
            if (_callers.length != _isWhitelisteds.length) revert TLCHook_BadArgs();
            for (uint256 i = 0; i < _callers.length; ) {
                whitelistedCallers[_callers[i]] = _isWhitelisteds[i];
    
                emit LogSetWhitelistedCaller(_callers[i], _isWhitelisteds[i]);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

253:     function setConfigExecutor(address _executorAddress, bool _isServiceExecutor) external onlyOwner {
             if (!_executorAddress.isContract()) revert IConfigStorage_InvalidAddress();
             configExecutors[_executorAddress] = _isServiceExecutor;
             emit LogSetConfigExecutor(_executorAddress, _isServiceExecutor);

259:     function setMinimumPositionSize(uint256 _minimumPositionSize) external onlyOwner {
             emit LogSetMinimumPositionSize(minimumPositionSize, _minimumPositionSize);

264:     function setCalculator(address _calculator) external onlyOwner {
             emit LogSetCalculator(calculator, _calculator);

272:     function setOracle(address _oracle) external onlyOwner {
             emit LogSetOracle(oracle, _oracle);

280:     function setHLP(address _hlp) external onlyOwner {
             if (_hlp == address(0)) revert IConfigStorage_InvalidAddress();
             emit LogSetHLP(hlp, _hlp);

287:     function setLiquidityConfig(LiquidityConfig calldata _liquidityConfig) external onlyOwner {
             if (
                 _liquidityConfig.taxFeeRateBPS > MAX_FEE_BPS ||
                 _liquidityConfig.flashLoanFeeRateBPS > MAX_FEE_BPS ||
                 _liquidityConfig.depositFeeRateBPS > MAX_FEE_BPS ||
                 _liquidityConfig.withdrawFeeRateBPS > MAX_FEE_BPS
             ) revert IConfigStorage_MaxFeeBps();
             if (_liquidityConfig.maxHLPUtilizationBPS > BPS) revert IConfigStorage_ExceedLimitSetting();
             emit LogSetLiquidityConfig(liquidityConfig, _liquidityConfig);

310:     function setLiquidityEnabled(bool _enabled) external onlyWhitelistedExecutor {
             emit LogSetLiquidityEnabled(liquidityConfig.enabled, _enabled);

315:     function setDynamicEnabled(bool _enabled) external onlyOwner {
             liquidityConfig.dynamicFeeEnabled = _enabled;
             emit LogSetDynamicEnabled(_enabled);

357:     function setPnlFactor(uint32 _pnlFactorBPS) external onlyOwner {
             emit LogSetPnlFactor(pnlFactorBPS, _pnlFactorBPS);

362:     function setSwapConfig(SwapConfig calldata _newConfig) external onlyOwner {
             emit LogSetSwapConfig(swapConfig, _newConfig);

367:     function setTradingConfig(TradingConfig calldata _newConfig) external onlyOwner {
             if (_newConfig.fundingInterval == 0 || _newConfig.devFeeRateBPS > MAX_FEE_BPS)
                 revert IConfigStorage_ExceedLimitSetting();
             emit LogSetTradingConfig(tradingConfig, _newConfig);

374:     function setLiquidationConfig(LiquidationConfig calldata _newConfig) external onlyOwner {
             emit LogSetLiquidationConfig(liquidationConfig, _newConfig);

379:     function setMarketConfig(
             uint256 _marketIndex,
             MarketConfig calldata _newConfig,
             bool _isAdaptiveFeeEnabled
         ) external onlyOwner returns (MarketConfig memory _marketConfig) {
             if (_newConfig.increasePositionFeeRateBPS > MAX_FEE_BPS || _newConfig.decreasePositionFeeRateBPS > MAX_FEE_BPS)
                 revert IConfigStorage_MaxFeeBps();
             if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();
             if (_newConfig.initialMarginFractionBPS < _newConfig.maintenanceMarginFractionBPS)
                 revert IConfigStorage_InvalidValue();
     
             emit LogSetMarketConfig(_marketIndex, marketConfigs[_marketIndex], _newConfig);

396:     function setHlpTokenConfig(
             address _token,
             HLPTokenConfig calldata _newConfig
         ) external onlyOwner returns (HLPTokenConfig memory _hlpTokenConfig) {
             emit LogSetHlpTokenConfig(_token, assetHlpTokenConfigs[tokenAssetIds[_token]], _newConfig);

496:     function setWeth(address _weth) external onlyOwner {
             if (!_weth.isContract()) revert IConfigStorage_BadArgs();
     
             emit LogSetToken(weth, _weth);

503:     function setSGlp(address _sglp) external onlyOwner {
             if (!_sglp.isContract()) revert IConfigStorage_BadArgs();
     
             emit LogSetToken(sglp, _sglp);

512:     function setSwitchCollateralRouter(address _newSwitchCollateralRouter) external onlyOwner {
             emit LogSetSwitchCollateralRouter(switchCollateralRouter, _newSwitchCollateralRouter);

580:     function setAssetClassConfigByIndex(uint256 _index, AssetClassConfig calldata _newConfig) external onlyOwner {
             emit LogSetAssetClassConfigByIndex(_index, assetClassConfigs[_index], _newConfig);

640:     function setTradeServiceHooks(address[] calldata _newHooks) external onlyOwner {
             for (uint256 i = 0; i < _newHooks.length; ) {
                 if (_newHooks[i] == address(0)) revert IConfigStorage_InvalidAddress();
     
                 unchecked {
                     ++i;
                 }
             }
             emit LogSetTradeServiceHooks(tradeServiceHooks, _newHooks);

653:     function setMinProfitDurations(
             uint256[] calldata _marketIndexs,
             uint256[] calldata _minProfitDurations
         ) external onlyOwner {
             if (_marketIndexs.length != _minProfitDurations.length) revert IConfigStorage_BadArgs();
     
             uint256 MAX_DURATION = 30 minutes;
     
             for (uint256 i; i < _marketIndexs.length; ) {
                 if (_minProfitDurations[i] > MAX_DURATION) revert IConfigStorage_MaxDurationForMinProfit();
     
                 minProfitDurations[_marketIndexs[i]] = _minProfitDurations[i];
     
                 emit LogMinProfitDuration(_marketIndexs[i], _minProfitDurations[i]);

687:     function setStepMinProfitDuration(
             uint256[] memory indexes,
             StepMinProfitDuration[] memory _stepMinProfitDurations
         ) external onlyOwner {
             if (indexes.length != _stepMinProfitDurations.length) revert IConfigStorage_BadLen();
             uint256 length = _stepMinProfitDurations.length;
             for (uint256 i; i < length; ) {
                 if (_stepMinProfitDurations[i].fromSize >= _stepMinProfitDurations[i].toSize)
                     revert IConfigStorage_BadArgs();
                 stepMinProfitDurations[indexes[i]] = _stepMinProfitDurations[i];
                 emit LogSetStepMinProfitDuration(indexes[i], _stepMinProfitDurations[i]);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

354:     function setMinter(address _minter, bool _mintable) external onlyOwner {
             minter[_minter] = _mintable;
     
             emit SetMinter(_minter, _mintable);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-8"></a>[NC-8] Function ordering does not follow the Solidity style guide
According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (4)*:
```solidity
File: src/handlers/IntentHandler.sol

1: 
   Current order:
   external initialize
   external setDelegate
   external execute
   internal _prevalidateExecuteTradeOrder
   internal _executeTradeOrder
   internal _handleOrderFail
   internal _validateSignature
   public getDigest
   external setIntentExecutor
   external setTradeOrderHelper
   external setPyth
   
   Suggested order:
   external initialize
   external setDelegate
   external execute
   external setIntentExecutor
   external setTradeOrderHelper
   external setPyth
   public getDigest
   internal _prevalidateExecuteTradeOrder
   internal _executeTradeOrder
   internal _handleOrderFail
   internal _validateSignature

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

1: 
   Current order:
   external initialize
   external onIncreasePosition
   external onDecreasePosition
   internal _mintTLC
   external setMarketWeight
   external setWhitelistedCallers
   
   Suggested order:
   external initialize
   external onIncreasePosition
   external onDecreasePosition
   external setMarketWeight
   external setWhitelistedCallers
   internal _mintTLC

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

1: 
   Current order:
   external initialize
   external validateServiceExecutor
   external validateAcceptedLiquidityToken
   external validateAcceptedCollateral
   external getTradingConfig
   external getMarketConfigByIndex
   external getAssetClassConfigByIndex
   external getCollateralTokenConfigs
   external getAssetTokenDecimal
   external getLiquidityConfig
   external getLiquidationConfig
   external getMarketConfigs
   external getMarketConfigsLength
   external getAssetClassConfigsLength
   external getHlpTokens
   external getAssetConfigByToken
   external getCollateralTokens
   external getAssetConfig
   external getAssetHlpTokenConfig
   external getAssetHlpTokenConfigByToken
   external getHlpAssetIds
   external getTradeServiceHooks
   external setConfigExecutor
   external setMinimumPositionSize
   external setCalculator
   external setOracle
   external setHLP
   external setLiquidityConfig
   external setLiquidityEnabled
   external setDynamicEnabled
   external setServiceExecutor
   internal _setServiceExecutor
   external setServiceExecutors
   external setPnlFactor
   external setSwapConfig
   external setTradingConfig
   external setLiquidationConfig
   external setMarketConfig
   external setHlpTokenConfig
   external setCollateralTokenConfig
   external setCollateralTokenConfigs
   internal _setCollateralTokenConfig
   external setAssetConfig
   external setAssetConfigs
   internal _setAssetConfig
   external setWeth
   external setSGlp
   external setSwitchCollateralRouter
   external addOrUpdateAcceptedToken
   external addAssetClassConfig
   external setAssetClassConfigByIndex
   external addMarketConfig
   external delistMarket
   external deleteLastMarket
   external removeAcceptedToken
   external setTradeServiceHooks
   external setMinProfitDurations
   external addStepMinProfitDuration
   external setStepMinProfitDuration
   external removeLastStepMinProfitDuration
   external getStepMinProfitDuration
   external getStepMinProfitDurations
   external setIsStepMinProfitEnabledByMarketIndex
   
   Suggested order:
   external initialize
   external validateServiceExecutor
   external validateAcceptedLiquidityToken
   external validateAcceptedCollateral
   external getTradingConfig
   external getMarketConfigByIndex
   external getAssetClassConfigByIndex
   external getCollateralTokenConfigs
   external getAssetTokenDecimal
   external getLiquidityConfig
   external getLiquidationConfig
   external getMarketConfigs
   external getMarketConfigsLength
   external getAssetClassConfigsLength
   external getHlpTokens
   external getAssetConfigByToken
   external getCollateralTokens
   external getAssetConfig
   external getAssetHlpTokenConfig
   external getAssetHlpTokenConfigByToken
   external getHlpAssetIds
   external getTradeServiceHooks
   external setConfigExecutor
   external setMinimumPositionSize
   external setCalculator
   external setOracle
   external setHLP
   external setLiquidityConfig
   external setLiquidityEnabled
   external setDynamicEnabled
   external setServiceExecutor
   external setServiceExecutors
   external setPnlFactor
   external setSwapConfig
   external setTradingConfig
   external setLiquidationConfig
   external setMarketConfig
   external setHlpTokenConfig
   external setCollateralTokenConfig
   external setCollateralTokenConfigs
   external setAssetConfig
   external setAssetConfigs
   external setWeth
   external setSGlp
   external setSwitchCollateralRouter
   external addOrUpdateAcceptedToken
   external addAssetClassConfig
   external setAssetClassConfigByIndex
   external addMarketConfig
   external delistMarket
   external deleteLastMarket
   external removeAcceptedToken
   external setTradeServiceHooks
   external setMinProfitDurations
   external addStepMinProfitDuration
   external setStepMinProfitDuration
   external removeLastStepMinProfitDuration
   external getStepMinProfitDuration
   external getStepMinProfitDurations
   external setIsStepMinProfitEnabledByMarketIndex
   internal _setServiceExecutor
   internal _setCollateralTokenConfig
   internal _setAssetConfig

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

1: 
   Current order:
   external initialize
   external name
   external symbol
   external decimals
   external totalSupply
   external balanceOf
   external balanceOf
   public transfer
   public allowance
   public approve
   public transferFrom
   public increaseAllowance
   public decreaseAllowance
   internal _transfer
   external mint
   internal _burn
   internal _approve
   internal _spendAllowance
   internal _beforeTokenTransfer
   internal _afterTokenTransfer
   public getCurrentEpochTimestamp
   external setMinter
   external isMinter
   
   Suggested order:
   external initialize
   external name
   external symbol
   external decimals
   external totalSupply
   external balanceOf
   external balanceOf
   external mint
   external setMinter
   external isMinter
   public transfer
   public allowance
   public approve
   public transferFrom
   public increaseAllowance
   public decreaseAllowance
   public getCurrentEpochTimestamp
   internal _transfer
   internal _burn
   internal _approve
   internal _spendAllowance
   internal _beforeTokenTransfer
   internal _afterTokenTransfer

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-9"></a>[NC-9] Functions should not be longer than 50 lines
Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability 

*Instances (83)*:
```solidity
File: src/contracts/FLP.sol

36:     function setMinter(address minter, bool isMinter) external onlyOwner {

41:     function mint(address to, uint256 amount) external onlyMinter {

45:     function burn(address from, uint256 amount) external onlyMinter {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

72:     function setRouteOf(address _tokenIn, address _tokenOut, IRouter.Route[] calldata _route) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

60:     function setDelegate(address _delegate) external {

65:     function execute(ExecuteIntentInputs memory inputs) external onlyIntentExecutors {

172:     function _prevalidateExecuteTradeOrder(ExecuteTradeOrderVars memory vars) internal view returns (bool isSuccess) {

201:     function _handleOrderFail(ExecuteTradeOrderVars memory vars, bytes memory errMsg, bytes32 key) internal {

229:     function getDigest(IIntentHandler.TradeOrder memory _tradeOrder) public view returns (bytes32 _digest) {

255:     function setIntentExecutor(address _executor, bool _isAllow) external nonReentrant onlyOwner {

261:     function setTradeOrderHelper(address _newTradeOrderHelper) external nonReentrant onlyOwner {

266:     function setPyth(address _pyth) external nonReentrant onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

39:     function initialize(address _tradeService, address _tlc, address _tlcStaking) external initializer {

71:     function _mintTLC(address _primaryAccount, uint256 _sizeDelta, uint256 _marketIndex) internal {

85:     function setMarketWeight(uint256 _marketIndex, uint256 _weight) external onlyOwner {

90:     function setWhitelistedCallers(address[] calldata _callers, bool[] calldata _isWhitelisteds) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

131:     function validateServiceExecutor(address _contractAddress, address _executorAddress) external view {

135:     function validateAcceptedLiquidityToken(address _token) external view {

141:     function validateAcceptedCollateral(address _token) external view {

149:     function getTradingConfig() external view returns (TradingConfig memory) {

153:     function getMarketConfigByIndex(uint256 _index) external view returns (MarketConfig memory _marketConfig) {

169:     function getAssetTokenDecimal(address _token) external view returns (uint8) {

173:     function getLiquidityConfig() external view returns (LiquidityConfig memory) {

177:     function getLiquidationConfig() external view returns (LiquidationConfig memory) {

181:     function getMarketConfigs() external view returns (MarketConfig[] memory) {

185:     function getMarketConfigsLength() external view returns (uint256) {

189:     function getAssetClassConfigsLength() external view returns (uint256) {

193:     function getHlpTokens() external view returns (address[] memory) {

208:     function getAssetConfigByToken(address _token) external view returns (AssetConfig memory) {

212:     function getCollateralTokens() external view returns (address[] memory) {

229:     function getAssetConfig(bytes32 _assetId) external view returns (AssetConfig memory) {

233:     function getAssetHlpTokenConfig(bytes32 _assetId) external view returns (HLPTokenConfig memory) {

237:     function getAssetHlpTokenConfigByToken(address _token) external view returns (HLPTokenConfig memory) {

241:     function getHlpAssetIds() external view returns (bytes32[] memory) {

245:     function getTradeServiceHooks() external view returns (address[] memory) {

253:     function setConfigExecutor(address _executorAddress, bool _isServiceExecutor) external onlyOwner {

259:     function setMinimumPositionSize(uint256 _minimumPositionSize) external onlyOwner {

264:     function setCalculator(address _calculator) external onlyOwner {

272:     function setOracle(address _oracle) external onlyOwner {

280:     function setHLP(address _hlp) external onlyOwner {

287:     function setLiquidityConfig(LiquidityConfig calldata _liquidityConfig) external onlyOwner {

310:     function setLiquidityEnabled(bool _enabled) external onlyWhitelistedExecutor {

315:     function setDynamicEnabled(bool _enabled) external onlyOwner {

328:     function _setServiceExecutor(address _contractAddress, address _executorAddress, bool _isServiceExecutor) internal {

357:     function setPnlFactor(uint32 _pnlFactorBPS) external onlyOwner {

362:     function setSwapConfig(SwapConfig calldata _newConfig) external onlyOwner {

367:     function setTradingConfig(TradingConfig calldata _newConfig) external onlyOwner {

374:     function setLiquidationConfig(LiquidationConfig calldata _newConfig) external onlyOwner {

465:     function setAssetConfigs(bytes32[] calldata _assetIds, AssetConfig[] calldata _newConfigs) external onlyOwner {

496:     function setWeth(address _weth) external onlyOwner {

503:     function setSGlp(address _sglp) external onlyOwner {

512:     function setSwitchCollateralRouter(address _newSwitchCollateralRouter) external onlyOwner {

573:     function addAssetClassConfig(AssetClassConfig calldata _newConfig) external onlyOwner returns (uint256 _index) {

580:     function setAssetClassConfigByIndex(uint256 _index, AssetClassConfig calldata _newConfig) external onlyOwner {

603:     function delistMarket(uint256 _marketIndex) external onlyOwner {

615:     function removeAcceptedToken(address _token) external onlyOwner {

640:     function setTradeServiceHooks(address[] calldata _newHooks) external onlyOwner {

674:     function addStepMinProfitDuration(StepMinProfitDuration[] memory _stepMinProfitDurations) external onlyOwner {

704:     function removeLastStepMinProfitDuration() external onlyOwner {

712:     function getStepMinProfitDuration(uint256 marketIndex, uint256 sizeDelta) external view returns (uint256) {

729:     function getStepMinProfitDurations() external view returns (StepMinProfitDuration[] memory) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

38:     function name() external pure returns (string memory) {

46:     function symbol() external pure returns (string memory) {

63:     function decimals() external pure returns (uint8) {

70:     function totalSupply() external view returns (uint256) {

77:     function balanceOf(address account) external view returns (uint256) {

81:     function balanceOf(uint256 epochTimestamp, address account) external view returns (uint256) {

93:     function transfer(address to, uint256 amount) public returns (bool) {

101:     function allowance(address user, address spender) public view returns (uint256) {

115:     function approve(address spender, uint256 amount) public returns (bool) {

137:     function transferFrom(address from, address to, uint256 amount) public returns (bool) {

156:     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

176:     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

201:     function _transfer(uint256 epochTimestamp, address from, address to, uint256 amount) internal {

230:     function mint(address account, uint256 amount) external onlyMinter {

260:     function _burn(uint256 epochTimestamp, address account, uint256 amount) internal virtual {

292:     function _approve(address user, address spender, uint256 amount) internal {

308:     function _spendAllowance(address user, address spender, uint256 amount) internal {

332:     function _beforeTokenTransfer(address from, address to, uint256 amount) internal {}

348:     function _afterTokenTransfer(address from, address to, uint256 amount) internal {}

350:     function getCurrentEpochTimestamp() public view returns (uint256 epochTimestamp) {

354:     function setMinter(address _minter, bool _mintable) external onlyOwner {

360:     function isMinter(address _minter) external view returns (bool) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-10"></a>[NC-10] Change uint to uint256
Throughout the code base, some variables are declared as `uint`. To favor explicitness, consider changing all instances of `uint` to `uint256`

*Instances (1)*:
```solidity
File: src/handlers/IntentHandler.sol

193:         } catch Panic(uint /*errorCode*/) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

### <a name="NC-11"></a>[NC-11] Lack of checks in setters
Be it sanity checks (like checks against `0`-values) or initial setting checks: it's best for Setter functions to have them

*Instances (21)*:
```solidity
File: src/contracts/FLP.sol

36:     function setMinter(address minter, bool isMinter) external onlyOwner {
            minters[minter] = isMinter;
            emit SetMinter(minter, isMinter);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

72:     function setRouteOf(address _tokenIn, address _tokenOut, IRouter.Route[] calldata _route) external onlyOwner {
            // Emit the event with the current old route
            emit LogSetRouteOf(_tokenIn, _tokenOut, routeOf[_tokenIn][_tokenOut], _route);
    
            // Delete the old route
            delete routeOf[_tokenIn][_tokenOut];
    
            // Copy the new route from calldata to storage
            for (uint256 i = 0; i < _route.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

60:     function setDelegate(address _delegate) external {
            delegations[msg.sender] = _delegate;
            emit LogSetDelegate(msg.sender, _delegate);

261:     function setTradeOrderHelper(address _newTradeOrderHelper) external nonReentrant onlyOwner {
             emit LogSetTradeOrderHelper(address(tradeOrderHelper), _newTradeOrderHelper);
             tradeOrderHelper = TradeOrderHelper(_newTradeOrderHelper);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

85:     function setMarketWeight(uint256 _marketIndex, uint256 _weight) external onlyOwner {
            emit LogSetMarketWeight(_marketIndex, marketWeights[_marketIndex], _weight);
            marketWeights[_marketIndex] = _weight;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

259:     function setMinimumPositionSize(uint256 _minimumPositionSize) external onlyOwner {
             emit LogSetMinimumPositionSize(minimumPositionSize, _minimumPositionSize);
             minimumPositionSize = _minimumPositionSize;

264:     function setCalculator(address _calculator) external onlyOwner {
             emit LogSetCalculator(calculator, _calculator);
             calculator = _calculator;
     
             // Sanity check
             ICalculator(_calculator).getPendingBorrowingFeeE30();

272:     function setOracle(address _oracle) external onlyOwner {
             emit LogSetOracle(oracle, _oracle);
             oracle = _oracle;
     
             // Sanity check
             IOracleMiddleware(_oracle).isUpdater(_oracle);

310:     function setLiquidityEnabled(bool _enabled) external onlyWhitelistedExecutor {
             emit LogSetLiquidityEnabled(liquidityConfig.enabled, _enabled);
             liquidityConfig.enabled = _enabled;

315:     function setDynamicEnabled(bool _enabled) external onlyOwner {
             liquidityConfig.dynamicFeeEnabled = _enabled;
             emit LogSetDynamicEnabled(_enabled);

320:     function setServiceExecutor(
             address _contractAddress,
             address _executorAddress,
             bool _isServiceExecutor
         ) external onlyOwner {
             _setServiceExecutor(_contractAddress, _executorAddress, _isServiceExecutor);

357:     function setPnlFactor(uint32 _pnlFactorBPS) external onlyOwner {
             emit LogSetPnlFactor(pnlFactorBPS, _pnlFactorBPS);
             pnlFactorBPS = _pnlFactorBPS;

362:     function setSwapConfig(SwapConfig calldata _newConfig) external onlyOwner {
             emit LogSetSwapConfig(swapConfig, _newConfig);
             swapConfig = _newConfig;

374:     function setLiquidationConfig(LiquidationConfig calldata _newConfig) external onlyOwner {
             emit LogSetLiquidationConfig(liquidationConfig, _newConfig);
             liquidationConfig = _newConfig;

396:     function setHlpTokenConfig(
             address _token,
             HLPTokenConfig calldata _newConfig
         ) external onlyOwner returns (HLPTokenConfig memory _hlpTokenConfig) {
             emit LogSetHlpTokenConfig(_token, assetHlpTokenConfigs[tokenAssetIds[_token]], _newConfig);
             assetHlpTokenConfigs[tokenAssetIds[_token]] = _newConfig;
     
             uint256 hlpTotalTokenWeight = 0;
             for (uint256 i = 0; i < hlpAssetIds.length; ) {
                 hlpTotalTokenWeight += assetHlpTokenConfigs[hlpAssetIds[i]].targetWeight;
     
                 unchecked {
                     ++i;
                 }
             }
     
             liquidityConfig.hlpTotalTokenWeight = hlpTotalTokenWeight;
     
             return _newConfig;

417:     function setCollateralTokenConfig(
             bytes32 _assetId,
             CollateralTokenConfig calldata _newConfig
         ) external onlyOwner returns (CollateralTokenConfig memory _collateralTokenConfig) {
             return _setCollateralTokenConfig(_assetId, _newConfig);

458:     function setAssetConfig(
             bytes32 _assetId,
             AssetConfig calldata _newConfig
         ) external onlyOwner returns (AssetConfig memory _assetConfig) {
             return _setAssetConfig(_assetId, _newConfig);

512:     function setSwitchCollateralRouter(address _newSwitchCollateralRouter) external onlyOwner {
             emit LogSetSwitchCollateralRouter(switchCollateralRouter, _newSwitchCollateralRouter);
             switchCollateralRouter = _newSwitchCollateralRouter;

573:     function addAssetClassConfig(AssetClassConfig calldata _newConfig) external onlyOwner returns (uint256 _index) {
             uint256 _newAssetClassIndex = assetClassConfigs.length;
             assetClassConfigs.push(_newConfig);
             emit LogAddAssetClassConfig(_newAssetClassIndex, _newConfig);
             return _newAssetClassIndex;

580:     function setAssetClassConfigByIndex(uint256 _index, AssetClassConfig calldata _newConfig) external onlyOwner {
             emit LogSetAssetClassConfigByIndex(_index, assetClassConfigs[_index], _newConfig);
             assetClassConfigs[_index] = _newConfig;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

354:     function setMinter(address _minter, bool _mintable) external onlyOwner {
             minter[_minter] = _mintable;
     
             emit SetMinter(_minter, _mintable);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-12"></a>[NC-12] Lines are too long
Usually lines in source code are limited to [80](https://softwareengineering.stackexchange.com/questions/148677/why-is-80-characters-the-standard-limit-for-code-width) characters. Today's screens are much larger so it's reasonable to stretch this in some cases. Since the files will most likely reside in GitHub, and GitHub starts using a scroll bar in all cases when the length is over [164](https://github.com/aizatto/character-length) characters, the lines below should be split when they reach that length

*Instances (1)*:
```solidity
File: src/handlers/IntentHandler.sol

234:                         "TradeOrder(uint256 marketIndex,int256 sizeDelta,uint256 triggerPrice,uint256 acceptablePrice,bool triggerAboveThreshold,bool reduceOnly,address tpToken,uint256 createdTimestamp,uint256 expiryTimestamp,address account,uint8 subAccountId)"

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

### <a name="NC-13"></a>[NC-13] Missing Event for critical parameters change
Events help non-contract tools to track changes, and events prevent users from being surprised by changes.

*Instances (8)*:
```solidity
File: src/handlers/IntentHandler.sol

266:     function setPyth(address _pyth) external nonReentrant onlyOwner {
             if (_pyth == address(0)) revert IntentHandler_InvalidAddress();
             // Sanity check
             IEcoPyth(_pyth).getAssetIds();
     
             pyth = IEcoPyth(_pyth);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/storages/ConfigStorage.sol

320:     function setServiceExecutor(
             address _contractAddress,
             address _executorAddress,
             bool _isServiceExecutor
         ) external onlyOwner {
             _setServiceExecutor(_contractAddress, _executorAddress, _isServiceExecutor);

339:     function setServiceExecutors(
             address[] calldata _contractAddresses,
             address[] calldata _executorAddresses,
             bool[] calldata _isServiceExecutors
         ) external onlyOwner {
             if (
                 _contractAddresses.length != _executorAddresses.length ||
                 _executorAddresses.length != _isServiceExecutors.length
             ) revert IConfigStorage_BadArgs();
     
             for (uint256 i = 0; i < _contractAddresses.length; ) {

417:     function setCollateralTokenConfig(
             bytes32 _assetId,
             CollateralTokenConfig calldata _newConfig
         ) external onlyOwner returns (CollateralTokenConfig memory _collateralTokenConfig) {
             return _setCollateralTokenConfig(_assetId, _newConfig);

424:     function setCollateralTokenConfigs(
             bytes32[] calldata _assetIds,
             CollateralTokenConfig[] calldata _newConfigs
         ) external onlyOwner {
             if (_assetIds.length != _newConfigs.length) revert IConfigStorage_BadLen();
             for (uint256 i = 0; i < _assetIds.length; ) {

458:     function setAssetConfig(
             bytes32 _assetId,
             AssetConfig calldata _newConfig
         ) external onlyOwner returns (AssetConfig memory _assetConfig) {
             return _setAssetConfig(_assetId, _newConfig);

465:     function setAssetConfigs(bytes32[] calldata _assetIds, AssetConfig[] calldata _newConfigs) external onlyOwner {
             if (_assetIds.length != _newConfigs.length) revert IConfigStorage_BadLen();
             for (uint256 i = 0; i < _assetIds.length; ) {

733:     function setIsStepMinProfitEnabledByMarketIndex(
             uint256[] memory marketIndexes,
             bool[] memory isEnableds
         ) external onlyOwner {
             if (marketIndexes.length != isEnableds.length) revert IConfigStorage_BadLen();
             uint256 length = marketIndexes.length;
             for (uint256 i; i < length; ) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="NC-14"></a>[NC-14] NatSpec is completely non-existent on functions that should have them
Public and external functions that aren't view or pure should have NatSpec comments

*Instances (49)*:
```solidity
File: src/contracts/FLP.sol

30:     function initialize() external initializer {

36:     function setMinter(address minter, bool isMinter) external onlyOwner {

41:     function mint(address to, uint256 amount) external onlyMinter {

45:     function burn(address from, uint256 amount) external onlyMinter {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/handlers/IntentHandler.sol

44:     function initialize(

60:     function setDelegate(address _delegate) external {

65:     function execute(ExecuteIntentInputs memory inputs) external onlyIntentExecutors {

261:     function setTradeOrderHelper(address _newTradeOrderHelper) external nonReentrant onlyOwner {

266:     function setPyth(address _pyth) external nonReentrant onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

39:     function initialize(address _tradeService, address _tlc, address _tlcStaking) external initializer {

51:     function onIncreasePosition(

61:     function onDecreasePosition(

85:     function setMarketWeight(uint256 _marketIndex, uint256 _weight) external onlyOwner {

90:     function setWhitelistedCallers(address[] calldata _callers, bool[] calldata _isWhitelisteds) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

121:     function initialize() external initializer {

259:     function setMinimumPositionSize(uint256 _minimumPositionSize) external onlyOwner {

264:     function setCalculator(address _calculator) external onlyOwner {

272:     function setOracle(address _oracle) external onlyOwner {

280:     function setHLP(address _hlp) external onlyOwner {

287:     function setLiquidityConfig(LiquidityConfig calldata _liquidityConfig) external onlyOwner {

310:     function setLiquidityEnabled(bool _enabled) external onlyWhitelistedExecutor {

315:     function setDynamicEnabled(bool _enabled) external onlyOwner {

320:     function setServiceExecutor(

339:     function setServiceExecutors(

357:     function setPnlFactor(uint32 _pnlFactorBPS) external onlyOwner {

362:     function setSwapConfig(SwapConfig calldata _newConfig) external onlyOwner {

367:     function setTradingConfig(TradingConfig calldata _newConfig) external onlyOwner {

374:     function setLiquidationConfig(LiquidationConfig calldata _newConfig) external onlyOwner {

379:     function setMarketConfig(

396:     function setHlpTokenConfig(

417:     function setCollateralTokenConfig(

424:     function setCollateralTokenConfigs(

458:     function setAssetConfig(

465:     function setAssetConfigs(bytes32[] calldata _assetIds, AssetConfig[] calldata _newConfigs) external onlyOwner {

496:     function setWeth(address _weth) external onlyOwner {

503:     function setSGlp(address _sglp) external onlyOwner {

573:     function addAssetClassConfig(AssetClassConfig calldata _newConfig) external onlyOwner returns (uint256 _index) {

580:     function setAssetClassConfigByIndex(uint256 _index, AssetClassConfig calldata _newConfig) external onlyOwner {

585:     function addMarketConfig(

603:     function delistMarket(uint256 _marketIndex) external onlyOwner {

608:     function deleteLastMarket() external onlyOwner {

640:     function setTradeServiceHooks(address[] calldata _newHooks) external onlyOwner {

653:     function setMinProfitDurations(

674:     function addStepMinProfitDuration(StepMinProfitDuration[] memory _stepMinProfitDurations) external onlyOwner {

687:     function setStepMinProfitDuration(

704:     function removeLastStepMinProfitDuration() external onlyOwner {

733:     function setIsStepMinProfitEnabledByMarketIndex(

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

31:     function initialize() external initializer {

354:     function setMinter(address _minter, bool _mintable) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-15"></a>[NC-15] Incomplete NatSpec: `@param` is missing on actually documented functions
The following functions are missing `@param` NatSpec comments.

*Instances (7)*:
```solidity
File: src/storages/ConfigStorage.sol

249:     /**
          * Setter
          */
     
         function setConfigExecutor(address _executorAddress, bool _isServiceExecutor) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

85:     /**
         * @dev See {IERC20-transfer}.
         *
         * Requirements:
         *
         * - `to` cannot be the zero address.
         * - the caller must have a balance of at least `amount`.
         */
        function transfer(address to, uint256 amount) public returns (bool) {

105:     /**
          * @dev See {IERC20-approve}.
          *
          * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
          * `transferFrom`. This is semantically equivalent to an infinite approval.
          *
          * Requirements:
          *
          * - `spender` cannot be the zero address.
          */
         function approve(address spender, uint256 amount) public returns (bool) {

121:     /**
          * @dev See {IERC20-transferFrom}.
          *
          * Emits an {Approval} event indicating the updated allowance. This is not
          * required by the EIP. See the note at the beginning of {ERC20}.
          *
          * NOTE: Does not update the allowance if the current allowance
          * is the maximum `uint256`.
          *
          * Requirements:
          *
          * - `from` and `to` cannot be the zero address.
          * - `from` must have a balance of at least `amount`.
          * - the caller must have allowance for ``from``'s tokens of at least
          * `amount`.
          */
         function transferFrom(address from, address to, uint256 amount) public returns (bool) {

144:     /**
          * @dev Atomically increases the allowance granted to `spender` by the caller.
          *
          * This is an alternative to {approve} that can be used as a mitigation for
          * problems described in {IERC20-approve}.
          *
          * Emits an {Approval} event indicating the updated allowance.
          *
          * Requirements:
          *
          * - `spender` cannot be the zero address.
          */
         function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

162:     /**
          * @dev Atomically decreases the allowance granted to `spender` by the caller.
          *
          * This is an alternative to {approve} that can be used as a mitigation for
          * problems described in {IERC20-approve}.
          *
          * Emits an {Approval} event indicating the updated allowance.
          *
          * Requirements:
          *
          * - `spender` cannot be the zero address.
          * - `spender` must have allowance for the caller of at least
          * `subtractedValue`.
          */
         function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

221:     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
          * the total supply.
          *
          * Emits a {Transfer} event with `from` set to the zero address.
          *
          * Requirements:
          *
          * - `account` cannot be the zero address.
          */
         function mint(address account, uint256 amount) external onlyMinter {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-16"></a>[NC-16] Incomplete NatSpec: `@return` is missing on actually documented functions
The following functions are missing `@return` NatSpec comments.

*Instances (6)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

35:     /// @notice Run the extension logic to swap on Uniswap V3.
        /// @param _tokenIn The token to swap from.
        /// @param _tokenOut The token to swap to.
        /// @param _amountIn The amount of _tokenIn to swap.
        function run(
            address _tokenIn,
            address _tokenOut,
            uint256 _amountIn
        ) external override returns (uint256 _amountOut) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

85:     /**
         * @dev See {IERC20-transfer}.
         *
         * Requirements:
         *
         * - `to` cannot be the zero address.
         * - the caller must have a balance of at least `amount`.
         */
        function transfer(address to, uint256 amount) public returns (bool) {

105:     /**
          * @dev See {IERC20-approve}.
          *
          * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
          * `transferFrom`. This is semantically equivalent to an infinite approval.
          *
          * Requirements:
          *
          * - `spender` cannot be the zero address.
          */
         function approve(address spender, uint256 amount) public returns (bool) {

121:     /**
          * @dev See {IERC20-transferFrom}.
          *
          * Emits an {Approval} event indicating the updated allowance. This is not
          * required by the EIP. See the note at the beginning of {ERC20}.
          *
          * NOTE: Does not update the allowance if the current allowance
          * is the maximum `uint256`.
          *
          * Requirements:
          *
          * - `from` and `to` cannot be the zero address.
          * - `from` must have a balance of at least `amount`.
          * - the caller must have allowance for ``from``'s tokens of at least
          * `amount`.
          */
         function transferFrom(address from, address to, uint256 amount) public returns (bool) {

144:     /**
          * @dev Atomically increases the allowance granted to `spender` by the caller.
          *
          * This is an alternative to {approve} that can be used as a mitigation for
          * problems described in {IERC20-approve}.
          *
          * Emits an {Approval} event indicating the updated allowance.
          *
          * Requirements:
          *
          * - `spender` cannot be the zero address.
          */
         function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

162:     /**
          * @dev Atomically decreases the allowance granted to `spender` by the caller.
          *
          * This is an alternative to {approve} that can be used as a mitigation for
          * problems described in {IERC20-approve}.
          *
          * Emits an {Approval} event indicating the updated allowance.
          *
          * Requirements:
          *
          * - `spender` cannot be the zero address.
          * - `spender` must have allowance for the caller of at least
          * `subtractedValue`.
          */
         function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-17"></a>[NC-17] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor
If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (5)*:
```solidity
File: src/contracts/FLP.sol

24:         if (!minters[msg.sender]) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/handlers/IntentHandler.sol

40:         if (!intentExecutors[msg.sender]) revert IntentHandler_Unauthorized();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

32:         if (!whitelistedCallers[msg.sender]) revert TLCHook_Forbidden();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

117:         if (!configExecutors[msg.sender]) revert IConfigStorage_NotWhiteListed();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

27:         if (!minter[msg.sender]) revert TLC_NotMinter();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-18"></a>[NC-18] Constant state variables defined more than once
Rather than redefining state variable constant, consider using a library to store all constants as this will prevent data redundancy

*Instances (2)*:
```solidity
File: src/staking/FTCHook.sol

21:     uint32 internal constant BPS = 100_00;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

63:     uint256 public constant BPS = 1e4;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="NC-19"></a>[NC-19] Consider using named mappings
Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (13)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

22:     mapping(address => mapping(address => IRouter.Route[])) public routeOf;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/storages/ConfigStorage.sol

74:     mapping(address => bool) public allowedLiquidators; // allowed contract to execute liquidation service

75:     mapping(address => mapping(address => bool)) public serviceExecutors; // service => handler => isOK, to allowed executor for service layer

87:     mapping(address => bytes32) public tokenAssetIds;

89:     mapping(bytes32 => AssetConfig) public assetConfigs;

92:     mapping(bytes32 => HLPTokenConfig) public assetHlpTokenConfigs;

95:     mapping(bytes32 => CollateralTokenConfig) public assetCollateralTokenConfigs;

101:     mapping(address => bool) public configExecutors;

214:         mapping(bytes32 => AssetConfig) storage _assetConfigs = assetConfigs;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

13:     mapping(uint256 => mapping(address => uint256)) private _balances;

15:     mapping(address => mapping(address => uint256)) private _allowances;

18:     mapping(uint256 => uint256) public totalSupplyByEpoch;

24:     mapping(address => bool) public minter;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-20"></a>[NC-20] Adding a `return` statement when the function defines a named return variable, is redundant

*Instances (14)*:
```solidity
File: src/handlers/IntentHandler.sol

183:     function _executeTradeOrder(
             ExecuteTradeOrderVars memory vars,
             bytes32 key
         ) internal returns (bool isSuccess, uint256 oraclePrice, uint256 executedPrice, bool isFullClose) {
             // try executing order
             try tradeOrderHelper.execute(vars) returns (uint256 _oraclePrice, uint256 _executedPrice, bool _isFullClose) {
                 // Execution succeeded
                 return (true, _oraclePrice, _executedPrice, _isFullClose);
             } catch Error(string memory errMsg) {
                 _handleOrderFail(vars, bytes(errMsg), key);
             } catch Panic(uint /*errorCode*/) {
                 _handleOrderFail(vars, bytes("Panic occurred while executing trade order"), key);
             } catch (bytes memory errMsg) {
                 _handleOrderFail(vars, errMsg, key);
             }
             return (false, 0, 0, false);

183:     function _executeTradeOrder(
             ExecuteTradeOrderVars memory vars,
             bytes32 key
         ) internal returns (bool isSuccess, uint256 oraclePrice, uint256 executedPrice, bool isFullClose) {
             // try executing order
             try tradeOrderHelper.execute(vars) returns (uint256 _oraclePrice, uint256 _executedPrice, bool _isFullClose) {
                 // Execution succeeded
                 return (true, _oraclePrice, _executedPrice, _isFullClose);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/storages/ConfigStorage.sol

153:     function getMarketConfigByIndex(uint256 _index) external view returns (MarketConfig memory _marketConfig) {
             return marketConfigs[_index];

157:     function getAssetClassConfigByIndex(
             uint256 _index
         ) external view returns (AssetClassConfig memory _assetClassConfig) {
             return assetClassConfigs[_index];

163:     function getCollateralTokenConfigs(
             address _token
         ) external view returns (CollateralTokenConfig memory _collateralTokenConfig) {
             return assetCollateralTokenConfigs[tokenAssetIds[_token]];

379:     function setMarketConfig(
             uint256 _marketIndex,
             MarketConfig calldata _newConfig,
             bool _isAdaptiveFeeEnabled
         ) external onlyOwner returns (MarketConfig memory _marketConfig) {
             if (_newConfig.increasePositionFeeRateBPS > MAX_FEE_BPS || _newConfig.decreasePositionFeeRateBPS > MAX_FEE_BPS)
                 revert IConfigStorage_MaxFeeBps();
             if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();
             if (_newConfig.initialMarginFractionBPS < _newConfig.maintenanceMarginFractionBPS)
                 revert IConfigStorage_InvalidValue();
     
             emit LogSetMarketConfig(_marketIndex, marketConfigs[_marketIndex], _newConfig);
             marketConfigs[_marketIndex] = _newConfig;
             isAdaptiveFeeEnabledByMarketIndex[_marketIndex] = _isAdaptiveFeeEnabled;
             return _newConfig;

396:     function setHlpTokenConfig(
             address _token,
             HLPTokenConfig calldata _newConfig
         ) external onlyOwner returns (HLPTokenConfig memory _hlpTokenConfig) {
             emit LogSetHlpTokenConfig(_token, assetHlpTokenConfigs[tokenAssetIds[_token]], _newConfig);
             assetHlpTokenConfigs[tokenAssetIds[_token]] = _newConfig;
     
             uint256 hlpTotalTokenWeight = 0;
             for (uint256 i = 0; i < hlpAssetIds.length; ) {
                 hlpTotalTokenWeight += assetHlpTokenConfigs[hlpAssetIds[i]].targetWeight;
     
                 unchecked {
                     ++i;
                 }
             }
     
             liquidityConfig.hlpTotalTokenWeight = hlpTotalTokenWeight;
     
             return _newConfig;

417:     function setCollateralTokenConfig(
             bytes32 _assetId,
             CollateralTokenConfig calldata _newConfig
         ) external onlyOwner returns (CollateralTokenConfig memory _collateralTokenConfig) {
             return _setCollateralTokenConfig(_assetId, _newConfig);

438:     function _setCollateralTokenConfig(
             bytes32 _assetId,
             CollateralTokenConfig calldata _newConfig
         ) internal returns (CollateralTokenConfig memory _collateralTokenConfig) {
             if (_newConfig.collateralFactorBPS == 0) revert IConfigStorage_ExceedLimitSetting();
     
             emit LogSetCollateralTokenConfig(_assetId, assetCollateralTokenConfigs[_assetId], _newConfig);
             // get current config, if new collateral's assetId then push to array
             CollateralTokenConfig memory _curCollateralTokenConfig = assetCollateralTokenConfigs[_assetId];
             if (
                 _curCollateralTokenConfig.settleStrategy == address(0) &&
                 _curCollateralTokenConfig.collateralFactorBPS == 0 &&
                 _curCollateralTokenConfig.accepted == false
             ) {
                 collateralAssetIds.push(_assetId);
             }
             assetCollateralTokenConfigs[_assetId] = _newConfig;
             return assetCollateralTokenConfigs[_assetId];

458:     function setAssetConfig(
             bytes32 _assetId,
             AssetConfig calldata _newConfig
         ) external onlyOwner returns (AssetConfig memory _assetConfig) {
             return _setAssetConfig(_assetId, _newConfig);

476:     function _setAssetConfig(
             bytes32 _assetId,
             AssetConfig calldata _newConfig
         ) internal returns (AssetConfig memory _assetConfig) {
             if (!_newConfig.tokenAddress.isContract()) revert IConfigStorage_BadArgs();
     
             emit LogSetAssetConfig(_assetId, assetConfigs[_assetId], _newConfig);
             assetConfigs[_assetId] = _newConfig;
             address _token = _newConfig.tokenAddress;
     
             if (_token != address(0)) {
                 tokenAssetIds[_token] = _assetId;
     
                 // sanity check
                 ERC20Upgradeable(_token).decimals();
             }
     
             return assetConfigs[_assetId];

573:     function addAssetClassConfig(AssetClassConfig calldata _newConfig) external onlyOwner returns (uint256 _index) {
             uint256 _newAssetClassIndex = assetClassConfigs.length;
             assetClassConfigs.push(_newConfig);
             emit LogAddAssetClassConfig(_newAssetClassIndex, _newConfig);
             return _newAssetClassIndex;

585:     function addMarketConfig(
             MarketConfig calldata _newConfig,
             bool _isAdaptiveFeeEnabled
         ) external onlyOwner returns (uint256 _newMarketIndex) {
             // pre-validate
             if (_newConfig.increasePositionFeeRateBPS > MAX_FEE_BPS || _newConfig.decreasePositionFeeRateBPS > MAX_FEE_BPS)
                 revert IConfigStorage_MaxFeeBps();
             if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();
             if (_newConfig.initialMarginFractionBPS < _newConfig.maintenanceMarginFractionBPS)
                 revert IConfigStorage_InvalidValue();
     
             _newMarketIndex = marketConfigs.length;
             marketConfigs.push(_newConfig);
             isAdaptiveFeeEnabledByMarketIndex[_newMarketIndex] = _isAdaptiveFeeEnabled;
             emit LogAddMarketConfig(_newMarketIndex, _newConfig);
             return _newMarketIndex;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

350:     function getCurrentEpochTimestamp() public view returns (uint256 epochTimestamp) {
             return (block.timestamp / epochLength) * epochLength;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-21"></a>[NC-21] `require()` / `revert()` statements should have descriptive reason strings

*Instances (1)*:
```solidity
File: src/contracts/FLP.sol

25:             revert IHLP.IHLP_onlyMinter();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

### <a name="NC-22"></a>[NC-22] Take advantage of Custom Error's return value property
An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (50)*:
```solidity
File: src/contracts/FLP.sol

25:             revert IHLP.IHLP_onlyMinter();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

46:             revert AerodromeRouterSwitchCollateralExt_BadPath();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

40:         if (!intentExecutors[msg.sender]) revert IntentHandler_Unauthorized();

66:         if (inputs.accountAndSubAccountIds.length != inputs.cmds.length) revert IntentHandler_BadLength();

256:         if (_executor == address(0)) revert IntentHandler_InvalidAddress();

267:         if (_pyth == address(0)) revert IntentHandler_InvalidAddress();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

32:         if (!whitelistedCallers[msg.sender]) revert TLCHook_Forbidden();

91:         if (_callers.length != _isWhitelisteds.length) revert TLCHook_BadArgs();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

117:         if (!configExecutors[msg.sender]) revert IConfigStorage_NotWhiteListed();

132:         if (!serviceExecutors[_contractAddress][_executorAddress]) revert IConfigStorage_NotWhiteListed();

136:         if (!assetHlpTokenConfigs[tokenAssetIds[_token]].accepted) revert IConfigStorage_NotAcceptedLiquidity();

142:         if (!assetCollateralTokenConfigs[tokenAssetIds[_token]].accepted) revert IConfigStorage_NotAcceptedCollateral();

254:         if (!_executorAddress.isContract()) revert IConfigStorage_InvalidAddress();

281:         if (_hlp == address(0)) revert IConfigStorage_InvalidAddress();

293:         ) revert IConfigStorage_MaxFeeBps();

294:         if (_liquidityConfig.maxHLPUtilizationBPS > BPS) revert IConfigStorage_ExceedLimitSetting();

334:         ) revert IConfigStorage_InvalidAddress();

347:         ) revert IConfigStorage_BadArgs();

369:             revert IConfigStorage_ExceedLimitSetting();

385:             revert IConfigStorage_MaxFeeBps();

386:         if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();

388:             revert IConfigStorage_InvalidValue();

428:         if (_assetIds.length != _newConfigs.length) revert IConfigStorage_BadLen();

442:         if (_newConfig.collateralFactorBPS == 0) revert IConfigStorage_ExceedLimitSetting();

466:         if (_assetIds.length != _newConfigs.length) revert IConfigStorage_BadLen();

480:         if (!_newConfig.tokenAddress.isContract()) revert IConfigStorage_BadArgs();

497:         if (!_weth.isContract()) revert IConfigStorage_BadArgs();

504:         if (!_sglp.isContract()) revert IConfigStorage_BadArgs();

527:             revert IConfigStorage_BadLen();

591:             revert IConfigStorage_MaxFeeBps();

592:         if (_newConfig.assetClass > assetClassConfigs.length - 1) revert IConfigStorage_InvalidAssetClass();

594:             revert IConfigStorage_InvalidValue();

642:             if (_newHooks[i] == address(0)) revert IConfigStorage_InvalidAddress();

657:         if (_marketIndexs.length != _minProfitDurations.length) revert IConfigStorage_BadArgs();

662:             if (_minProfitDurations[i] > MAX_DURATION) revert IConfigStorage_MaxDurationForMinProfit();

678:                 revert IConfigStorage_BadArgs();

691:         if (indexes.length != _stepMinProfitDurations.length) revert IConfigStorage_BadLen();

695:                 revert IConfigStorage_BadArgs();

737:         if (marketIndexes.length != isEnableds.length) revert IConfigStorage_BadLen();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

27:         if (!minter[msg.sender]) revert TLC_NotMinter();

179:         if (currentAllowance < subtractedValue) revert TLC_AllowanceBelowZero();

202:         if (from == address(0)) revert TLC_TransferFromZeroAddress();

203:         if (to == address(0)) revert TLC_TransferToZeroAddress();

208:         if (fromBalance < amount) revert TLC_TransferAmountExceedsBalance();

231:         if (account == address(0)) revert TLC_MintToZeroAddress();

261:         if (account == address(0)) revert TLC_BurnFromZeroAddress();

266:         if (accountBalance < amount) revert TLC_BurnAmountExceedsBalance();

293:         if (user == address(0)) revert TLC_ApproveFromZeroAddress();

294:         if (spender == address(0)) revert TLC_ApproveToZeroAddress();

311:             if (currentAllowance < amount) revert TLC_InsufficientAllowance();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-23"></a>[NC-23] Avoid the use of sensitive terms
Use [alternative variants](https://www.zdnet.com/article/mysql-drops-master-slave-and-blacklist-whitelist-terminology/), e.g. allowlist/denylist instead of whitelist/blacklist

*Instances (14)*:
```solidity
File: src/staking/FTCHook.sol

29:     mapping(address whitelisted => bool isWhitelisted) public whitelistedCallers;

31:     modifier onlyWhitelistedCaller() {

32:         if (!whitelistedCallers[msg.sender]) revert TLCHook_Forbidden();

37:     event LogSetWhitelistedCaller(address indexed caller, bool isWhitelisted);

57:     ) external onlyWhitelistedCaller {

67:     ) external onlyWhitelistedCaller {

90:     function setWhitelistedCallers(address[] calldata _callers, bool[] calldata _isWhitelisteds) external onlyOwner {

91:         if (_callers.length != _isWhitelisteds.length) revert TLCHook_BadArgs();

93:             whitelistedCallers[_callers[i]] = _isWhitelisteds[i];

95:             emit LogSetWhitelistedCaller(_callers[i], _isWhitelisteds[i]);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

116:     modifier onlyWhitelistedExecutor() {

117:         if (!configExecutors[msg.sender]) revert IConfigStorage_NotWhiteListed();

132:         if (!serviceExecutors[_contractAddress][_executorAddress]) revert IConfigStorage_NotWhiteListed();

310:     function setLiquidityEnabled(bool _enabled) external onlyWhitelistedExecutor {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="NC-24"></a>[NC-24] Contract does not follow the Solidity style guide's suggested layout ordering
The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (4)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

1: 
   Current order:
   UsingForDirective.ERC20
   ErrorDefinition.AerodromeRouterSwitchCollateralExt_BadPath
   VariableDeclaration.router
   VariableDeclaration.routeOf
   EventDefinition.LogSetRouteOf
   FunctionDefinition.constructor
   FunctionDefinition.run
   FunctionDefinition.setRouteOf
   
   Suggested order:
   UsingForDirective.ERC20
   VariableDeclaration.router
   VariableDeclaration.routeOf
   ErrorDefinition.AerodromeRouterSwitchCollateralExt_BadPath
   EventDefinition.LogSetRouteOf
   FunctionDefinition.constructor
   FunctionDefinition.run
   FunctionDefinition.setRouteOf

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/staking/FTCHook.sol

1: 
   Current order:
   UsingForDirective.FullMath
   ErrorDefinition.TLCHook_Forbidden
   ErrorDefinition.TLCHook_BadArgs
   VariableDeclaration.BPS
   VariableDeclaration.tradeService
   VariableDeclaration.tlc
   VariableDeclaration.tlcStaking
   VariableDeclaration.marketWeights
   VariableDeclaration.whitelistedCallers
   ModifierDefinition.onlyWhitelistedCaller
   EventDefinition.LogSetMarketWeight
   EventDefinition.LogSetWhitelistedCaller
   FunctionDefinition.initialize
   FunctionDefinition.onIncreasePosition
   FunctionDefinition.onDecreasePosition
   FunctionDefinition._mintTLC
   FunctionDefinition.setMarketWeight
   FunctionDefinition.setWhitelistedCallers
   FunctionDefinition.constructor
   
   Suggested order:
   UsingForDirective.FullMath
   VariableDeclaration.BPS
   VariableDeclaration.tradeService
   VariableDeclaration.tlc
   VariableDeclaration.tlcStaking
   VariableDeclaration.marketWeights
   VariableDeclaration.whitelistedCallers
   ErrorDefinition.TLCHook_Forbidden
   ErrorDefinition.TLCHook_BadArgs
   EventDefinition.LogSetMarketWeight
   EventDefinition.LogSetWhitelistedCaller
   ModifierDefinition.onlyWhitelistedCaller
   FunctionDefinition.initialize
   FunctionDefinition.onIncreasePosition
   FunctionDefinition.onDecreasePosition
   FunctionDefinition._mintTLC
   FunctionDefinition.setMarketWeight
   FunctionDefinition.setWhitelistedCallers
   FunctionDefinition.constructor

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

1: 
   Current order:
   UsingForDirective.AddressUpgradeable
   EventDefinition.LogSetServiceExecutor
   EventDefinition.LogSetCalculator
   EventDefinition.LogSetOracle
   EventDefinition.LogSetHLP
   EventDefinition.LogSetLiquidityConfig
   EventDefinition.LogSetDynamicEnabled
   EventDefinition.LogSetPnlFactor
   EventDefinition.LogSetSwapConfig
   EventDefinition.LogSetTradingConfig
   EventDefinition.LogSetLiquidationConfig
   EventDefinition.LogSetMarketConfig
   EventDefinition.LogSetHlpTokenConfig
   EventDefinition.LogSetCollateralTokenConfig
   EventDefinition.LogSetAssetConfig
   EventDefinition.LogSetToken
   EventDefinition.LogSetAssetClassConfigByIndex
   EventDefinition.LogSetLiquidityEnabled
   EventDefinition.LogSetMinimumPositionSize
   EventDefinition.LogSetConfigExecutor
   EventDefinition.LogAddAssetClassConfig
   EventDefinition.LogAddMarketConfig
   EventDefinition.LogRemoveUnderlying
   EventDefinition.LogDelistMarket
   EventDefinition.LogDeleteMarket
   EventDefinition.LogAddOrUpdateHLPTokenConfigs
   EventDefinition.LogSetTradeServiceHooks
   EventDefinition.LogSetSwitchCollateralRouter
   EventDefinition.LogMinProfitDuration
   EventDefinition.LogSetStepMinProfitDuration
   VariableDeclaration.BPS
   VariableDeclaration.MAX_FEE_BPS
   VariableDeclaration.liquidityConfig
   VariableDeclaration.swapConfig
   VariableDeclaration.tradingConfig
   VariableDeclaration.liquidationConfig
   VariableDeclaration.allowedLiquidators
   VariableDeclaration.serviceExecutors
   VariableDeclaration.calculator
   VariableDeclaration.oracle
   VariableDeclaration.hlp
   VariableDeclaration.treasury
   VariableDeclaration.pnlFactorBPS
   VariableDeclaration.minimumPositionSize
   VariableDeclaration.weth
   VariableDeclaration.sglp
   VariableDeclaration.tokenAssetIds
   VariableDeclaration.assetConfigs
   VariableDeclaration.hlpAssetIds
   VariableDeclaration.assetHlpTokenConfigs
   VariableDeclaration.collateralAssetIds
   VariableDeclaration.assetCollateralTokenConfigs
   VariableDeclaration.marketConfigs
   VariableDeclaration.assetClassConfigs
   VariableDeclaration.tradeServiceHooks
   VariableDeclaration.configExecutors
   VariableDeclaration.switchCollateralRouter
   VariableDeclaration.minProfitDurations
   VariableDeclaration.isAdaptiveFeeEnabledByMarketIndex
   VariableDeclaration.stepMinProfitDurations
   VariableDeclaration.isStepMinProfitEnabledByMarketIndex
   ModifierDefinition.onlyWhitelistedExecutor
   FunctionDefinition.initialize
   FunctionDefinition.validateServiceExecutor
   FunctionDefinition.validateAcceptedLiquidityToken
   FunctionDefinition.validateAcceptedCollateral
   FunctionDefinition.getTradingConfig
   FunctionDefinition.getMarketConfigByIndex
   FunctionDefinition.getAssetClassConfigByIndex
   FunctionDefinition.getCollateralTokenConfigs
   FunctionDefinition.getAssetTokenDecimal
   FunctionDefinition.getLiquidityConfig
   FunctionDefinition.getLiquidationConfig
   FunctionDefinition.getMarketConfigs
   FunctionDefinition.getMarketConfigsLength
   FunctionDefinition.getAssetClassConfigsLength
   FunctionDefinition.getHlpTokens
   FunctionDefinition.getAssetConfigByToken
   FunctionDefinition.getCollateralTokens
   FunctionDefinition.getAssetConfig
   FunctionDefinition.getAssetHlpTokenConfig
   FunctionDefinition.getAssetHlpTokenConfigByToken
   FunctionDefinition.getHlpAssetIds
   FunctionDefinition.getTradeServiceHooks
   FunctionDefinition.setConfigExecutor
   FunctionDefinition.setMinimumPositionSize
   FunctionDefinition.setCalculator
   FunctionDefinition.setOracle
   FunctionDefinition.setHLP
   FunctionDefinition.setLiquidityConfig
   FunctionDefinition.setLiquidityEnabled
   FunctionDefinition.setDynamicEnabled
   FunctionDefinition.setServiceExecutor
   FunctionDefinition._setServiceExecutor
   FunctionDefinition.setServiceExecutors
   FunctionDefinition.setPnlFactor
   FunctionDefinition.setSwapConfig
   FunctionDefinition.setTradingConfig
   FunctionDefinition.setLiquidationConfig
   FunctionDefinition.setMarketConfig
   FunctionDefinition.setHlpTokenConfig
   FunctionDefinition.setCollateralTokenConfig
   FunctionDefinition.setCollateralTokenConfigs
   FunctionDefinition._setCollateralTokenConfig
   FunctionDefinition.setAssetConfig
   FunctionDefinition.setAssetConfigs
   FunctionDefinition._setAssetConfig
   FunctionDefinition.setWeth
   FunctionDefinition.setSGlp
   FunctionDefinition.setSwitchCollateralRouter
   FunctionDefinition.addOrUpdateAcceptedToken
   FunctionDefinition.addAssetClassConfig
   FunctionDefinition.setAssetClassConfigByIndex
   FunctionDefinition.addMarketConfig
   FunctionDefinition.delistMarket
   FunctionDefinition.deleteLastMarket
   FunctionDefinition.removeAcceptedToken
   FunctionDefinition.setTradeServiceHooks
   FunctionDefinition.setMinProfitDurations
   FunctionDefinition.addStepMinProfitDuration
   FunctionDefinition.setStepMinProfitDuration
   FunctionDefinition.removeLastStepMinProfitDuration
   FunctionDefinition.getStepMinProfitDuration
   FunctionDefinition.getStepMinProfitDurations
   FunctionDefinition.setIsStepMinProfitEnabledByMarketIndex
   FunctionDefinition.constructor
   
   Suggested order:
   UsingForDirective.AddressUpgradeable
   VariableDeclaration.BPS
   VariableDeclaration.MAX_FEE_BPS
   VariableDeclaration.liquidityConfig
   VariableDeclaration.swapConfig
   VariableDeclaration.tradingConfig
   VariableDeclaration.liquidationConfig
   VariableDeclaration.allowedLiquidators
   VariableDeclaration.serviceExecutors
   VariableDeclaration.calculator
   VariableDeclaration.oracle
   VariableDeclaration.hlp
   VariableDeclaration.treasury
   VariableDeclaration.pnlFactorBPS
   VariableDeclaration.minimumPositionSize
   VariableDeclaration.weth
   VariableDeclaration.sglp
   VariableDeclaration.tokenAssetIds
   VariableDeclaration.assetConfigs
   VariableDeclaration.hlpAssetIds
   VariableDeclaration.assetHlpTokenConfigs
   VariableDeclaration.collateralAssetIds
   VariableDeclaration.assetCollateralTokenConfigs
   VariableDeclaration.marketConfigs
   VariableDeclaration.assetClassConfigs
   VariableDeclaration.tradeServiceHooks
   VariableDeclaration.configExecutors
   VariableDeclaration.switchCollateralRouter
   VariableDeclaration.minProfitDurations
   VariableDeclaration.isAdaptiveFeeEnabledByMarketIndex
   VariableDeclaration.stepMinProfitDurations
   VariableDeclaration.isStepMinProfitEnabledByMarketIndex
   EventDefinition.LogSetServiceExecutor
   EventDefinition.LogSetCalculator
   EventDefinition.LogSetOracle
   EventDefinition.LogSetHLP
   EventDefinition.LogSetLiquidityConfig
   EventDefinition.LogSetDynamicEnabled
   EventDefinition.LogSetPnlFactor
   EventDefinition.LogSetSwapConfig
   EventDefinition.LogSetTradingConfig
   EventDefinition.LogSetLiquidationConfig
   EventDefinition.LogSetMarketConfig
   EventDefinition.LogSetHlpTokenConfig
   EventDefinition.LogSetCollateralTokenConfig
   EventDefinition.LogSetAssetConfig
   EventDefinition.LogSetToken
   EventDefinition.LogSetAssetClassConfigByIndex
   EventDefinition.LogSetLiquidityEnabled
   EventDefinition.LogSetMinimumPositionSize
   EventDefinition.LogSetConfigExecutor
   EventDefinition.LogAddAssetClassConfig
   EventDefinition.LogAddMarketConfig
   EventDefinition.LogRemoveUnderlying
   EventDefinition.LogDelistMarket
   EventDefinition.LogDeleteMarket
   EventDefinition.LogAddOrUpdateHLPTokenConfigs
   EventDefinition.LogSetTradeServiceHooks
   EventDefinition.LogSetSwitchCollateralRouter
   EventDefinition.LogMinProfitDuration
   EventDefinition.LogSetStepMinProfitDuration
   ModifierDefinition.onlyWhitelistedExecutor
   FunctionDefinition.initialize
   FunctionDefinition.validateServiceExecutor
   FunctionDefinition.validateAcceptedLiquidityToken
   FunctionDefinition.validateAcceptedCollateral
   FunctionDefinition.getTradingConfig
   FunctionDefinition.getMarketConfigByIndex
   FunctionDefinition.getAssetClassConfigByIndex
   FunctionDefinition.getCollateralTokenConfigs
   FunctionDefinition.getAssetTokenDecimal
   FunctionDefinition.getLiquidityConfig
   FunctionDefinition.getLiquidationConfig
   FunctionDefinition.getMarketConfigs
   FunctionDefinition.getMarketConfigsLength
   FunctionDefinition.getAssetClassConfigsLength
   FunctionDefinition.getHlpTokens
   FunctionDefinition.getAssetConfigByToken
   FunctionDefinition.getCollateralTokens
   FunctionDefinition.getAssetConfig
   FunctionDefinition.getAssetHlpTokenConfig
   FunctionDefinition.getAssetHlpTokenConfigByToken
   FunctionDefinition.getHlpAssetIds
   FunctionDefinition.getTradeServiceHooks
   FunctionDefinition.setConfigExecutor
   FunctionDefinition.setMinimumPositionSize
   FunctionDefinition.setCalculator
   FunctionDefinition.setOracle
   FunctionDefinition.setHLP
   FunctionDefinition.setLiquidityConfig
   FunctionDefinition.setLiquidityEnabled
   FunctionDefinition.setDynamicEnabled
   FunctionDefinition.setServiceExecutor
   FunctionDefinition._setServiceExecutor
   FunctionDefinition.setServiceExecutors
   FunctionDefinition.setPnlFactor
   FunctionDefinition.setSwapConfig
   FunctionDefinition.setTradingConfig
   FunctionDefinition.setLiquidationConfig
   FunctionDefinition.setMarketConfig
   FunctionDefinition.setHlpTokenConfig
   FunctionDefinition.setCollateralTokenConfig
   FunctionDefinition.setCollateralTokenConfigs
   FunctionDefinition._setCollateralTokenConfig
   FunctionDefinition.setAssetConfig
   FunctionDefinition.setAssetConfigs
   FunctionDefinition._setAssetConfig
   FunctionDefinition.setWeth
   FunctionDefinition.setSGlp
   FunctionDefinition.setSwitchCollateralRouter
   FunctionDefinition.addOrUpdateAcceptedToken
   FunctionDefinition.addAssetClassConfig
   FunctionDefinition.setAssetClassConfigByIndex
   FunctionDefinition.addMarketConfig
   FunctionDefinition.delistMarket
   FunctionDefinition.deleteLastMarket
   FunctionDefinition.removeAcceptedToken
   FunctionDefinition.setTradeServiceHooks
   FunctionDefinition.setMinProfitDurations
   FunctionDefinition.addStepMinProfitDuration
   FunctionDefinition.setStepMinProfitDuration
   FunctionDefinition.removeLastStepMinProfitDuration
   FunctionDefinition.getStepMinProfitDuration
   FunctionDefinition.getStepMinProfitDurations
   FunctionDefinition.setIsStepMinProfitEnabledByMarketIndex
   FunctionDefinition.constructor

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

1: 
   Current order:
   EventDefinition.SetMinter
   VariableDeclaration._balances
   VariableDeclaration._allowances
   VariableDeclaration._totalSupply
   VariableDeclaration.totalSupplyByEpoch
   VariableDeclaration._name
   VariableDeclaration._symbol
   VariableDeclaration.epochLength
   VariableDeclaration.minter
   ModifierDefinition.onlyMinter
   FunctionDefinition.initialize
   FunctionDefinition.name
   FunctionDefinition.symbol
   FunctionDefinition.decimals
   FunctionDefinition.totalSupply
   FunctionDefinition.balanceOf
   FunctionDefinition.balanceOf
   FunctionDefinition.transfer
   FunctionDefinition.allowance
   FunctionDefinition.approve
   FunctionDefinition.transferFrom
   FunctionDefinition.increaseAllowance
   FunctionDefinition.decreaseAllowance
   FunctionDefinition._transfer
   FunctionDefinition.mint
   FunctionDefinition._burn
   FunctionDefinition._approve
   FunctionDefinition._spendAllowance
   FunctionDefinition._beforeTokenTransfer
   FunctionDefinition._afterTokenTransfer
   FunctionDefinition.getCurrentEpochTimestamp
   FunctionDefinition.setMinter
   FunctionDefinition.isMinter
   FunctionDefinition.constructor
   
   Suggested order:
   VariableDeclaration._balances
   VariableDeclaration._allowances
   VariableDeclaration._totalSupply
   VariableDeclaration.totalSupplyByEpoch
   VariableDeclaration._name
   VariableDeclaration._symbol
   VariableDeclaration.epochLength
   VariableDeclaration.minter
   EventDefinition.SetMinter
   ModifierDefinition.onlyMinter
   FunctionDefinition.initialize
   FunctionDefinition.name
   FunctionDefinition.symbol
   FunctionDefinition.decimals
   FunctionDefinition.totalSupply
   FunctionDefinition.balanceOf
   FunctionDefinition.balanceOf
   FunctionDefinition.transfer
   FunctionDefinition.allowance
   FunctionDefinition.approve
   FunctionDefinition.transferFrom
   FunctionDefinition.increaseAllowance
   FunctionDefinition.decreaseAllowance
   FunctionDefinition._transfer
   FunctionDefinition.mint
   FunctionDefinition._burn
   FunctionDefinition._approve
   FunctionDefinition._spendAllowance
   FunctionDefinition._beforeTokenTransfer
   FunctionDefinition._afterTokenTransfer
   FunctionDefinition.getCurrentEpochTimestamp
   FunctionDefinition.setMinter
   FunctionDefinition.isMinter
   FunctionDefinition.constructor

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-25"></a>[NC-25] Internal and private variables and functions names should begin with an underscore
According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (1)*:
```solidity
File: src/handlers/IntentHandler.sol

35:     mapping(bytes32 key => bool executed) executedIntents;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

### <a name="NC-26"></a>[NC-26] Event is missing `indexed` fields
Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (34)*:
```solidity
File: src/contracts/FLP.sol

17:     event SetMinter(address indexed minter, bool isMinter);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

24:     event LogSetRouteOf(

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/staking/FTCHook.sol

36:     event LogSetMarketWeight(uint256 marketIndex, uint256 oldWeight, uint256 newWeight);

37:     event LogSetWhitelistedCaller(address indexed caller, bool isWhitelisted);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

26:     event LogSetServiceExecutor(address indexed contractAddress, address executorAddress, bool isServiceExecutor);

27:     event LogSetCalculator(address indexed oldCalculator, address newCalculator);

28:     event LogSetOracle(address indexed oldOracle, address newOracle);

29:     event LogSetHLP(address indexed oldHlp, address newHlp);

30:     event LogSetLiquidityConfig(LiquidityConfig indexed oldLiquidityConfig, LiquidityConfig newLiquidityConfig);

31:     event LogSetDynamicEnabled(bool enabled);

32:     event LogSetPnlFactor(uint32 oldPnlFactorBPS, uint32 newPnlFactorBPS);

33:     event LogSetSwapConfig(SwapConfig indexed oldConfig, SwapConfig newConfig);

34:     event LogSetTradingConfig(TradingConfig indexed oldConfig, TradingConfig newConfig);

35:     event LogSetLiquidationConfig(LiquidationConfig indexed oldConfig, LiquidationConfig newConfig);

36:     event LogSetMarketConfig(uint256 marketIndex, MarketConfig oldConfig, MarketConfig newConfig);

37:     event LogSetHlpTokenConfig(address token, HLPTokenConfig oldConfig, HLPTokenConfig newConfig);

38:     event LogSetCollateralTokenConfig(

43:     event LogSetAssetConfig(bytes32 assetId, AssetConfig oldConfig, AssetConfig newConfig);

44:     event LogSetToken(address indexed oldToken, address newToken);

45:     event LogSetAssetClassConfigByIndex(uint256 index, AssetClassConfig oldConfig, AssetClassConfig newConfig);

46:     event LogSetLiquidityEnabled(bool oldValue, bool newValue);

47:     event LogSetMinimumPositionSize(uint256 oldValue, uint256 newValue);

48:     event LogSetConfigExecutor(address indexed executorAddress, bool isServiceExecutor);

49:     event LogAddAssetClassConfig(uint256 index, AssetClassConfig newConfig);

50:     event LogAddMarketConfig(uint256 index, MarketConfig newConfig);

51:     event LogRemoveUnderlying(address token);

52:     event LogDelistMarket(uint256 marketIndex);

53:     event LogDeleteMarket(uint256 marketIndex);

54:     event LogAddOrUpdateHLPTokenConfigs(address _token, HLPTokenConfig _config, HLPTokenConfig _newConfig);

55:     event LogSetTradeServiceHooks(address[] oldHooks, address[] newHooks);

56:     event LogSetSwitchCollateralRouter(address prevRouter, address newRouter);

57:     event LogMinProfitDuration(uint256 indexed marketIndex, uint256 minProfitDuration);

58:     event LogSetStepMinProfitDuration(uint256 index, StepMinProfitDuration _stepMinProfitDuration);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

11:     event SetMinter(address indexed minter, bool mintable);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-27"></a>[NC-27] Constants should be defined rather than using magic numbers

*Instances (9)*:
```solidity
File: src/handlers/IntentHandler.sol

79:             _localVars.subAccountId = uint8(inputs.accountAndSubAccountIds[_i].decodeUint(160, 8));

84:                 _vars.order.sizeDelta = inputs.cmds[_i].decodeInt(11, 54) * 1e22;

85:                 _vars.order.triggerPrice = inputs.cmds[_i].decodeUint(65, 54) * 1e22;

86:                 _vars.order.acceptablePrice = inputs.cmds[_i].decodeUint(119, 54) * 1e22;

87:                 _vars.order.triggerAboveThreshold = inputs.cmds[_i].decodeBool(173);

88:                 _vars.order.reduceOnly = inputs.cmds[_i].decodeBool(174);

89:                 _vars.order.tpToken = _localVars.tpTokens[uint256(inputs.cmds[_i].decodeUint(175, 7))];

90:                 _vars.order.createdTimestamp = inputs.cmds[_i].decodeUint(182, 32);

91:                 _vars.order.expiryTimestamp = inputs.cmds[_i].decodeUint(214, 32);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

### <a name="NC-28"></a>[NC-28] `public` functions not called by the contract should be declared `external` instead

*Instances (5)*:
```solidity
File: src/tokens/FlexTradeCredits.sol

93:     function transfer(address to, uint256 amount) public returns (bool) {

115:     function approve(address spender, uint256 amount) public returns (bool) {

137:     function transferFrom(address from, address to, uint256 amount) public returns (bool) {

156:     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

176:     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="NC-29"></a>[NC-29] Variables need not be initialized to zero
The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (12)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

80:         for (uint256 i = 0; i < _route.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/staking/FTCHook.sol

92:         for (uint256 i = 0; i < _callers.length; ) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

198:         for (uint256 _i = 0; _i < len; ) {

298:         uint256 hlpTotalTokenWeight = 0;

299:         for (uint256 i = 0; i < hlpAssetIds.length; ) {

349:         for (uint256 i = 0; i < _contractAddresses.length; ) {

403:         uint256 hlpTotalTokenWeight = 0;

404:         for (uint256 i = 0; i < hlpAssetIds.length; ) {

429:         for (uint256 i = 0; i < _assetIds.length; ) {

467:         for (uint256 i = 0; i < _assetIds.length; ) {

623:         for (uint256 _i = 0; _i < _len; ) {

641:         for (uint256 i = 0; i < _newHooks.length; ) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | `approve()`/`safeApprove()` may revert if the current approval is not zero | 2 |
| [L-2](#L-2) | Use a 2-step ownership transfer pattern | 6 |
| [L-3](#L-3) | Some tokens may revert when zero value transfers are made | 1 |
| [L-4](#L-4) | Missing checks for `address(0)` when assigning values to address state variables | 8 |
| [L-5](#L-5) | `decimals()` is not a part of the ERC-20 standard | 1 |
| [L-6](#L-6) | Deprecated approve() function | 1 |
| [L-7](#L-7) | Do not use deprecated library functions | 1 |
| [L-8](#L-8) | `safeApprove()` is deprecated | 1 |
| [L-9](#L-9) | Division by zero not prevented | 1 |
| [L-10](#L-10) | Empty Function Body - Consider commenting why | 1 |
| [L-11](#L-11) | External calls in an un-bounded `for-`loop may result in a DOS | 13 |
| [L-12](#L-12) | Initializers could be front-run | 15 |
| [L-13](#L-13) | Prevent accidentally burning tokens | 8 |
| [L-14](#L-14) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 6 |
| [L-15](#L-15) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 6 |
| [L-16](#L-16) | `symbol()` is not a part of the ERC-20 standard | 1 |
| [L-17](#L-17) | Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting | 3 |
| [L-18](#L-18) | Unsafe ERC20 operation(s) | 1 |
| [L-19](#L-19) | Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions | 29 |
| [L-20](#L-20) | Upgradeable contract not initialized | 40 |
### <a name="L-1"></a>[L-1] `approve()`/`safeApprove()` may revert if the current approval is not zero
- Some tokens (like the *very popular* USDT) do not work when changing the allowance from an existing non-zero allowance value (it will revert if the current approval is not zero to protect against front-running changes of approvals). These tokens must first be approved for zero and then the actual allowance can be approved.
- Furthermore, OZ's implementation of safeApprove would throw an error if an approve is attempted from a non-zero value (`"SafeERC20: approve from non-zero to non-zero allowance"`)

Set the allowance to zero immediately before each of the existing allowance calls

*Instances (2)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

52:             _tIn.safeApprove(address(router), type(uint256).max);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/staking/FTCHook.sol

81:         _tlc.approve(address(_tlcStaking), _mintAmount);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

### <a name="L-2"></a>[L-2] Use a 2-step ownership transfer pattern
Recommend considering implementing a two step process where the owner or admin nominates an account and the nominated account needs to call an `acceptOwnership()` function for the transfer of ownership to fully succeed. This ensures the nominated EOA account is a valid and active account. Lack of two-step procedure for critical operations leaves them error-prone. Consider adding two step procedure on the critical functions.

*Instances (6)*:
```solidity
File: src/contracts/FLP.sol

14: contract FLP is ReentrancyGuardUpgradeable, OwnableUpgradeable, ERC20Upgradeable {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

16: contract AerodromeDexter is Ownable, IDexter {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

28: contract IntentHandler is OwnableUpgradeable, ReentrancyGuardUpgradeable, EIP712Upgradeable, IIntentHandler {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

15: contract FTCHook is ITradeServiceHook, OwnableUpgradeable {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

20: contract ConfigStorage is IConfigStorage, OwnableUpgradeable {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

10: contract FlexTradeCredits is OwnableUpgradeable, ITraderLoyaltyCredit {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="L-3"></a>[L-3] Some tokens may revert when zero value transfers are made
Example: https://github.com/d-xo/weird-erc20#revert-on-zero-value-transfers.

In spite of the fact that EIP-20 [states](https://github.com/ethereum/EIPs/blob/46b9b698815abbfa628cd1097311deee77dd45c5/EIPS/eip-20.md?plain=1#L116) that zero-valued transfers must be accepted, some tokens, such as LEND will revert if this is attempted, which may cause transactions that involve other tokens (such as batch operations) to fully revert. Consider skipping the transfer if the amount is zero, which will also save gas.

*Instances (1)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

60:         ERC20(_tokenOut).safeTransfer(msg.sender, _amountOut);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

### <a name="L-4"></a>[L-4] Missing checks for `address(0)` when assigning values to address state variables

*Instances (8)*:
```solidity
File: src/staking/FTCHook.sol

42:         tradeService = _tradeService;

43:         tlc = _tlc;

44:         tlcStaking = _tlcStaking;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

266:         calculator = _calculator;

274:         oracle = _oracle;

500:         weth = _weth;

507:         sglp = _sglp;

514:         switchCollateralRouter = _newSwitchCollateralRouter;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="L-5"></a>[L-5] `decimals()` is not a part of the ERC-20 standard
The `decimals()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (1)*:
```solidity
File: src/storages/ConfigStorage.sol

490:             ERC20Upgradeable(_token).decimals();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

### <a name="L-6"></a>[L-6] Deprecated approve() function
Due to the inheritance of ERC20's approve function, there's a vulnerability to the ERC20 approve and double spend front running attack. Briefly, an authorized spender could spend both allowances by front running an allowance-changing transaction. Consider implementing OpenZeppelin's `.safeApprove()` function to help mitigate this.

*Instances (1)*:
```solidity
File: src/staking/FTCHook.sol

81:         _tlc.approve(address(_tlcStaking), _mintAmount);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

### <a name="L-7"></a>[L-7] Do not use deprecated library functions

*Instances (1)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

52:             _tIn.safeApprove(address(router), type(uint256).max);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

### <a name="L-8"></a>[L-8] `safeApprove()` is deprecated
[Deprecated](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/bfff03c0d2a59bcd8e2ead1da9aed9edf0080d05/contracts/token/ERC20/utils/SafeERC20.sol#L38-L45) in favor of `safeIncreaseAllowance()` and `safeDecreaseAllowance()`. If only setting the initial allowance to the value that means infinite, `safeIncreaseAllowance()` can be used instead. The function may currently work, but if a bug is found in this version of OpenZeppelin, and the version that you're forced to upgrade to no longer has this function, you'll encounter unnecessary delays in porting and testing replacement contracts.

*Instances (1)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

52:             _tIn.safeApprove(address(router), type(uint256).max);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

### <a name="L-9"></a>[L-9] Division by zero not prevented
The divisions below take an input parameter which does not have any zero-value checks, which may lead to the functions reverting when zero is passed.

*Instances (1)*:
```solidity
File: src/tokens/FlexTradeCredits.sol

351:         return (block.timestamp / epochLength) * epochLength;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="L-10"></a>[L-10] Empty Function Body - Consider commenting why

*Instances (1)*:
```solidity
File: src/staking/FTCHook.sol

61:     function onDecreasePosition(

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

### <a name="L-11"></a>[L-11] External calls in an un-bounded `for-`loop may result in a DOS
Consider limiting the number of iterations in for-loops that make external calls

*Instances (13)*:
```solidity
File: src/extensions/dexters/AerodromeDexter.sol

81:             routeOf[_tokenIn][_tokenOut].push(_route[i]);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

78:             _localVars.mainAccount = address(uint160(inputs.accountAndSubAccountIds[_i].decodeUint(0, 160)));

79:             _localVars.subAccountId = uint8(inputs.accountAndSubAccountIds[_i].decodeUint(160, 8));

80:             _localVars.cmd = Command(inputs.cmds[_i].decodeUint(0, 3));

83:                 _vars.order.marketIndex = inputs.cmds[_i].decodeUint(3, 8);

84:                 _vars.order.sizeDelta = inputs.cmds[_i].decodeInt(11, 54) * 1e22;

85:                 _vars.order.triggerPrice = inputs.cmds[_i].decodeUint(65, 54) * 1e22;

86:                 _vars.order.acceptablePrice = inputs.cmds[_i].decodeUint(119, 54) * 1e22;

87:                 _vars.order.triggerAboveThreshold = inputs.cmds[_i].decodeBool(173);

88:                 _vars.order.reduceOnly = inputs.cmds[_i].decodeBool(174);

89:                 _vars.order.tpToken = _localVars.tpTokens[uint256(inputs.cmds[_i].decodeUint(175, 7))];

90:                 _vars.order.createdTimestamp = inputs.cmds[_i].decodeUint(182, 32);

91:                 _vars.order.expiryTimestamp = inputs.cmds[_i].decodeUint(214, 32);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

### <a name="L-12"></a>[L-12] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (15)*:
```solidity
File: src/contracts/FLP.sol

30:     function initialize() external initializer {

31:         OwnableUpgradeable.__Ownable_init();

32:         ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

33:         ERC20Upgradeable.__ERC20_init("FLP", "FLP");

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/handlers/IntentHandler.sol

44:     function initialize(

49:     ) external initializer {

50:         OwnableUpgradeable.__Ownable_init();

51:         ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

52:         EIP712Upgradeable.__EIP712_init("IntentHander", "1.0.0");

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

39:     function initialize(address _tradeService, address _tlc, address _tlcStaking) external initializer {

40:         OwnableUpgradeable.__Ownable_init();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

121:     function initialize() external initializer {

122:         OwnableUpgradeable.__Ownable_init();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

31:     function initialize() external initializer {

32:         OwnableUpgradeable.__Ownable_init();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="L-13"></a>[L-13] Prevent accidentally burning tokens
Minting and burning tokens to address(0) prevention

*Instances (8)*:
```solidity
File: src/contracts/FLP.sol

38:         emit SetMinter(minter, isMinter);

42:         _mint(to, amount);

46:         _burn(from, amount);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/staking/FTCHook.sol

58:         _mintTLC(_primaryAccount, _sizeDelta, _marketIndex);

80:         _tlc.mint(address(this), _mintAmount);

81:         _tlc.approve(address(_tlcStaking), _mintAmount);

82:         _tlcStaking.deposit(_primaryAccount, _mintAmount);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

357:         emit SetMinter(_minter, _mintable);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="L-14"></a>[L-14] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`
The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (6)*:
```solidity
File: src/contracts/FLP.sol

5: pragma solidity 0.8.18;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

5: pragma solidity 0.8.18;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

5: pragma solidity 0.8.18;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

5: pragma solidity 0.8.18;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

5: pragma solidity 0.8.18;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

5: pragma solidity 0.8.18;

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="L-15"></a>[L-15] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`
Use [Ownable2Step.transferOwnership](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol) which is safer. Use it as it is more secure due to 2-stage ownership transfer.

**Recommended Mitigation Steps**

Use <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol">Ownable2Step.sol</a>
  
  ```solidity
      function acceptOwnership() external {
          address sender = _msgSender();
          require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
          _transferOwnership(sender);
      }
```

*Instances (6)*:
```solidity
File: src/contracts/FLP.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

8: import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

7: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="L-16"></a>[L-16] `symbol()` is not a part of the ERC-20 standard
The `symbol()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (1)*:
```solidity
File: src/staking/FTCHook.sol

48:         TraderLoyaltyCredit(tlc).symbol();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

### <a name="L-17"></a>[L-17] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting
Downcasting from `uint256`/`int256` in Solidity does not revert on overflow. This can result in undesired exploitation or bugs, since developers usually assume that overflows raise errors. [OpenZeppelin's SafeCast library](https://docs.openzeppelin.com/contracts/3.x/api/utils#SafeCast) restores this intuition by reverting the transaction when such an operation overflows. Using this library eliminates an entire class of bugs, so it's recommended to use it always. Some exceptions are acceptable like with the classic `uint256(uint160(address(variable)))`

*Instances (3)*:
```solidity
File: src/handlers/IntentHandler.sol

78:             _localVars.mainAccount = address(uint160(inputs.accountAndSubAccountIds[_i].decodeUint(0, 160)));

78:             _localVars.mainAccount = address(uint160(inputs.accountAndSubAccountIds[_i].decodeUint(0, 160)));

79:             _localVars.subAccountId = uint8(inputs.accountAndSubAccountIds[_i].decodeUint(160, 8));

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

### <a name="L-18"></a>[L-18] Unsafe ERC20 operation(s)

*Instances (1)*:
```solidity
File: src/staking/FTCHook.sol

81:         _tlc.approve(address(_tlcStaking), _mintAmount);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

### <a name="L-19"></a>[L-19] Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions
See [this](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps) link for a description of this storage variable. While some contracts may not currently be sub-classed, adding the variable now protects against forgetting to add it in the future.

*Instances (29)*:
```solidity
File: src/contracts/FLP.sol

7: import {ReentrancyGuardUpgradeable} from "@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ERC20Upgradeable} from "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";

14: contract FLP is ReentrancyGuardUpgradeable, OwnableUpgradeable, ERC20Upgradeable {

31:         OwnableUpgradeable.__Ownable_init();

32:         ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

33:         ERC20Upgradeable.__ERC20_init("FLP", "FLP");

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/handlers/IntentHandler.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ReentrancyGuardUpgradeable} from "@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

10: import {EIP712Upgradeable} from "@openzeppelin-upgradeable/contracts/utils/cryptography/EIP712Upgradeable.sol";

12: import {ECDSAUpgradeable} from "@openzeppelin-upgradeable/contracts/utils/cryptography/ECDSAUpgradeable.sol";

28: contract IntentHandler is OwnableUpgradeable, ReentrancyGuardUpgradeable, EIP712Upgradeable, IIntentHandler {

50:         OwnableUpgradeable.__Ownable_init();

51:         ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

52:         EIP712Upgradeable.__EIP712_init("IntentHander", "1.0.0");

221:         address _recoveredSigner = ECDSAUpgradeable.recover(getDigest(_tradeOrder), _signature);

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

7: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

15: contract FTCHook is ITradeServiceHook, OwnableUpgradeable {

40:         OwnableUpgradeable.__Ownable_init();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ERC20Upgradeable} from "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";

10: import {AddressUpgradeable} from "@openzeppelin-upgradeable/contracts/utils/AddressUpgradeable.sol";

20: contract ConfigStorage is IConfigStorage, OwnableUpgradeable {

21:     using AddressUpgradeable for address;

122:         OwnableUpgradeable.__Ownable_init();

490:             ERC20Upgradeable(_token).decimals();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

10: contract FlexTradeCredits is OwnableUpgradeable, ITraderLoyaltyCredit {

32:         OwnableUpgradeable.__Ownable_init();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="L-20"></a>[L-20] Upgradeable contract not initialized
Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (40)*:
```solidity
File: src/contracts/FLP.sol

7: import {ReentrancyGuardUpgradeable} from "@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ERC20Upgradeable} from "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";

14: contract FLP is ReentrancyGuardUpgradeable, OwnableUpgradeable, ERC20Upgradeable {

30:     function initialize() external initializer {

31:         OwnableUpgradeable.__Ownable_init();

32:         ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

33:         ERC20Upgradeable.__ERC20_init("FLP", "FLP");

51:         _disableInitializers();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/handlers/IntentHandler.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ReentrancyGuardUpgradeable} from "@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

10: import {EIP712Upgradeable} from "@openzeppelin-upgradeable/contracts/utils/cryptography/EIP712Upgradeable.sol";

12: import {ECDSAUpgradeable} from "@openzeppelin-upgradeable/contracts/utils/cryptography/ECDSAUpgradeable.sol";

28: contract IntentHandler is OwnableUpgradeable, ReentrancyGuardUpgradeable, EIP712Upgradeable, IIntentHandler {

44:     function initialize(

49:     ) external initializer {

50:         OwnableUpgradeable.__Ownable_init();

51:         ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

52:         EIP712Upgradeable.__EIP712_init("IntentHander", "1.0.0");

221:         address _recoveredSigner = ECDSAUpgradeable.recover(getDigest(_tradeOrder), _signature);

276:         _disableInitializers();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

7: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

15: contract FTCHook is ITradeServiceHook, OwnableUpgradeable {

39:     function initialize(address _tradeService, address _tlc, address _tlcStaking) external initializer {

40:         OwnableUpgradeable.__Ownable_init();

105:         _disableInitializers();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

9: import {ERC20Upgradeable} from "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";

10: import {AddressUpgradeable} from "@openzeppelin-upgradeable/contracts/utils/AddressUpgradeable.sol";

20: contract ConfigStorage is IConfigStorage, OwnableUpgradeable {

21:     using AddressUpgradeable for address;

121:     function initialize() external initializer {

122:         OwnableUpgradeable.__Ownable_init();

490:             ERC20Upgradeable(_token).decimals();

750:         _disableInitializers();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

8: import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

10: contract FlexTradeCredits is OwnableUpgradeable, ITraderLoyaltyCredit {

31:     function initialize() external initializer {

32:         OwnableUpgradeable.__Ownable_init();

366:         _disableInitializers();

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 44 |
| [M-2](#M-2) | `increaseAllowance/decreaseAllowance` won't work on mainnet for USDT | 2 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (44)*:
```solidity
File: src/contracts/FLP.sol

36:     function setMinter(address minter, bool isMinter) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/contracts/FLP.sol)

```solidity
File: src/extensions/dexters/AerodromeDexter.sol

16: contract AerodromeDexter is Ownable, IDexter {

72:     function setRouteOf(address _tokenIn, address _tokenOut, IRouter.Route[] calldata _route) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/extensions/dexters/AerodromeDexter.sol)

```solidity
File: src/handlers/IntentHandler.sol

255:     function setIntentExecutor(address _executor, bool _isAllow) external nonReentrant onlyOwner {

261:     function setTradeOrderHelper(address _newTradeOrderHelper) external nonReentrant onlyOwner {

266:     function setPyth(address _pyth) external nonReentrant onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/handlers/IntentHandler.sol)

```solidity
File: src/staking/FTCHook.sol

85:     function setMarketWeight(uint256 _marketIndex, uint256 _weight) external onlyOwner {

90:     function setWhitelistedCallers(address[] calldata _callers, bool[] calldata _isWhitelisteds) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/staking/FTCHook.sol)

```solidity
File: src/storages/ConfigStorage.sol

253:     function setConfigExecutor(address _executorAddress, bool _isServiceExecutor) external onlyOwner {

259:     function setMinimumPositionSize(uint256 _minimumPositionSize) external onlyOwner {

264:     function setCalculator(address _calculator) external onlyOwner {

272:     function setOracle(address _oracle) external onlyOwner {

280:     function setHLP(address _hlp) external onlyOwner {

287:     function setLiquidityConfig(LiquidityConfig calldata _liquidityConfig) external onlyOwner {

315:     function setDynamicEnabled(bool _enabled) external onlyOwner {

324:     ) external onlyOwner {

343:     ) external onlyOwner {

357:     function setPnlFactor(uint32 _pnlFactorBPS) external onlyOwner {

362:     function setSwapConfig(SwapConfig calldata _newConfig) external onlyOwner {

367:     function setTradingConfig(TradingConfig calldata _newConfig) external onlyOwner {

374:     function setLiquidationConfig(LiquidationConfig calldata _newConfig) external onlyOwner {

383:     ) external onlyOwner returns (MarketConfig memory _marketConfig) {

399:     ) external onlyOwner returns (HLPTokenConfig memory _hlpTokenConfig) {

420:     ) external onlyOwner returns (CollateralTokenConfig memory _collateralTokenConfig) {

427:     ) external onlyOwner {

461:     ) external onlyOwner returns (AssetConfig memory _assetConfig) {

465:     function setAssetConfigs(bytes32[] calldata _assetIds, AssetConfig[] calldata _newConfigs) external onlyOwner {

496:     function setWeth(address _weth) external onlyOwner {

503:     function setSGlp(address _sglp) external onlyOwner {

512:     function setSwitchCollateralRouter(address _newSwitchCollateralRouter) external onlyOwner {

525:     ) external onlyOwner {

573:     function addAssetClassConfig(AssetClassConfig calldata _newConfig) external onlyOwner returns (uint256 _index) {

580:     function setAssetClassConfigByIndex(uint256 _index, AssetClassConfig calldata _newConfig) external onlyOwner {

588:     ) external onlyOwner returns (uint256 _newMarketIndex) {

603:     function delistMarket(uint256 _marketIndex) external onlyOwner {

608:     function deleteLastMarket() external onlyOwner {

615:     function removeAcceptedToken(address _token) external onlyOwner {

640:     function setTradeServiceHooks(address[] calldata _newHooks) external onlyOwner {

656:     ) external onlyOwner {

674:     function addStepMinProfitDuration(StepMinProfitDuration[] memory _stepMinProfitDurations) external onlyOwner {

690:     ) external onlyOwner {

704:     function removeLastStepMinProfitDuration() external onlyOwner {

736:     ) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/storages/ConfigStorage.sol)

```solidity
File: src/tokens/FlexTradeCredits.sol

354:     function setMinter(address _minter, bool _mintable) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

### <a name="M-2"></a>[M-2] `increaseAllowance/decreaseAllowance` won't work on mainnet for USDT
On mainnet, the mitigation to be compatible with `increaseAllowance/decreaseAllowance` isn't applied: https://etherscan.io/token/0xdac17f958d2ee523a2206206994597c13d831ec7#code, meaning it reverts on setting a non-zero & non-max allowance, unless the allowance is already zero.

*Instances (2)*:
```solidity
File: src/tokens/FlexTradeCredits.sol

156:     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

176:     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

```
[Link to code](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/src/tokens/FlexTradeCredits.sol)

