# Ethernaut Solutions

This repository contains solutions to the [Ethernaut](https://ethernaut.openzeppelin.com/) challenges, implemented using [Foundry](https://book.getfoundry.sh/), a blazing fast, portable and modular toolkit for Ethereum application development.

## Overview

Ethernaut is a Web3/Solidity based wargame inspired by [OverTheWire](https://overthewire.org/) wargames, played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be "hacked" to pass the challenge.

This repository provides Foundry-based solutions for various Ethernaut levels, including both the vulnerable challenge contracts and the exploit scripts to solve them.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) - Install Foundry on your system
- A Sepolia testnet account with some ETH for testing (optional, for on-chain verification)

## Installation

1. Clone the repository:

```bash
git clone https://github.com/Hazem-dh/Ethernaut-solutions.git
cd Ethernaut-solutions
```

2. Install dependencies:

```bash
forge install
```

3. Set up environment variables:

```bash
cp .env.example .env
```

Edit `.env` with your private key, RPC URL, and the contract addresses for the challenges (available on the Ethernaut website).

## Solving Challenges

To solve the Ethernaut challenges on-chain:

1. Ensure your `.env` file is set up with:

   - `PRIVATE_KEY`: Your Sepolia testnet private key
   - `RPC_URL`: Sepolia RPC URL (e.g., from Infura or Alchemy)
   - Challenge contract addresses (e.g., `FALLBACK_ADDRESS`, `COINFLIP_ADDRESS`, etc.) - get these from the Ethernaut level instances

2. Run a specific challenge solution:

```bash
make solve SCRIPT=SolveFallback
```

Replace `SolveFallback` with the appropriate script name for the challenge you want to solve

The script will deploy the exploit contract (if needed) and execute the solution on the Sepolia testnet.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

These solutions are for educational purposes only. Ethernaut challenges are designed to teach about smart contract security vulnerabilities. Never deploy vulnerable contracts on mainnet or with real funds.
