pragma solidity ^0.5.0;

contract xToken{

    string public name = "X Token";
    string public symbol = "XTOK";
    string public standard = "X Token v1.0";
    uint256 public totalSupply;

    address public owner;
    uint public creationTime;
    uint public inflationTime;

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

    // TODO: Event for inflate?

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
        owner = msg.sender;
        creationTime = now;
        inflationTime = now;
    }

    modifier onlyBy(address _account){
        require(msg.sender == _account, "sender not authorized");
        _;
    }

    modifier onlyAfter(uint _time) {
        require(now >= _time, "function called too early");
        _;
    }

    function inflate(uint256 _percentage) public onlyBy(owner) onlyAfter(inflationTime + 365 days) returns(bool success){
        require((_percentage <= 0) && (_percentage >= 100), "percentage must be inbetween 0 and 100");
        totalSupply += _percentage/100*totalSupply;
        inflationTime = now;
        return true;
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