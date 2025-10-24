const { ethers } = require("hardhat");

async function main() {
  // 1. Get deployer/signer accounts
  const [payer, payee, arbiter] = await ethers.getSigners();

  // 2. Define the amount to be escrowed (e.g., 1 ETH)
  const amount = ethers.utils.parseEther("1.0");

  console.log("Deploying contract with the following accounts:");
  console.log("  Payer (deployer):", payer.address);
  console.log("  Payee:", payee.address);
  console.log("  Arbiter:", arbiter.address);
  console.log("  Escrow Amount:", ethers.utils.formatEther(amount), "ETH");

  // 3. Get the ContractFactory
  // Make sure the contract name "Project" matches your .sol file
  const Project = await ethers.getContractFactory("Project");

  // 4. Deploy the contract
  // The 'payer' is msg.sender, so it deploys
  // We pass payee and arbiter addresses to the constructor
  // We pass the 'amount' as the 'value' (msg.value)
  const project = await Project.deploy(payee.address, arbiter.address, {
    value: amount,
  });

  // 5. Wait for the deployment to be confirmed
  await project.deployed();

  console.log("\n✅ Contract deployed successfully!");
  console.log("  Contract Address:", project.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });