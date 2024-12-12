# Flex Perpetuals audit details
- Total Prize Pool: $25,000 in USDC
  - HM awards: $20,000 in USDC
  - QA awards: $800 in USDC
  - Judge awards: $2,200 in USDC
  - Validator awards: $1,500 in USDC 
  - Scout awards: $500 in USDC
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts December 13, 2024 20:00 UTC
- Ends December 20, 2024 20:00 UTC

**Note re: risk level upgrades/downgrades**

Two important notes about judging phase risk adjustments: 
- High- or Medium-risk submissions downgraded to Low-risk (QA)) will be ineligible for awards.
- Upgrading a Low-risk finding from a QA report to a Medium- or High-risk finding is not supported.

As such, wardens are encouraged to select the appropriate risk level carefully during the submission phase.

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/4naly3er-report.md).

_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

None

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

# Overview

[ ⭐️ SPONSORS: add info here ]

## Links

- **Previous audits:**  
  - ✅ SCOUTS: If there are multiple report links, please format them in a list.
- **Documentation:** https://docs.flex.trade/
- **Website:** https://flex.trade/
- **X/Twitter:** https://x.com/Flexperpetuals
- **Telegram:** https://t.me/+lrJ0Ck6TiNlmOGM0

---

# Scope

[ ✅ SCOUTS: add scoping and technical details here ]

### Files in scope
- ✅ This should be completed using the `metrics.md` file
- ✅ Last row of the table should be Total: SLOC
- ✅ SCOUTS: Have the sponsor review and and confirm in text the details in the section titled "Scoping Q amp; A"

*For sponsors that don't use the scoping tool: list all files in scope in the table below (along with hyperlinks) -- and feel free to add notes to emphasize areas of focus.*

