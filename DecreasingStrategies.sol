pragma solidity ^0.4.22;

contract IDecreasingStrategy{
    
    function getDecreasedPrice(uint256 elapsedTime) public pure returns(uint256);
}