pragma solidity ^0.4.0;

contract VickeryAuction{
    // length of each of the 3 phases expressed in mined blocks
    uint32 commitmentPhaseLength;
    uint32 withdrawalPhaseLength;
    uint32 openingPahseLength;
    uint32 reservePrice;
    uint32 depositRequired;
    mapping(address => uint256) commitedEnvelops; 
    
    function VickeryAuction (uint32  _reservePrice,
                uint32 _commitmentPhaseLength,
                uint32 _withdrawalPhaseLength,
                uint32 _openingPahseLength,
                uint32 _depositRequired)public {
                    
        reservePrice = _reservePrice;
        commitmentPhaseLength = _commitmentPhaseLength;
        withdrawalPhaseLength = _withdrawalPhaseLength;
        openingPahseLength = _openingPahseLength;

        depositRequired = _depositRequired;    
                    
        }
        
        function commitBid(uint256 envelop) public payable{
            
        }
        function withdraw(){
            
        }
        
        function open(uint32 nonce){
            
        }
}