Copy code
pragma solidity ^0.8.0;

contract Wallet {
    mapping(address => uint256) public balance;

    function checkBalance() public view returns (uint256) {
        return balance[msg.sender];
    }
}
