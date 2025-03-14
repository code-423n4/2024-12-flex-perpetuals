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
- High- or Medium-risk submissions downgraded to Low-risk (QA) will be ineligible for awards.
- Upgrading a Low-risk finding from a QA report to a Medium- or High-risk finding is not supported.

As such, wardens are encouraged to select the appropriate risk level carefully during the submission phase.

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/4naly3er-report.md).

_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

# Overview

Flex Perpetuals is HMXv2 fork. HMXv2 is an innovative pool-based perpetual DEX protocol designed to offer a range of advanced features. It introduces multi-asset collateral support and cross-margin flexibility, providing traders with enhanced options and opportunities.

The protocol incorporates secured measurements, including virtual price impact and funding fees, to ensure the protection of liquidity providers (LPs) from being overly exposed to a single direction. By implementing these measures, HMXv2 aims to create a more resilient and balanced trading environment.

Since the code was forked and some contracts were copied, there are aliases for contract names that you can match in the code. These contracts share the same interfaces, so only the contract names have changed, but entities, variables and interfaces in the old contract code remain:

New: `FLP.sol` — Old: HLP, IHLP\
New: `FlexTradeCredits.sol` — Old: TraderLoyaltyCredit, ITraderLoyaltyCredit, TLC\
New: `FTCHook.sol` — Old: ITLCHook, TLCHook.sol

## Architecture
`v2-evm` uses handler-service-storage pattern, this pattern ensures a clear separation of concerns and promotes modularity.

Handlers serve as entry points to the protocol, allowing for interaction with EOA or contracts. They facilitate the flow of data and call between internal protocol and outside world.

Services form the core business logic of the protocol. They handle the processing and execution of various operations, such as trading, liquidating, adding or removing liquidity.

Storages are responsible for storing critical states and data of the protocol.

## Links

