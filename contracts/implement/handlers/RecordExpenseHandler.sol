// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../common/Upgradeable.sol";

contract RecordExpenseHandler is Upgradeable {
    event ExpenseRecorded(
        address indexed payer,
        address[] friends,
        uint256 totalAmount 
    );

    /**
     * @param _friends: list user's address
     * @param _amounts: list user'amount follow friends's order
     */
    function handleRecordExpense(
        address[] memory _friends,
        uint256[] memory _amounts
    ) internal {
        require(_friends.length == _amounts.length, "Arrays lengths mismatch");

        uint256 totalExpense = 0;
        for (uint256 i = 0; i < _amounts.length; i++) {
            totalExpense += _amounts[i];
        }

        require(totalExpense > 0, "Total expense must be greater than 0");

        for (uint256 i = 0; i < _friends.length; i++) {
            balances[_friends[i]] -= int256(_amounts[i]);
            debts[_friends[i]][msg.sender] += int256(_amounts[i]);
            if (debts[_friends[i]][msg.sender] > 0) {
                creditors[msg.sender].push(_friends[i]);
            }
        }

        balances[msg.sender] += int256(totalExpense);
        emit ExpenseRecorded(msg.sender, _friends, totalExpense);
    }
}
