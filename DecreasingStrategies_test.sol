pragma solidity ^0.4.22;

contract IDecreasingStrategy{
    
    function getCurrentPrice(uint256 elapsedTime,
                            uint256 totalTime,
                            uint256 initailPrice,
                            uint256 reservePrice) public pure returns(uint256);
}


contract LinearDecreasingStrategy is IDecreasingStrategy {
    
    function getCurrentPrice(uint256 elapsedTime,
                            uint256 totalTime,
                            uint256 initailPrice,
                            uint256 reservePrice) public pure returns(uint256){
    
            uint256 y1 = initailPrice - reservePrice;
            return  (elapsedTime*(-y1) + y1*totalTime)/totalTime;
            }
    
}


contract ExponentialDecreasingStrategy is IDecreasingStrategy{
    
    function getCurrentPrice(uint256 elapsedTime,
                            uint256 totalTime,        
                            uint256 initailPrice,
                            uint256 reservePrice) public pure returns(uint256){
                                
                            }
}

contract LogarithmicDecreasingStrategy is IDecreasingStrategy{
    
    function getCurrentPrice(uint256 elapsedTime,
                            uint256 totalTime,
                            uint256 initailPrice,
                            uint256 reservePrice) public pure returns(uint256){
                                
                            }
}


