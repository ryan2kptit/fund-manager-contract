// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FundManager is Ownable {
    // IERC20 public usdtToken;
    mapping(address => int256) public balances;
    mapping(address => mapping(address => int256)) public debts; // ai no ai bao nhieu tien
    mapping(address => address[]) public creditors; // Creditors for each debtor

    event ExpenseRecorded(
        address indexed payer,
        address[] friends,
        uint256 totalAmount
    );
    event DebtsSettled(
        address indexed payer,
        address indexed friend,
        uint256 amount
    );

    // constructor(address _usdtTokenAddress) {
    //     usdtToken = IERC20(_usdtTokenAddress);
    // }

    function recordExpense(
        address[] memory friends,
        uint256[] memory amounts
    ) external {
        require(friends.length == amounts.length, "Arrays lengths mismatch");

        uint256 totalExpense = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalExpense += amounts[i];
        }

        require(totalExpense > 0, "Total expense must be greater than 0");

        for (uint256 i = 0; i < friends.length; i++) {
            balances[friends[i]] -= int256(amounts[i]);
            debts[friends[i]][msg.sender] += int256(amounts[i]);
            if (debts[friends[i]][msg.sender] > 0) {
                creditors[msg.sender].push(friends[i]);
            }
        }

        balances[msg.sender] += int256(totalExpense);

        // usdtToken.transferFrom(msg.sender, address(this), totalExpense);

        emit ExpenseRecorded(msg.sender, friends, totalExpense);
    }

    function settleDebts(address friend) external {
        require(balances[friend] < 0, "No debt to settle");
        int256 debt = balances[friend] * -1;
        balances[msg.sender] -= debt;
        balances[friend] = 0;
        // usdtToken.transfer(friend, uint256(debt));

        debts[msg.sender][friend] = 0; // Reset the debt relationship

        address[] storage debtorCreditors = creditors[msg.sender];
        for (uint256 i = 0; i < debtorCreditors.length; i++) {
            if (debtorCreditors[i] == friend) {
                debtorCreditors[i] = debtorCreditors[
                    debtorCreditors.length - 1
                ];
                debtorCreditors.pop();
                break;
            }
        }

        emit DebtsSettled(msg.sender, friend, uint256(debt));
    }

    function getDebt(address friend) external view returns (int256) {
        return balances[friend] < 0 ? balances[friend] : int256(0);
    }

    function getAllDebts(
        address debtor
    ) external view returns (address[] memory, int256[] memory) {
        address[] memory creditorList = creditors[debtor];
        int256[] memory amounts = new int256[](creditorList.length);

        for (uint256 i = 0; i < creditorList.length; i++) {
            amounts[i] = debts[debtor][creditorList[i]];
        }

        return (creditorList, amounts);
    }

    function getAllCreditors(
        address debtor
    ) internal view returns (address[] memory) {
        return creditors[debtor];
    }

    function calculatePaybackAmount(
        address debtor
    ) external view returns (uint256) {
        require(balances[debtor] < 0, "Not a debtor");
        return uint256(balances[debtor] * -1);
    }

    function getDebtRelationship(
        address debtor
    ) external view returns (address[] memory, int256[] memory) {
        address[] memory creditorList = creditors[debtor];
        int256[] memory amounts = new int256[](creditorList.length);

        for (uint256 i = 0; i < creditorList.length; i++) {
            amounts[i] = debts[debtor][creditorList[i]];
        }

        return (creditorList, amounts);
    }
}
