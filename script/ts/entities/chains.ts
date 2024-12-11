import dotenv from "dotenv";
import { ethers } from "ethers";

dotenv.config();

export type ChainEntity = {
  id: number;
  name: string;
  rpc: string;
  jsonRpcProvider: ethers.providers.JsonRpcProvider;
  safeTxServiceUrl: string;
  statSubgraphUrl: string;
};

// if (!process.env.ARBITRUM_MAINNET_RPC) throw new Error("Missing ARBITRUM_MAINNET_RPC env var");
// if (!process.env.ARBI_STAT_SUBGRAPH_URL) throw new Error("Missing ARBI_STAT_SUBGRAPH_URL env var");

export const BASE_SEPOLIA_CHAIN_ID = 84532;

const CHAIN_BY_ID  = {
  8453: {
    id: 8453,
    name: "base",
    rpc: process.env.BASE_MAINNET_RPC,
    jsonRpcProvider: new ethers.providers.JsonRpcProvider(process.env.BASE_MAINNET_RPC),
    safeTxServiceUrl: "https://safe-transaction-base.safe.global/",
    statSubgraphUrl: process.env.ARBI_STAT_SUBGRAPH_URL,
  },
  84532: {
    id: 84532,
    name: "base_sepolia",
    rpc: process.env.BASE_SEPOLIA_RPC,
    jsonRpcProvider: new ethers.providers.JsonRpcProvider(process.env.BASE_SEPOLIA_RPC),
    safeTxServiceUrl: "https://safe-transaction-base-sepolia.safe.global/",
    statSubgraphUrl: "",
  },
  184532: {
    id: 184532,
    name: "tenderly_base_sepolia",
    rpc: process.env.TENDERLY_RPC,
    jsonRpcProvider: new ethers.providers.JsonRpcProvider(process.env.TENDERLY_BASE_SEPOLIA_RPC),
    safeTxServiceUrl: "",
    statSubgraphUrl: "",
  },
} as { [chainId: number]: ChainEntity };

export default CHAIN_BY_ID;

export function findChainByName(name: string): ChainEntity {
  const chain = Object.values(CHAIN_BY_ID).find((chain) => chain.name === name);
  if (!chain) throw new Error(`Chain not found for chain: ${name}`);
  return chain;
}