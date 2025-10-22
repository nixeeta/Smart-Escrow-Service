# Smart Escrow Service 🚀

This is a decentralized application (dApp) that implements a smart escrow service on the Ethereum blockchain.

It allows a **payer** to deposit funds (ETH) into a smart contract. These funds are held securely and can only be released to a designated **payee** or refunded back to the **payer** by a trusted, neutral **arbiter**. This project includes the Solidity smart contract, tests, and a simple web-based frontend for interaction.

## ✨ Features

  * **Deploy New Escrow:** Any user can deploy a new escrow contract, specifying the payee, arbiter, and the amount of ETH to be held.
  * **Secure Fund Holding:** The smart contract securely holds the deposited ETH.
  * **Arbiter-Controlled Release:** Only the designated arbiter can release the funds to the payee.
  * **Arbiter-Controlled Refund:** Only the designated arbiter can refund the funds back to the payer.
  * **Web Interface:** A simple frontend allows users to connect their MetaMask wallet to deploy and interact with escrow contracts.

-----

## 💻 Tech Stack

  * **Solidity:** For the `Escrow.sol` smart contract.
  * **Hardhat:** For the development environment, local blockchain, and testing.
  * **Ethers.js:** For frontend-to-blockchain communication.
  * **HTML, CSS, JS:** For the dApp frontend.
  * **MetaMask:** As the browser wallet provider.

-----

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:

  * [Node.js](https://nodejs.org/) (v18 or higher)
  * [Git](https://git-scm.com/)
  * [MetaMask](https://metamask.io/) browser extension

-----

## ⚙️ Installation & Setup

1.  **Clone the repository (if you haven't already):**

    ```bash
    git clone https://github.com/your-username/smart-escrow.git
    cd smart-escrow
    ```

2.  **Install project dependencies:**
    This will install Hardhat and all its plugins.

    ```bash
    npm install
    ```

3.  **Compile the smart contract:**
    This generates the ABI and bytecode needed for the frontend.

    ```bash
    npx hardhat compile
    ```

    *(Note: The `frontend/app.js` file expects the ABI and bytecode from this compilation. If you change `Escrow.sol`, you must re-paste the new ABI/bytecode into `app.js` as described in Day 9 of the plan.)*

-----

## ▶️ Running the Project Locally

You'll need two terminals open to run the full application.

### 1\. Terminal 1: Start the Local Blockchain

Run the Hardhat local node. This will create a local Ethereum blockchain with 20 test accounts.

```bash
npx hardhat node
```

Keep this terminal running. It will show you a list of accounts and their private keys.

### 2\. Configure MetaMask

1.  Open MetaMask and click the network dropdown (e.g., "Ethereum Mainnet").
2.  Select "Add network" -\> "Add a network manually".
3.  Enter the following:
      * **Network Name:** `Hardhat Local`
      * **New RPC URL:** `http://127.0.0.1:8545/`
      * **Chain ID:** `31337`
      * **Currency Symbol:** `ETH`
4.  Click **Save**.
5.  Now, import test accounts. Click the "Accounts" circle -\> "Import account".
6.  Copy/paste the **private key** from your terminal for "Account \#0". This will be your **Payer**.
7.  Repeat the process to import "Account \#1" (as **Arbiter**) and "Account \#2" (as **Payee**).

### 3\. Terminal 2: Launch the Frontend

We need a simple web server to serve the `frontend` files.

```bash
# Install http-server globally (if you haven't)
npm install -g http-server

# Navigate to the frontend directory
cd frontend

# Start the server
http-server
```

This will make your frontend available at `http://127.0.0.1:8080`.

-----

## 📋 Usage Workflow

1.  Open `http://127.0.0.1:8080` in your browser.
2.  In MetaMask, make sure you are on the **Hardhat Local** network and have your **Payer** (Account \#0) selected.
3.  Click **"Connect Wallet"** on the webpage.
4.  **Create New Escrow:**
      * **Payee Address:** Copy/paste the address for Account \#2.
      * **Arbiter Address:** Copy/paste the address for Account \#1.
      * **Amount (in ETH):** Enter an amount, e.g., `1.5`.
5.  Click **"Deploy"**. MetaMask will pop up. Confirm the transaction (which includes sending the 1.5 ETH).
6.  Wait for the "Deployed successfully" status and **copy the new contract address**.
7.  **Interact with Escrow:**
      * In MetaMask, switch your active account to the **Arbiter** (Account \#1).
      * Paste the copied contract address into the "Contract Address" field in the second section.
      * Click **"Release Funds"** (to send to Payee) or **"Refund Funds"** (to send back to Payer).
8.  Confirm the transaction in MetaMask.
9.  The status will update, and you can check the ETH balances in MetaMask to confirm the transfer\!

-----

## 🧪 Running Tests

To run the automated tests for the smart contract, use:

```bash
npx hardhat test
```

-----

## 📄 License

This project is licensed under the MIT License.