const { expect } = require("chai");
const { ethers } = require("hardhat");

// This test suite is for your "Project.sol" contract
describe("Project", function () {
    let Project;
    let project;
    let payer, payee, arbiter;
    const amount = ethers.utils.parseEther("1.0"); // 1 ETH

    beforeEach(async function () {
        // Get test accounts
        [payer, payee, arbiter] = await ethers.getSigners();

        // Get the ContractFactory
        Project = await ethers.getContractFactory("Project");
        
        // Deploy the contract
        project = await Project.deploy(payee.address, arbiter.address, {
            value: amount,
        });
        await project.deployed();
    });

    it("Should deploy and set the correct state", async function () {
        expect(await project.payer()).to.equal(payer.address);
        expect(await project.payee()).to.equal(payee.address);
        expect(await project.arbiter()).to.equal(arbiter.address);
        expect(await project.amount()).to.equal(amount);
        expect(await project.isReleased()).to.be.false;
    });

    it("Should not allow non-arbiter to release funds", async function () {
        // Try to release funds as the payer
        await expect(project.connect(payer).release()).to.be.revertedWith(
            "Only arbiter can release"
        );
        // Try to release funds as the payee
        await expect(project.connect(payee).release()).to.be.revertedWith(
            "Only arbiter can release"
        );
    });

    it("Should allow arbiter to release funds to payee", async function () {
        // Check payee's balance before
        const beforeBalance = await ethers.provider.getBalance(payee.address);

        // Arbiter releases funds
        const tx = await project.connect(arbiter).release();
        await tx.wait();

        // Check payee's balance after
        const afterBalance = await ethers.provider.getBalance(payee.address);
        expect(afterBalance.sub(beforeBalance)).to.equal(amount);

        // Check contract state
        expect(await project.isReleased()).to.be.true;
    });

    it("Should allow arbiter to refund funds to payer", async function () {
        // Check payer's balance before (will be less tx fee)
        const beforeBalance = await ethers.provider.getBalance(payer.address);

        // Arbiter refunds funds
        // We connect as arbiter to call the function
        const tx = await project.connect(arbiter).refund();
        const receipt = await tx.wait();

        // Calculate gas cost
        const gasUsed = receipt.gasUsed.mul(tx.gasPrice);
        
        // Check payer's balance after
        const afterBalance = await ethers.provider.getBalance(payer.address);
        
        // After balance should be before balance + amount - gas
        expect(afterBalance).to.equal(beforeBalance.add(amount).sub(gasUsed));

        // Check contract state
        expect(await project.isReleased()).to.be.true;
    });

    it("Should not allow release or refund after funds are released", async function () {
        // Release funds first
        await project.connect(arbiter).release();

        // Try to release again
        await expect(project.connect(arbiter).release()).to.be.revertedWith(
            "Funds already released"
        );

        // Try to refund
        await expect(project.connect(arbiter).refund()).to.be.revertedWith(
            "Funds already released"
        );
    });
});