| Contract | SLOC | Purpose | Libraries used |  
| ----------- | ----------- | ----------- | ----------- |
| [contracts/folder/sample.sol](https://github.com/code-423n4/repo-name/blob/contracts/folder/sample.sol) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |

### Files out of scope
✅ SCOUTS: List files/directories out of scope

## Scoping Q &amp; A

### General questions
### Are there any ERC20's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

Any (all possible ERC20s)


### Are there any ERC777's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



### Are there any ERC721's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



### Are there any ERC1155's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



✅ SCOUTS: Once done populating the table below, please remove all the Q/A data above.

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       🖊️             |
| Test coverage                           | ✅ SCOUTS: Please populate this after running the test coverage command                          |
| ERC721 used  by the protocol            |            🖊️              |
| ERC777 used by the protocol             |           🖊️                |
| ERC1155 used by the protocol            |              🖊️            |
| Chains the protocol will be deployed on | Base |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      |   In scope  |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  |  In scope  |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | In scope    |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 |   In scope  |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | In scope    |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | In scope    |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | In scope    |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | In scope    |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | In scope    |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | In scope    |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | In scope    |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | In scope    |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   |  In scope   |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | In scope    |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 |   In scope  |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | In scope    |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | In scope    |

### External integrations (e.g., Uniswap) behavior in scope:


| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | Yes   |
| Pausability (e.g. Uniswap pool gets paused)               |  Yes   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   Yes  |


### EIP compliance checklist
`src/contracts/FLP.sol`: should comply with EIP-20
`src/tokens/FlexTradeCredits.sol`: should comply with EIP-20
`src/handlers/IntentHandler.sol`:  should comply with EIP-712


✅ SCOUTS: Please format the response above 👆 using the template below👇

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| src/Token.sol                           | ERC20, ERC721                |
| src/NFT.sol                             | ERC721                       |


# Additional context

## Main invariants

1. src/contracts/FLP.sol
FLP is a copy of HLP token
- mintable/burnable only by LiquidityService.sol that mint/burn it with user deposit/withdrawn to liquidity
HLP(_vars.configStorage.hlp()).mint(_receiver, _vars.mintAmount);
- transferable token

2. src/extensions/dexters/AerodromeDexter.sol
- should be administered only by owner
- must swap tokens (called by SwitchCollateralrouter.execute) or revert the transaction on swap error. As run() is public, it shouldn't be used maliciously.

3. src/handlers/IntentHandler.sol
- should be administered by owner only
- execution must be limited only by IntentExecutors
- contact signs transactions on client side and Trading orders should be signed only by client private key. Contact must validate this signature so no one can forge an electronic signature or execute transactions of another user.

4. src/staking/FTCHook.sol FTCHook is a clone of TLCHook.
- should be administered only by owner
- It should be called only by TradeService as it will be a whitelistedCallers.

5. src/storages/ConfigStorage.sol
- As it's a configuration contracts should be changed only by owner or whitelisted callers.

6. src/tokens/FlexTradeCredits.sol
FlexTradeCredits is a clone of TraderLoyaltyCredit (TLC).
- must be minted only by whitelisted minters (FTCHook).
- represents activity of a user (trader) for current epoch only. So each epoch balances
must be independent and should be resetted with new epoch (each week)


✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Attack ideas (where to focus for bugs)
None

The results of the previous code audit can be found here: https://github.com/Flex-Community/v2-evm/tree/fp-develop/audits
Only the changes made to the files within the defined scope need to be audited.

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## All trusted roles in the protocol

Major Roles Except owner:

src/handlers/IntentHandler.sol
role: intentExecutors

src/staking/FTCHook.sol
role: whitelistedCallers (external contact)

src/tokens/FlexTradeCredits.sol
role: minter (external contract)

✅ SCOUTS: Please format the response above 👆 using the template below👇

| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
| Owner                          | Has superpowers                |
| Administrator                             | Can change fees                       |

## Describe any novel or unique curve logic or mathematical models implemented in the contracts:

N/A

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Running tests

git clone https://github.com/Flex-Community/v2-evm
cd v2-evm
git checkout 89707eef78e465db1b3bc34cfea1c99c9de1042e
git submodule init
git submodule update --recursive
docker run -it -v=$(pwd):/app -w=/app node:18 /bin/bash
[docker]:# yarn
[docker]:# curl -L https://foundry.paradigm.xyz | bash
[docker]:# ~/.foundry/bin/foundryup
[docker]:# ~/.foundry/bin/forge test --no-match-path='test/{fp-fork,fork}/*'

✅ SCOUTS: Please format the response above 👆 using the template below👇

```bash
git clone https://github.com/code-423n4/2023-08-arbitrum
git submodule update --init --recursive
cd governance
foundryup
make install
make build
make sc-election-test
```
To run code coverage
```bash
make coverage
```
To run gas benchmarks
```bash
make gas
```

✅ SCOUTS: Add a screenshot of your terminal showing the gas report
✅ SCOUTS: Add a screenshot of your terminal showing the test coverage

## Miscellaneous
Employees of Flex Perpetuals and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.

# Scope

*See [scope.txt](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/scope.txt)*

### Files in scope


| File   | Logic Contracts | Interfaces | nSLOC | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| /src/contracts/FLP.sol | 1| **** | 33 | |@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol<br>@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol<br>@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol|
| /src/storages/ConfigStorage.sol | 1| **** | 511 | |@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol<br>@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol<br>@openzeppelin-upgradeable/contracts/utils/AddressUpgradeable.sol<br>@hmx/storages/interfaces/IConfigStorage.sol<br>@hmx/contracts/interfaces/ICalculator.sol<br>@hmx/oracles/interfaces/IOracleMiddleware.sol<br>@hmx/extensions/switch-collateral/interfaces/ISwitchCollateralRouter.sol|
| /src/handlers/IntentHandler.sol | 1| **** | 216 | |@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol<br>@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol<br>@openzeppelin-upgradeable/contracts/utils/cryptography/EIP712Upgradeable.sol<br>@hmx/libraries/HMXLib.sol<br>@openzeppelin-upgradeable/contracts/utils/cryptography/ECDSAUpgradeable.sol<br>@hmx/storages/VaultStorage.sol<br>@hmx/storages/ConfigStorage.sol<br>@hmx/oracles/OracleMiddleware.sol<br>@hmx/libraries/WordCodec.sol<br>@hmx/helpers/TradeOrderHelper.sol<br>@hmx/services/GasService.sol<br>@hmx/oracles/interfaces/IEcoPyth.sol<br>@hmx/handlers/interfaces/IIntentHandler.sol<br>@hmx/helpers/interfaces/ITradeOrderHelper.sol|
| /src/tokens/FlexTradeCredits.sol | 1| **** | 139 | |@hmx/tokens/interfaces/ITraderLoyaltyCredit.sol<br>@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol|
| /src/staking/FTCHook.sol | 1| **** | 64 | |@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol<br>@hmx/tokens/TraderLoyaltyCredit.sol<br>@hmx/staking/TLCStaking.sol<br>@hmx/libraries/FullMath.sol|
| /src/extensions/dexters/AerodromeDexter.sol | 1| **** | 40 | |@openzeppelin/contracts/access/Ownable.sol<br>@openzeppelin/contracts/token/ERC20/ERC20.sol<br>@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol<br>@hmx/interfaces/aerodrome/IRouter.sol<br>@hmx/extensions/dexters/interfaces/IDexter.sol|
| **Totals** | **6** | **** | **1003** | | |

### Files out of scope

*See [out_of_scope.txt](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/out_of_scope.txt)*

| File         |
| ------------ |
| ./script/foundry/Deployment.s.sol |
| ./script/foundry/config/01_SetConfig.s.sol |
| ./script/foundry/config/02_SetMarkets.s.sol |
| ./script/foundry/config/03_SetOracle.s.sol |
| ./script/foundry/config/04_SetCollateralTokens.s.sol |
| ./script/foundry/config/05_SetAssetConfig.s.sol |
| ./script/foundry/config/06_SetWhitelist.s.sol |
| ./script/foundry/config/07_SetPLP.s.sol |
| ./script/foundry/config/08_SetEcoPythUpdater.s.sol |
| ./script/foundry/config/09_SetTradingHooks.s.sol |
| ./script/foundry/config/0_MintToken.s.sol |
| ./script/foundry/config/ReloadConfig.s.sol |
| ./script/foundry/deployment/00_DeployLocalContract.s.sol |
| ./script/foundry/deployment/00_DeployProxyAdmin.s.sol |
| ./script/foundry/deployment/01_DeployEcoPyth.s.sol |
| ./script/foundry/deployment/01_DeployPythAdapter.s.sol |
| ./script/foundry/deployment/01_DeployStakedGlpOracleAdapter.s.sol |
| ./script/foundry/deployment/02_DeployOracleMiddleware.s.sol |
| ./script/foundry/deployment/03_DeployConfigStorage.s.sol |
| ./script/foundry/deployment/03_DeployPLPToken.s.sol |
| ./script/foundry/deployment/03_DeployPerpStorage.s.sol |
| ./script/foundry/deployment/03_DeployVaultStorage.s.sol |
| ./script/foundry/deployment/04_DeployCalculators.s.sol |
| ./script/foundry/deployment/05_SetConfigStorage.s.sol |
| ./script/foundry/deployment/06_DeployCrossMarginService.s.sol |
| ./script/foundry/deployment/06_DeployHelper.s.sol |
| ./script/foundry/deployment/06_DeployLiquidationService.s.sol |
| ./script/foundry/deployment/06_DeployLiquidityService.s.sol |
| ./script/foundry/deployment/06_DeployTradeService.s.sol |
| ./script/foundry/deployment/07_DeployBotHandler.s.sol |
| ./script/foundry/deployment/07_DeployCrossMarginHandler.s.sol |
| ./script/foundry/deployment/07_DeployLimitTradeHandler.s.sol |
| ./script/foundry/deployment/07_DeployLiquidityHandler.s.sol |
| ./script/foundry/deployment/08_DeployConvertedGlpStrategy.s.sol |
| ./script/foundry/deployment/08_DeployStakedGlpStrategy.s.sol |
| ./script/foundry/execute/GetEquity.s.sol |
| ./script/foundry/utils/ConfigJsonRepo.s.sol |
| ./src/contracts/AdaptiveFeeCalculator.sol |
| ./src/contracts/Calculator.sol |
| ./src/contracts/HLP.sol |
| ./src/contracts/Timelock.sol |
| ./src/contracts/interfaces/ICalculator.sol |
| ./src/contracts/interfaces/IHLP.sol |
| ./src/extensions/dexters/CurveDexter.sol |
| ./src/extensions/dexters/GlpDexter.sol |
| ./src/extensions/dexters/UniswapDexter.sol |
| ./src/extensions/dexters/interfaces/IDexter.sol |
| ./src/extensions/switch-collateral/SwitchCollateralRouter.sol |
| ./src/extensions/switch-collateral/interfaces/ISwitchCollateralRouter.sol |
| ./src/handlers/BotHandler.sol |
| ./src/handlers/CrossMarginHandler.sol |
| ./src/handlers/CrossMarginHandler02.sol |
| ./src/handlers/Ext01Handler.sol |
| ./src/handlers/LimitTradeHandler.sol |
| ./src/handlers/LiquidityHandler.sol |
| ./src/handlers/LiquidityHandler02.sol |
| ./src/handlers/RebalanceHLPHandler.sol |
| ./src/handlers/RebalanceHLPv2Handler.sol |
| ./src/handlers/interfaces/IBotHandler.sol |
| ./src/handlers/interfaces/ICrossMarginHandler.sol |
| ./src/handlers/interfaces/ICrossMarginHandler02.sol |
| ./src/handlers/interfaces/IExt01Handler.sol |
| ./src/handlers/interfaces/IIntentHandler.sol |
| ./src/handlers/interfaces/ILimitTradeHandler.sol |
| ./src/handlers/interfaces/ILiquidityHandler.sol |
| ./src/handlers/interfaces/ILiquidityHandler02.sol |
| ./src/handlers/interfaces/IRebalanceHLPHandler.sol |
| ./src/handlers/interfaces/IRebalanceHLPv2Handler.sol |
| ./src/helpers/LimitTradeHelper.sol |
| ./src/helpers/TradeHelper.sol |
| ./src/helpers/TradeOrderHelper.sol |
| ./src/helpers/interfaces/ITradeHelper.sol |
| ./src/helpers/interfaces/ITradeOrderHelper.sol |
| ./src/interfaces/IWNative.sol |
| ./src/interfaces/aerodrome/IRouter.sol |
| ./src/interfaces/aerodrome/IWETH.sol |
| ./src/interfaces/arbitrum/ArbSys.sol |
| ./src/interfaces/curve/IStableSwap.sol |
| ./src/interfaces/gmx/IGmxGlpManager.sol |
| ./src/interfaces/gmx/IGmxRewardRouterV2.sol |
| ./src/interfaces/gmx/IGmxRewardTracker.sol |
| ./src/interfaces/gmx/IGmxVault.sol |
| ./src/interfaces/gmx-v2/IGmxV2DepositCallbackReceiver.sol |
| ./src/interfaces/gmx-v2/IGmxV2DepositHandler.sol |
| ./src/interfaces/gmx-v2/IGmxV2ExchangeRouter.sol |
| ./src/interfaces/gmx-v2/IGmxV2Oracle.sol |
| ./src/interfaces/gmx-v2/IGmxV2Reader.sol |
| ./src/interfaces/gmx-v2/IGmxV2RoleStore.sol |
| ./src/interfaces/gmx-v2/IGmxV2Types.sol |
| ./src/interfaces/gmx-v2/IGmxV2WithdrawalCallbackReceiver.sol |
| ./src/interfaces/gmx-v2/IGmxV2WithdrawalHandler.sol |
| ./src/interfaces/gmx-v2/Market.sol |
| ./src/interfaces/gmx-v2/MarketPoolValueInfo.sol |
| ./src/interfaces/gmx-v2/Price.sol |
| ./src/interfaces/uniswap/IPermit2.sol |
| ./src/interfaces/uniswap/IUniversalRouter.sol |
| ./src/libraries/BalancerErrors.sol |
| ./src/libraries/BalancerV2Math.sol |
| ./src/libraries/FullMath.sol |
| ./src/libraries/HMXLib.sol |
| ./src/libraries/IntentBuilder.sol |
| ./src/libraries/PythLib.sol |
| ./src/libraries/SqrtX96Codec.sol |
| ./src/libraries/TickMath.sol |
| ./src/libraries/WordCodec.sol |
| ./src/oracles/CIXPriceAdapter.sol |
| ./src/oracles/CalcPriceLens.sol |
| ./src/oracles/EcoPyth.sol |
| ./src/oracles/EcoPyth2.sol |
| ./src/oracles/EcoPythCalldataBuilder.sol |
| ./src/oracles/EcoPythCalldataBuilder2.sol |
| ./src/oracles/EcoPythCalldataBuilder3.sol |
| ./src/oracles/LeanPyth.sol |
| ./src/oracles/MockPyth.sol |
| ./src/oracles/OnChainPriceLens.sol |
| ./src/oracles/OracleMiddleware.sol |
| ./src/oracles/OrderbookOracle.sol |
| ./src/oracles/PythAdapter.sol |
| ./src/oracles/StakedGlpOracleAdapter.sol |
| ./src/oracles/UncheckedEcoPythCalldataBuilder.sol |
| ./src/oracles/UnsafeBytesLib.sol |
| ./src/oracles/UnsafeEcoPythCalldataBuilder.sol |
| ./src/oracles/UnsafeEcoPythCalldataBuilder2.sol |
| ./src/oracles/UnsafeEcoPythCalldataBuilder3.sol |
| ./src/oracles/adapters/GlpPriceAdapter.sol |
| ./src/oracles/adapters/GmPriceAdapter.sol |
| ./src/oracles/adapters/HlpPriceAdapter.sol |
| ./src/oracles/adapters/WstEthUsdPriceAdapter.sol |
| ./src/oracles/interfaces/ICIXPriceAdapter.sol |
| ./src/oracles/interfaces/ICalcPriceAdapter.sol |
| ./src/oracles/interfaces/IEcoPyth.sol |
| ./src/oracles/interfaces/IEcoPythCalldataBuilder.sol |
| ./src/oracles/interfaces/IEcoPythCalldataBuilder2.sol |
| ./src/oracles/interfaces/IEcoPythCalldataBuilder3.sol |
| ./src/oracles/interfaces/ILeanPyth.sol |
| ./src/oracles/interfaces/IOracleAdapter.sol |
| ./src/oracles/interfaces/IOracleMiddleware.sol |
| ./src/oracles/interfaces/IPriceAdapter.sol |
| ./src/oracles/interfaces/IPyth.sol |
| ./src/oracles/interfaces/IPythAdapter.sol |
| ./src/oracles/interfaces/IReadablePyth.sol |
| ./src/oracles/interfaces/IWormHole.sol |
| ./src/oracles/interfaces/IWritablePyth.sol |
| ./src/readers/CollateralReader.sol |
| ./src/readers/LiquidationReader.sol |
| ./src/readers/OrderReader.sol |
| ./src/readers/PositionReader.sol |
| ./src/readers/interfaces/ILiquidationReader.sol |
| ./src/readers/interfaces/IOrderReader.sol |
| ./src/readers/interfaces/IPositionReader.sol |
| ./src/services/CrossMarginService.sol |
| ./src/services/GasService.sol |
| ./src/services/LiquidationService.sol |
| ./src/services/LiquidityService.sol |
| ./src/services/RebalanceHLPService.sol |
| ./src/services/RebalanceHLPv2Service.sol |
| ./src/services/TradeService.sol |
| ./src/services/interfaces/ICrossMarginService.sol |
| ./src/services/interfaces/IGasService.sol |
| ./src/services/interfaces/ILiquidationService.sol |
| ./src/services/interfaces/ILiquidityService.sol |
| ./src/services/interfaces/IRebalanceHLPService.sol |
| ./src/services/interfaces/IRebalanceHLPv2Service.sol |
| ./src/services/interfaces/ITLCHook.sol |
| ./src/services/interfaces/ITradeService.sol |
| ./src/services/interfaces/ITradeServiceHook.sol |
| ./src/staking/EpochFeedableRewarder.sol |
| ./src/staking/FeedableRewarder.sol |
| ./src/staking/TLCHook.sol |
| ./src/staking/TLCStaking.sol |
| ./src/staking/TradingStaking.sol |
| ./src/staking/TradingStakingHook.sol |
| ./src/staking/interfaces/IEpochRewarder.sol |
| ./src/staking/interfaces/IHLPStaking.sol |
| ./src/staking/interfaces/IRewarder.sol |
| ./src/staking/interfaces/ISurgeStaking.sol |
| ./src/staking/interfaces/ITLCStaking.sol |
| ./src/staking/interfaces/ITradingStaking.sol |
| ./src/storages/PerpStorage.sol |
| ./src/storages/VaultStorage.sol |
| ./src/storages/interfaces/IConfigStorage.sol |
| ./src/storages/interfaces/IPerpStorage.sol |
| ./src/storages/interfaces/IVaultStorage.sol |
| ./src/strategies/ConvertedGlpStrategy.sol |
| ./src/strategies/DistributeSTIPARBStrategy.sol |
| ./src/strategies/ERC20ApproveStrategy.sol |
| ./src/strategies/StakedGlpStrategy.sol |
| ./src/strategies/interfaces/IConvertedGlpStrategy.sol |
| ./src/strategies/interfaces/IDistributeSTIPARBStrategy.sol |
| ./src/strategies/interfaces/IERC20ApproveStrategy.sol |
| ./src/strategies/interfaces/IStakedGlpStrategy.sol |
| ./src/tokens/BulkSendErc20.sol |
| ./src/tokens/MockErc20.sol |
| ./src/tokens/MockWNative.sol |
| ./src/tokens/TraderLoyaltyCredit.sol |
| ./src/tokens/interfaces/ITraderLoyaltyCredit.sol |
| ./test/adaptive-fee/AdaptiveFeeCalculator_Test.t.sol |
| ./test/base/BaseTest.sol |
| ./test/base/Chains.sol |
| ./test/base/Cheats.sol |
| ./test/calculator/Calculator_Base.t.sol |
| ./test/calculator/Calculator_BaseWithStorage.t.sol |
| ./test/calculator/Calculator_CollateralValue.t.sol |
| ./test/calculator/Calculator_Equity.t.sol |
| ./test/calculator/Calculator_FundingRate_noInterval.t.sol |
| ./test/calculator/Calculator_GetDelta.sol |
| ./test/calculator/Calculator_GetGlobalPNLE30.t.sol |
| ./test/calculator/Calculator_GetSettlementFeeRate.t.sol |
| ./test/calculator/Calculator_IMR.t.sol |
| ./test/calculator/Calculator_Initialization.t.sol |
| ./test/calculator/Calculator_MMR.t.sol |
| ./test/calculator/Calculator_UnrealizedPnl.t.sol |
| ./test/fork/aum/GetAumWithFundingFeeDebt.t.fork.sol |
| ./test/fork/bases/ForkEnv.sol |
| ./test/fork/bases/ForkEnvWithActions.sol |
| ./test/fork/bulk-send-erc20/BulkSendErc20_Leggo.t.fork.sol |
| ./test/fork/eco-pyth-calldata-builder-3/EcoPythCalldataBuilder3.t.fork.sol |
| ./test/fork/on-chain-price-lens/OnChainPriceLens.t.fork.sol |
| ./test/fork/rebalance-gmx-v2/RebalanceHLPv2_Base.t.fork.sol |
| ./test/fork/rebalance-gmx-v2/RebalanceHLPv2_Deposit.t.fork.sol |
| ./test/fork/rebalance-gmx-v2/RebalanceHLPv2_Scenario.t.fork.sol |
| ./test/fork/rebalance-gmx-v2/RebalanceHLPv2_Withdrawal.t.fork.sol |
| ./test/fork/rebalance-hlp/RebalanceHLPService.t.sol |
| ./test/fork/rebalance-hlp/RebalanceHLPService_OneInchSwap.t.fork.sol |
| ./test/fork/smoke-test/Smoke_Base.t.sol |
| ./test/fork/smoke-test/Smoke_Collateral.t.sol |
| ./test/fork/smoke-test/Smoke_Deleverage.sol |
| ./test/fork/smoke-test/Smoke_DistributeARBRewardsFromSTIP.t.sol |
| ./test/fork/smoke-test/Smoke_Liquidate.sol |
| ./test/fork/smoke-test/Smoke_Liquidity.t.sol |
| ./test/fork/smoke-test/Smoke_MaxProfit.t.sol |
| ./test/fork/smoke-test/Smoke_Trade.t.sol |
| ./test/fork/smoke-test/Smoke_TriggerOrder.t.sol |
| ./test/fork/switch-collateral-router/SwitchCollateralRouter.t.fork.sol |
| ./test/fp-fork/bases/ConfigEnv.sol |
| ./test/fp-fork/bases/DynamicForkBaseTest.sol |
| ./test/fp-fork/configs/ConfigStorage_Config.fork.t.sol |
| ./test/handlers/bot/BotHandler_Base.t.sol |
| ./test/handlers/bot/BotHandler_CloseDelistedMarketPosition.t.sol |
| ./test/handlers/bot/BotHandler_Deleverage.t.sol |
| ./test/handlers/bot/BotHandler_ForceTakeMaxProfit.t.sol |
| ./test/handlers/bot/BotHandler_Liquidate.t.sol |
| ./test/handlers/bot/BotHandler_SetPositionManagers.t.sol |
| ./test/handlers/bot/BotHandler_SetTradeService.t.sol |
| ./test/handlers/crossMargin/CrossMarginHandler_Base.t.sol |
| ./test/handlers/crossMargin/CrossMarginHandler_DepositCollateral.t.sol |
| ./test/handlers/crossMargin/CrossMarginHandler_Getter.t.sol |
| ./test/handlers/crossMargin/CrossMarginHandler_Initialization.t.sol |
| ./test/handlers/crossMargin/CrossMarginHandler_WithdrawCollateral.t.sol |
| ./test/handlers/crossMargin02/CrossMarginHandler_Base02.t.sol |
| ./test/handlers/crossMargin02/CrossMarginHandler_DepositCollateral02.t.sol |
| ./test/handlers/crossMargin02/CrossMarginHandler_Getter02.t.sol |
| ./test/handlers/crossMargin02/CrossMarginHandler_Initialization.t.sol |
| ./test/handlers/crossMargin02/CrossMarginHandler_WithdrawCollateral.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_Base.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_Batch.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_CancelOrder.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_CreateOrder.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_Delegation.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_ExecuteOrder.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_Getter.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_Setter.t.sol |
| ./test/handlers/limit-trade/LimitTradeHandler_UpdateOrder.t.sol |
| ./test/handlers/liquidity/LiquidityHandler_Base.t.sol |
| ./test/handlers/liquidity/LiquidityHandler_CreateAddLiquidityOrder.t.sol |
| ./test/handlers/liquidity/LiquidityHandler_CreateRemoveLiquidityOrder.t.sol |
| ./test/handlers/liquidity/LiquidityHandler_ExecuteOrder.t.sol |
| ./test/handlers/liquidity/LiquidityHandler_Getter.t.sol |
| ./test/handlers/liquidity02/LiquidityHandler_Base02.t.sol |
| ./test/handlers/liquidity02/LiquidityHandler_CreateAddLiquidityOrder.t.sol |
| ./test/handlers/liquidity02/LiquidityHandler_CreateRemoveLiquidityOrder.t.sol |
| ./test/handlers/liquidity02/LiquidityHandler_ExecuteOrder.t.sol |
| ./test/handlers/liquidity02/LiquidityHandler_Getter.t.sol |
| ./test/integration/01_BaseIntTest.i.sol |
| ./test/integration/02_BaseIntTest_SetConfig.i.sol |
| ./test/integration/03_BaseIntTest_SetMarkets.i.sol |
| ./test/integration/04_BaseIntTest_SetOracle.i.sol |
| ./test/integration/05_BaseIntTest_SetCollateralTokens.i.sol |
| ./test/integration/06_BaseIntTest_SetAssetConfigs.i.sol |
| ./test/integration/07_BaseIntTest_SetHLPTokens.i.sol |
| ./test/integration/08_BaseIntTest_SetWhitelist.i.sol |
| ./test/integration/98_BaseIntTest_Assertions.i.sol |
| ./test/integration/99_BaseIntTest_WithActions.i.sol |
| ./test/integration/testcases/TC01.i.sol |
| ./test/integration/testcases/TC02.i.sol |
| ./test/integration/testcases/TC02_01.i.sol |
| ./test/integration/testcases/TC02_02.i.sol |
| ./test/integration/testcases/TC02_03.i.sol |
| ./test/integration/testcases/TC03.i.sol |
| ./test/integration/testcases/TC04/TC04.i.sol |
| ./test/integration/testcases/TC04_1/TC04_1.i.sol |
| ./test/integration/testcases/TC04_2/TC04_2.i.sol |
| ./test/integration/testcases/TC05.i.sol |
| ./test/integration/testcases/TC06.i.sol |
| ./test/integration/testcases/TC07.i.sol |
| ./test/integration/testcases/TC08.i.sol |
| ./test/integration/testcases/TC09.i.sol |
| ./test/integration/testcases/TC10.i.sol |
| ./test/integration/testcases/TC11/TC11.i.sol |
| ./test/integration/testcases/TC12/TC12.i.sol |
| ./test/integration/testcases/TC14.sol |
| ./test/integration/testcases/TC17.i.sol |
| ./test/integration/testcases/TC18/TC18.i.sol |
| ./test/integration/testcases/TC20/TC20.i.sol |
| ./test/integration/testcases/TC22/TC22.i.sol |
| ./test/integration/testcases/TC24.i.sol |
| ./test/integration/testcases/TC25.i.sol |
| ./test/integration/testcases/TC27.i.sol |
| ./test/integration/testcases/TC29.i.sol |
| ./test/integration/testcases/TC30.i.sol |
| ./test/integration/testcases/TC34.i.sol |
| ./test/integration/testcases/TC36.i.sol |
| ./test/integration/testcases/TC37.i.sol |
| ./test/integration/testcases/TC38.i.sol |
| ./test/integration/testcases/TC39.i.sol |
| ./test/integration/testcases/TC40.i.sol |
| ./test/integration/testcases/TC41.i.sol |
| ./test/integration/testcases/TC42.i.sol |
| ./test/integration/testcases/TC43.i.sol |
| ./test/integration/testcases/TC44.i.sol |
| ./test/integration/testcases/botHandler/BotHandler_CheckForceTakeMaxProfit.t.sol |
| ./test/integration/testcases/botHandler/BotHandler_CheckLiquidation.i.sol |
| ./test/integration/testcases/calculator/Calculator_LiquidateAndCheckGlobalPnl.i.sol |
| ./test/invariance/trading-staking/TradingStaking.invariants.t.sol |
| ./test/libs/AddressSet.sol |
| ./test/libs/Deployer.sol |
| ./test/libs/IntentBuilder.sol |
| ./test/libs/String.sol |
| ./test/libs/Uint2str.sol |
| ./test/mocks/MockAccountAbstraction.sol |
| ./test/mocks/MockArbSys.sol |
| ./test/mocks/MockCalculator.sol |
| ./test/mocks/MockCalculatorWithRealCalculator.sol |
| ./test/mocks/MockCrossMarginService.sol |
| ./test/mocks/MockEcoPyth.sol |
| ./test/mocks/MockEntryPoint.sol |
| ./test/mocks/MockErc20.sol |
| ./test/mocks/MockGlpManager.sol |
| ./test/mocks/MockGmxRewardRouterV2.sol |
| ./test/mocks/MockGmxV2Oracle.sol |
| ./test/mocks/MockHLPStaking.sol |
| ./test/mocks/MockLiquidationService.sol |
| ./test/mocks/MockLiquidityService.sol |
| ./test/mocks/MockNonEOA.sol |
| ./test/mocks/MockOracleMiddleware.sol |
| ./test/mocks/MockPerpStorage.sol |
| ./test/mocks/MockTradeService.sol |
| ./test/mocks/MockVaultStorage.sol |
| ./test/mocks/MockWNative.sol |
| ./test/oracles/CIXPriceAdapter/CIXPriceAdapter_BaseTest.t.sol |
| ./test/oracles/CIXPriceAdapter/CIXPriceAdapter_GetPriceTest.t.sol |
| ./test/oracles/CIXPriceAdapter/CIXPriceAdapter_SetterTest.t.sol |
| ./test/oracles/EcoPythCalldataBuilder/EcoPythCalldataBuilder_BaseTest.t.sol |
| ./test/oracles/EcoPythCalldataBuilder/EcoPythCalldataBuilder_Build.t.sol |
| ./test/oracles/OracleMiddleware/EcoPyth_BaseTest.t.sol |
| ./test/oracles/OracleMiddleware/EcoPyth_GasUsedTest.t.sol |
| ./test/oracles/OracleMiddleware/EcoPyth_UpdatePriceFeedsTest.t.sol |
| ./test/oracles/OracleMiddleware/OracleMiddleware_BaseTest.t.sol |
| ./test/oracles/OracleMiddleware/OracleMiddleware_GetAdaptivePriceTest.t.sol |
| ./test/oracles/OracleMiddleware/OracleMiddleware_GetPriceTest.t.sol |
| ./test/oracles/OracleMiddleware/OracleMiddleware_SetterTest.t.sol |
| ./test/oracles/OracleMiddleware/OracleMiddleware_UnsafeGetPriceTest.t.sol |
| ./test/oracles/OrderbookDepthOracle/OrderbookOracle.t.sol |
| ./test/oracles/PythAdapter/PythAdapter_BaseTest.t.sol |
| ./test/oracles/PythAdapter/PythAdapter_GetPriceTest.t.sol |
| ./test/oracles/PythAdapter/PythAdapter_SetterTest.t.sol |
| ./test/oracles/StakedGlpOracleAdapter/StakedGlpOracleAdapter_BaseTest.t.sol |
| ./test/oracles/StakedGlpOracleAdapter/StakedGlpOracleAdapter_GetLatestPrice.t.sol |
| ./test/proxy/TransparentUpgradeableProxy.sol |
| ./test/services/crossMargin/CrossMarginService_Base.t.sol |
| ./test/services/crossMargin/CrossMarginService_DepositCollateral.t.sol |
| ./test/services/crossMargin/CrossMarginService_Initialization.t.sol |
| ./test/services/crossMargin/CrossMarginService_WithdrawCollateral.t.sol |
| ./test/services/liquidation/LiquidationService_Base.t.sol |
| ./test/services/liquidation/LiquidationService_Liquidation.t.sol |
| ./test/services/liquidity/LiquidityService_AddLiquidity.t.sol |
| ./test/services/liquidity/LiquidityService_Base.t.sol |
| ./test/services/liquidity/LiquidityService_RemoveLiquidity.t.sol |
| ./test/services/trade/TradeService_Base.t.sol |
| ./test/services/trade/TradeService_BorrowingFee.t.sol |
| ./test/services/trade/TradeService_DecreasePosition.t.sol |
| ./test/services/trade/TradeService_ForceClosePosition.t.sol |
| ./test/services/trade/TradeService_FundingFee.t.sol |
| ./test/services/trade/TradeService_Hooks.t.sol |
| ./test/services/trade/TradeService_IncreasePosition.t.sol |
| ./test/services/trade/TradeService_TradingFee.t.sol |
| ./test/services/trade/TradeService_Validate_ForceClosePosition.t.sol |
| ./test/staking/TradingStaking_Base.t.sol |
| ./test/staking/TradingStaking_Deposit.t.sol |
| ./test/staking/TradingStaking_Harvest.t.sol |
| ./test/staking/TradingStaking_RemoveRewarder.t.sol |
| ./test/staking/TradingStaking_Withdraw.t.sol |
| ./test/storages/PerpStorage/PerpStorage_Base.t.sol |
| ./test/storages/PerpStorage/PerpStorage_GetActivePositions.t.sol |
| ./test/testers/CrossMarginTester.sol |
| ./test/testers/LimitOrderTester.sol |
| ./test/testers/LiquidityTester.sol |
| ./test/testers/MarketTester.sol |
| ./test/testers/PositionTester.sol |
| ./test/testers/PositionTester02.sol |
| ./test/testers/TradeTester.sol |
| Totals: 401 |

