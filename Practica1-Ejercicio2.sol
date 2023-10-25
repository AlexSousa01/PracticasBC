// SPDX-License-Identifier: Unlicenced
pragma solidity 0.8.18;

contract TokenContract {
    address public owner;
    uint256 public tokenPrice = 5 ether;

    struct Receivers { 
        string name;
        uint256 tokens;
        }

    mapping(address => Receivers) public users;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    constructor(){
        owner = msg.sender;
        users[owner].tokens = 100; 
    }
 
    function double(uint _value) public pure returns (uint){
        return _value*2;
    }
 
    function register(string memory _name) public{
        users[msg.sender].name = _name;
    }
 
    function giveToken(address _receiver, uint256 _amount) onlyOwner public{
        //Si numero tokens del propietario > importe, funciona:
        require(users[owner].tokens >= _amount, "Underflow");
        //Restar cantidad al emisor y sumar al receptor
        users[owner].tokens -= _amount;
        users[_receiver].tokens += _amount;
    }

    function purchaseTokens(uint256 _amount) public payable {
        uint256 cost = _amount * tokenPrice;

        //Comprobar si se paga al menos el coste
        require(msg.value >= cost, "Not enough Ether");
        //Comprobar si el vendedor tiene suficientes tokens
        require(users[owner].tokens >= _amount, "Not enough available tokens");

        //Realizar la transferencia
        users[owner].tokens -= _amount;
        users[msg.sender].tokens += _amount;

        //Devolver el exceso de Ether al comprador
        if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
        }
    }
}
