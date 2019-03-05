pragma solidity ^0.5.0;

/**
@dev Contract for the 'X Alpha Token'
Used as a token for all services by Variable Labs.
Compliant with the ERC20 standards. https://eips.ethereum.org/EIPS/eip-20
@author https://github.com/parthvshah
*/

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;
    return c;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
  }
}

contract xToken{
    using SafeMath for uint256;
    /**
    @dev Specifics of the token
    Consists of the name, symbol, standard, totalSupply and decimals of the token.
    Accessible via getter functions.
    */
    string public name = "X Alpha Token";
    string public symbol = "XAL";
    string public standard = "X Token v1.0";
    uint256 public totalSupply;
    uint8 public decimals;

    /**
    @dev Owner and creation time
    The address of the owner is stored with the time of creation of the contract.
    */
    address payable public owner;
    uint public creationTime;

    /**
    @dev Event for a transfer
    _from and _to with the _value are emitted.
    */
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    /**
    @dev Event for an Approval
    _owner and _spender with the _value are emitted.
    */
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    /**
    @dev Store for balances and allowances
    Mappings to track each users' balance and allowance 
    */
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /**
    @dev Constructor for the contract
    @param _initialSupply Assigns the initial supply to the owner of the contract. Sets the totalSupply to the initialSupply.
    Sets the decimals, owner and creationTime parameters. 
    */
    constructor(uint256 _initialSupply) public {
        decimals = 18;
        balanceOf[msg.sender] = _initialSupply * 10 ** uint256(decimals);
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        owner = msg.sender;
        creationTime = now;
    }

    /**
    @dev Function to transfer funds from the owner to an account
    @param _to @param _value @return success
    Function to transfer specified number of tokenss from the owner to a specified address.
    Changes the balances of both accounts and emits a 'Transfer' event. 
    */
    function transfer(address _to, uint256 _value) public returns(bool success){
        require(balanceOf[msg.sender] >= _value, "balance is lower than value to be transferred");
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    @dev Function to approve an address to spend some tokens
    @param _spender @param _value @return success
    Function changes the allowance limit of a specified address by a fixed value. 
    Emits an 'Approval' event.
    */
    function approve(address _spender, uint256 _value) public returns(bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
    @dev Function to transfer funds from the owner to an account
    @param _from @param _to @param _value @return success
    Function to transfer specified number of tokenss from the owner to a specified address.
    Requires the value to be lesser than the balance of the sender, allowance limit of the sender.
    Changes the balances of both accounts, changes the allowance limit and emits a 'Transfer' event. 
    */
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        require(_value <= balanceOf[_from], "value being transfered is larger than balance");
        require(_value <= allowance[_from][msg.sender], "value being spent is larger than allowance");

        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);

        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);
        return true;
    }
}