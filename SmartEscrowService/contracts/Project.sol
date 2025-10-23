// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import this for debugging (optional, but good practice in Hardhat)
import "hardhat/console.sol";

/**
 * @title Project (Smart Escrow Service)
 * @dev A simple escrow contract where a payer sends funds,
 * and an arbiter can release them to a payee or refund the payer.
 */
contract Project {

    // --- State Variables ---

    address public payer;
    address public payee;
    address public arbiter;
    uint256 public amount;
    bool public isReleased;

    // --- Events ---
    event Deployed(address indexed payer, address indexed payee, address indexed arbiter, uint256 amount);
    event Released(uint256 amount);
    event Refunded(uint256 amount);

    // --- Constructor ---

    /**
     * @dev Sets up the escrow.
     * @param _payee The address that can receive the funds.
     * @param _arbiter The address that can approve release or refund.
     */
    constructor(address _payee, address _arbiter) payable {
        // The 'payable' keyword allows this function to receive Ether

        require(msg.value > 0, "Amount must be greater than 0");
        require(_payee != address(0), "Invalid payee address");
        require(_arbiter != address(0), "Invalid arbiter address");

        payer = msg.sender; // The person deploying/funding is the payer
        payee = _payee;
        arbiter = _arbiter;
        amount = msg.value; // The amount of Ether sent with the deployment
        isReleased = false;

        emit Deployed(payer, payee, arbiter, amount);
    }

    // --- Functions ---

    /**
     * @dev Allows the arbiter to release the funds to the payee.
     */
    function release() public {
        // Only the arbiter can call this
        require(msg.sender == arbiter, "Only arbiter can release");
        // Ensure funds haven't already been released
        require(!isReleased, "Funds already released");

        // Mark as released *before* sending Ether (prevents re-entrancy)
        isReleased = true;

        // Send the funds to the payee
        // We use .call() for robust Ether transfers
        (bool success, ) = payee.call{value: amount}("");
        require(success, "Transfer failed");

        emit Released(amount);
    }

    /**
     * @dev Allows the arbiter to refund the funds to the payer.
     */
    function refund() public {
        // Only the arbiter can call this
        require(msg.sender == arbiter, "Only arbiter can refund");
        // Ensure funds haven't already been released/refunded
        require(!isReleased, "Funds already released");

        isReleased = true; // Mark as "released" to prevent double-spending

        // Send the funds back to the payer
        (bool success, ) = payer.call{value: amount}("");
        require(success, "Transfer failed");

        emit Refunded(amount);
    }
}