- **Previous audits:** The results of the previous code audit can be found under [`./audits`](https://github.com/code-423n4/2024-12-flex-perpetuals/tree/main/audits).
Only the changes made to the files within the defined scope need to be audited.
- **Documentation:** https://docs.flex.trade/
- **Website:** https://flex.trade/
- **X/Twitter:** https://x.com/Flexperpetuals
- **Telegram:** https://t.me/+lrJ0Ck6TiNlmOGM0

---

# Scope

*See [scope.txt](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/scope.txt)*

### Files in scope

| File   | Logic Contracts | Interfaces | nSLOC | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| /src/contracts/FLP.sol | 1| **** | 33 | |@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol, @openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol, @openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol|
| /src/storages/ConfigStorage.sol | 1| **** | 511 | |@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol, @openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol, @openzeppelin-upgradeable/contracts/utils/AddressUpgradeable.sol, @hmx/storages/interfaces/IConfigStorage.sol, @hmx/contracts/interfaces/ICalculator.sol, @hmx/oracles/interfaces/IOracleMiddleware.sol, @hmx/extensions/switch-collateral/interfaces/ISwitchCollateralRouter.sol|
| /src/handlers/IntentHandler.sol | 1| **** | 216 | |@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol, @openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol, @openzeppelin-upgradeable/contracts/utils/cryptography/EIP712Upgradeable.sol, @hmx/libraries/HMXLib.sol, @openzeppelin-upgradeable/contracts/utils/cryptography/ECDSAUpgradeable.sol, @hmx/storages/VaultStorage.sol, @hmx/storages/ConfigStorage.sol, @hmx/oracles/OracleMiddleware.sol, @hmx/libraries/WordCodec.sol, @hmx/helpers/TradeOrderHelper.sol, @hmx/services/GasService.sol, @hmx/oracles/interfaces/IEcoPyth.sol, @hmx/handlers/interfaces/IIntentHandler.sol, @hmx/helpers/interfaces/ITradeOrderHelper.sol|
| /src/tokens/FlexTradeCredits.sol | 1| **** | 139 | |@hmx/tokens/interfaces/ITraderLoyaltyCredit.sol, @openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol|
| /src/staking/FTCHook.sol | 1| **** | 64 | |@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol, @hmx/tokens/TraderLoyaltyCredit.sol, @hmx/staking/TLCStaking.sol, @hmx/libraries/FullMath.sol|
| /src/extensions/dexters/AerodromeDexter.sol | 1| **** | 40 | |@openzeppelin/contracts/access/Ownable.sol, @openzeppelin/contracts/token/ERC20/ERC20.sol, @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol, @hmx/interfaces/aerodrome/IRouter.sol, @hmx/extensions/dexters/interfaces/IDexter.sol|
| **Totals** | **6** | **** | **1003** | | |

### Files out of scope

*See [out_of_scope.txt](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/out_of_scope.txt)*

| File         |
| ------------ |
| ./script/* | 
| ./src/contracts/AdaptiveFeeCalculator.sol |
| ./src/contracts/Calculator.sol |
| ./src/contracts/HLP.sol |
| ./src/contracts/Timelock.sol |
| ./src/contracts/interfaces/* | 
| ./src/extensions/dexters/CurveDexter.sol |
| ./src/extensions/dexters/GlpDexter.sol |
| ./src/extensions/dexters/UniswapDexter.sol |
| ./src/extensions/dexters/interfaces/* |
| ./src/extensions/switch-collateral/* |
| ./src/handlers/BotHandler.sol |
| ./src/handlers/CrossMarginHandler.sol |
| ./src/handlers/CrossMarginHandler02.sol |
| ./src/handlers/Ext01Handler.sol |
| ./src/handlers/LimitTradeHandler.sol |
| ./src/handlers/LiquidityHandler.sol |
| ./src/handlers/LiquidityHandler02.sol |
| ./src/handlers/RebalanceHLPHandler.sol |
| ./src/handlers/RebalanceHLPv2Handler.sol |
| ./src/handlers/interfaces/* |
| ./src/helpers/* |
| ./src/interfaces/* |
| ./src/libraries/* | 
| ./src/oracles/* | 
| ./src/readers/* |
| ./src/services/* |
| ./src/staking/EpochFeedableRewarder.sol |
| ./src/staking/FeedableRewarder.sol |
| ./src/staking/TLCHook.sol |
| ./src/staking/TLCStaking.sol |
| ./src/staking/TradingStaking.sol |
| ./src/staking/TradingStakingHook.sol |
| ./src/staking/interfaces/* |
| ./src/storages/PerpStorage.sol |
| ./src/storages/VaultStorage.sol |
| ./src/storages/interfaces/* |
| ./src/strategies/* |
| ./src/tokens/BulkSendErc20.sol |
| ./src/tokens/MockErc20.sol |
| ./src/tokens/MockWNative.sol |
| ./src/tokens/TraderLoyaltyCredit.sol |
| ./src/tokens/interfaces/* |
| ./test/* |
| Totals: 401 |

## Scoping Q &amp; A

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       Any (all possible ERC20s)             |
| Test coverage                           | n/a   |
| ERC721 used  by the protocol            |            None              |
| ERC777 used by the protocol             |           None                |
| ERC1155 used by the protocol            |              None            |
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

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| `src/contracts/FLP.sol`                 | ERC-20            |
| `src/tokens/FlexTradeCredits.sol`       | ERC-20                    |
| `src/handlers/IntentHandler.sol`        | EIP-712  | 


# Additional context

## Main invariants

1. `src/contracts/FLP.sol`\
  FLP is a copy of HLP token
    - mintable/burnable only by LiquidityService.sol that mint/burn it with user deposit/withdrawn to liquidity\
      `HLP(_vars.configStorage.hlp()).mint(_receiver, _vars.mintAmount);`
    - transferable token

2. `src/extensions/dexters/AerodromeDexter.sol`
    - should be administered only by owner
    - must swap tokens (called by SwitchCollateralrouter.execute) or revert the transaction on swap error. As run() is public, it shouldn't be used maliciously.

3. `src/handlers/IntentHandler.sol`
    - should be administered by owner only
    - execution must be limited only by IntentExecutors
    - contact signs transactions on client side and Trading orders should be signed only by client private key. Contact must validate this signature so no one can forge an electronic signature or execute transactions of another user.

4. `src/staking/FTCHook.sol`\
  FTCHook is a clone of TLCHook.
    - should be administered only by owner
    - It should be called only by TradeService as it will be a whitelistedCallers.

6. `src/storages/ConfigStorage.sol`
    - As it's a configuration, contracts should be changed only by owner or whitelisted callers.

7. `src/tokens/FlexTradeCredits.sol`\
  FlexTradeCredits is a clone of TraderLoyaltyCredit (TLC).
    - must be minted only by whitelisted minters (FTCHook).
    - represents activity of a user (trader) for current epoch only. So each epoch balances must be independent and should be resetted with new epoch (each week)


## Attack ideas (where to focus for bugs)
None

## All trusted roles in the protocol

| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
| Owner                           | Has administrative authority                |
| `intentExecutors` in `IntentHandler.sol`  |  intentExecutors - can only execute validated user's orders                       |
| `whitelistedCallers` in `IntentHandler.sol`  |  whitelistedCallers - only call Increate/Decrease Position hooks             |
| `orderExecutors` in `LiquidityHandler.sol` | orderExecutors - can only execute orders |
| `minter` in `FlexTradeCredits.sol`  | minter can only generate FlexTradeCredits tokens                       |

## Describe any novel or unique curve logic or mathematical models implemented in the contracts:

N/A

## Running tests

```bash
git clone --recursive https://github.com/code-423n4/2024-12-flex-perpetuals
cd 2024-12-flex-perpetuals
docker run -it -v=$(pwd):/app -w=/app node:18 /bin/bash
[docker]:# yarn
[docker]:# curl -L https://foundry.paradigm.xyz | bash
[docker]:# ~/.foundry/bin/foundryup
[docker]:# ~/.foundry/bin/forge test --match-path='test/{base,handlers/liquidity,integration,invariance,services/liquidity,services/trade}/*'
```
To run code coverage (warning: long-running)
```bash
[docker]:# ~/.foundry/bin/forge coverage --ir-minimum --match-path='test/{base,handlers/liquidity,integration,invariance,services/liquidity,services/trade}/*'
```
To run gas benchmarks (warning: long-running)
```bash
[docker]:# ~/.foundry/bin/forge test --gas-report --match-path='test/{base,handlers/liquidity,integration,invariance,services/liquidity,services/trade}/*'
```

![img](https://github.com/code-423n4/2024-12-flex-perpetuals/blob/main/coverage.png?raw=true)

## Miscellaneous
Employees of Flex Perpetuals and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.
