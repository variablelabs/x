pragma solidity ^0.5.0;

contract xToken{

    string public name = "X Alpha Token";
    string public symbol = "XAL";
    string public standard = "X Token v1.0";
    uint256 public totalSupply;
    uint8 public decimals;

    address payable public owner;
    uint public creationTime;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
        decimals = 18;
        owner = msg.sender;
        creationTime = now;
    }

    function transfer(address _to, uint256 _value) public returns(bool success){
        require(balanceOf[msg.sender] >= _value, "balance is lower than value to be transferred");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns(bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        require(_value <= balanceOf[_from], "value being transfered is larger than balance");
        require(_value <= allowance[_from][msg.sender], "value being spent is larger than allowance");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }
}