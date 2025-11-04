// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SmartEscrowService
 * @dev A simple escrow smart contract that securely holds funds until both parties approve the transaction.
 */
contract SmartEscrowService {
    address public buyer;
    address public seller;
    address public arbiter;
    uint256 public amount;
    bool public buyerApproval;
    bool public sellerApproval;
    bool public fundsReleased;

    event Deposited(address indexed buyer, uint256 amount);
    event Approved(address indexed party);
    event Released(address indexed seller, uint256 amount);
    event Refunded(address indexed buyer, uint256 amount);

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only arbiter can call this");
        _;
    }

    constructor(address _seller, address _arbiter) payable {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
        amount = msg.value;

        emit Deposited(buyer, msg.value);
    }

    function approve() external {
        require(msg.sender == buyer || msg.sender == seller, "Not authorized");
        if (msg.sender == buyer) buyerApproval = true;
        if (msg.sender == seller) sellerApproval = true;

        emit Approved(msg.sender);

        if (buyerApproval && sellerApproval) {
            releaseFunds();
        }
    }

    function releaseFunds() internal {
        require(!fundsReleased, "Funds already released");
        fundsReleased = true;

        (bool success, ) = payable(seller).call{value: amount}("");
        require(success, "Transfer failed");

        emit Released(seller, amount);
    }

    function refund() external onlyArbiter {
        require(!fundsReleased, "Funds already released");
        fundsReleased = true;

        (bool success, ) = payable(buyer).call{value: amount}("");
        require(success, "Refund failed");

        emit Refunded(buyer, amount);
    }
}
