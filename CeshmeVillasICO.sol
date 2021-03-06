pragma solidity ^0.4.11;

import './IERC20.sol';
import './SafeMath.sol';

contract CeshmeVillasICO is IERC20 {
    
       using SafeMath for uint256;
       
       uint public _totalSupply = 0;
       uint public _maxSupply = 1000;
       
       bool public executed = false;
       
       address public owner;
       string public symbol;
       string public name;
       uint8 public decimals;
       uint256 public RATE;
       
       mapping(address => uint256) balances;
       mapping(address => mapping(address => uint256)) allowed;
       
       function () payable {
           
           createTokens();
       }
       
       function CeshmeVillasICO (string _symbol, string _name, uint8 _decimals, uint256 _RATE) {
           owner = msg.sender;
           symbol = _symbol;
           name = _name;
           decimals = _decimals;
           RATE = _RATE;
       }
       
       function createTokens() payable {
           require(msg.value > 0);
           uint256 tokens = msg.value.mul(RATE)/1000000000000000000;
           uint256 tokenstest=_totalSupply.add(tokens);
           require(tokenstest<=_maxSupply);
           _totalSupply = _totalSupply.add(tokens);
           balances[msg.sender] = balances[msg.sender].add(tokens);
           
           owner.transfer(msg.value);
		   executed = true;
       }
       
       function totalSupply() constant returns (uint256) {
           return _totalSupply;
       }
       
       function balanceOf (address _owner) constant returns (uint256) {
           return balances[_owner];
       }
       
       function transfer(address _to, uint256 _value) returns (bool) {
           require(balances[msg.sender] >= _value && _value > 0);
           balances[msg.sender] = balances[msg.sender].sub(_value);
           balances[_to] = balances[_to].add(_value);
           Transfer(msg.sender, _to, _value);
           return true;
       }
       
       function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
           require (allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
           balances[_from] = balances[_from].sub(_value);
           balances[_to] = balances[_to].add(_value);
           allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
           Transfer(_from, _to, _value);
           return true;
       }
       
       function approve (address _spender, uint256 _value) returns (bool) {
           allowed[msg.sender][_spender] = _value;
           Approval(msg.sender, _spender, _value);
           return true;
       }
       
       function allowance(address _owner, address _spender) constant returns (uint256) {
           return allowed[_owner][_spender];
       }
       
       event Transfer(address indexed _from, address indexed _to, uint256 _value);
       event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}
