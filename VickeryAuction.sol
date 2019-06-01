pragma solidity ^0.4.10;

// the contract itself will act as the third party auction house
contract VickeryAuction{
    // length of each of the 3 phases expressed in mined blocks
    uint32 commitmentPhaseLength;
    uint32 withdrawalPhaseLength;
    uint32 openingPahseLength;
    uint256 reservePrice;
    uint256 public depositRequired;
    address owner;
    mapping(address => uint256) commitedEnvelops; 
    
    uint256 bestBid;
    address bestBidAddress;
    uint256 secondBid;
    address secondBidAddress;
    
    function VickeryAuction (uint256  _reservePrice,
                uint32 _commitmentPhaseLength,
                uint32 _withdrawalPhaseLength,
                uint32 _openingPahseLength,
                uint256 _depositRequired)public {
        // getting the address of the contract creator
        owner = msg.sender;
        reservePrice = _reservePrice;
        commitmentPhaseLength = _commitmentPhaseLength;
        withdrawalPhaseLength = _withdrawalPhaseLength;
        openingPahseLength = _openingPahseLength;

        depositRequired = _depositRequired;    
        
        secondBid = bestBid = reservePrice -1; // TODO check this better
        secondBidAddress = bestBidAddress = this;
        }
        // TODO check that the owner does not call the functions
        function commitBid(uint256 envelop) external payable{ 
            // need a modifier to check time validity
            // won't keeep the actual deposit given cuse its gas consuming
            // the sender should send the right ammount 
            require(msg.value >= depositRequired);
            
            commitedEnvelops[msg.sender] = envelop;
        }
        
        function withdraw() external {
            // need a modifier to check time validity
            if (commitedEnvelops[msg.sender] != 0){
                // this avoids to call the function multiple times
                commitedEnvelops[msg.sender] = 0;
                msg.sender.transfer(depositRequired/2);
            }
        }
        
        function open(uint32 nonce) external payable{
            // need a modifier to check time validity
            // checking if the bid and the evelop match
            uint256 tmphash = uint256(keccak256(msg.value, nonce));
            require((commitedEnvelops[msg.sender] == tmphash) && (msg.value >= reservePrice) );
            
            if(msg.value > bestBid){
                if (bestBid != reservePrice-1) // refounding
                    bestBidAddress.transfer(bestBid + depositRequired); // check transfer (transfer aborts all and rolls back) 
                    // send instead reutrn false if it is unsuccessful
                bestBid = msg.value;
                bestBidAddress = msg.sender;
            }else if (msg.value > secondBid) {
                if (secondBid != reservePrice-1) 
                    secondBidAddress.transfer(bestBid + depositRequired);
                secondBid = msg.value;
                secondBidAddress = msg.sender;
            }else
                msg.sender.transfer(msg.value + depositRequired);
        }
        
        function finalize() external {
            // need a modifier to check time validity
            require(msg.sender == owner);
            
            if (secondBid == reservePrice-1) // TDO check this I don't like it
                secondBid = reservePrice;
            else{
                // sending back ether to second winner
                secondBidAddress.send(secondBid + depositRequired);
            }
            // the winner pays the ammount offered by the second winner
            bestBidAddress.transfer(bestBid - secondBid + depositRequired);
            
            // TODO implement escrow??
            
            owner.transfer(secondBid);
        }
}



