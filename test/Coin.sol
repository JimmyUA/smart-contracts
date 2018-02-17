pragma solidity ^0.4.0;

contract Coin {

    address public minter;
    mapping (address => uint) public balanses;

    event Sent (address from, address to, uint amount);


    function Coin() public{
        minter = msg.sender;
    }

    function mint (address receiver, uint amount){
        if (msg.sender != minter){
            return;
        }
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) {
        if (balanses[msg.sender] < amount) return;
        balanses[msg.sender] -= amount;
        balanses[receiver] += amount;
        Sent(msg.sender, receiver, amount);
    }
}
    