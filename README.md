# Deploying an ERC20 Token on SCROLL

This repository contains a guide and the example of a smart contract for deploying an ERC20 token on SCROLL.

## Prerequisites

- [Remix Ethereum](https://remix.ethereum.org/)
- [MetaMask](https://metamask.io/)
- [SushiSwap](https://www.sushi.com/pool)
- [ScrollScan](https://scrollscan.com/)


### Step 1: Open Remix Ethereum

1. Open [Remix Ethereum](https://remix.ethereum.org/).

### Step 2: Create and Compile the Smart Contract

1. Create a new `.sol` file.
2. Copy and paste the smart contract code into the new file.
3. Go to the "Solidity Compiler" tab.
4. Click on "Advanced Configurations" and enable "Enable Optimization".
5. Click "Compile".

### Step 3: Deploy the Smart Contract

1. Go to the "Deploy & Run Transactions" tab.
2. In the "Environment" dropdown, select "Injected Provider - MetaMask".
3. Ensure your MetaMask wallet address appears in the "Account" field.
4. In the "Contract" dropdown, select the contract you created (e.g., `YOURSYMBOL - fileyoucreated.sol`).
5. Click "Deploy" and confirm the transaction in your wallet.

### Step 4: Contract verification

1. Go to [ScrollScan](https://scrollscan.com/).
2. Paste the contract adress in the research bar. 
3. Once you are on the contract page, click on "Contract" which is next to "Token Transfer (ERC-20)" and "Events". 
4. Click on "Verify and Publish".
5. In the Compiler Type section, select "Solidity (Single file)".
6. In the Compiler Version section, enter the version indicated on remix ethereum.
7. In the Open Source License Type section enter "No License (None)".
8. Click on continue.
9. Paste your contract in the "Enter the Solidity Contract Code below *" Section. 
10. Enter "yes" in the "Optimization" Section.
11. Then finally, Verify and Publish. 


### Step 5: Add Liquidity on SushiSwap

1. Go to [SushiSwap Pool](https://www.sushi.com/pool).
2. Click on the arrow next to "I want to create a position", then select "V2 Position".
3. Choose SCROLL network.
4. Enter the contract address you created in the token field next to the ETH field .
5. In the "Deposit" section, enter the amount of ETH and tokens you wish to add as liquidity.

### Step 6: 

1. Return to Remix Ethereum.
2. Scroll down to the bottom of the "Deploy & Run Transactions" tab.
3. Click the arrow next to your contract name (e.g., `YOURSYMBOL - (contract address)`).

#### Enable Trading

1. Click on `enableTrading`.
2. In the `_canTrade:` field, enter `true`.
3. Click "Transact" and confirm the transaction in your wallet.

#### Remove Wallet Limit

1. Click on `removeWalletLimit`.
2. Confirm the transaction in your wallet.

#### Renounce Ownership

1. Click on `renounceOwnership`.
2. Confirm the transaction in your wallet.

### Step 7: Burn Liquidity

1. Go to [ScrollScan](https://scrollscan.com/) and find your "add liquidity" transaction.
2. Copy the address of the SushiSwap LP Token.
3. Import this token into your wallet.
4. Send all the SushiSwap LP Tokens to `0x000000000000000000000000000000000000dEaD` to burn the liquidity.

## Conclusion

Following these steps, you will have successfully deployed an ERC20 token on SCROLL, added liquidity, enabled trading, removed wallet limitations, and burned the liquidity. Enjoy your new token deployment!

## Contribution 

Contributions to this project are welcome. Please feel free to submit bug fixes, improvements, or new features via pull requests. For major changes, please open an issue first to discuss what you would like to change.

