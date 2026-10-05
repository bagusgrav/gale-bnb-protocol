// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdRewardVault {
    address public platformTreasury;
    uint256 public totalAdBudget;

    event AdBudgetDeposited(address indexed advertiser, uint256 amount, uint256 fee);
    event RewardClaimed(address indexed viewer, uint256 amount);

    constructor() {
        platformTreasury = msg.sender;
    }

    // Pengiklan menyetor anggaran iklan
    function depositBudget() external payable {
        require(msg.value > 0, "Budget harus lebih dari 0");
        uint256 fee = (msg.value * 20) / 100; // 20% untuk developer Thort
        totalAdBudget += (msg.value - fee);
        emit AdBudgetDeposited(msg.sender, msg.value, fee);
    }

    // Penonton klaim reward (simulasi testnet)
    function claimReward(address payable viewer, uint256 amount) external {
        require(msg.sender == platformTreasury, "Hanya verifier yang bisa approve");
        require(amount <= totalAdBudget, "Saldo pool tidak cukup");
        totalAdBudget -= amount;
        viewer.transfer(amount);
        emit RewardClaimed(viewer, amount);
    }

    receive() external payable {}
}
