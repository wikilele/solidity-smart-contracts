pragma solidity ^0.4.22;

// the contract itself will act as the third party auction house
contract VickeryAuction{
    // length of each of the 3 phases expressed in mined blocks
    uint32 commitmentPhaseLength;
    uint32 withdrawalPhaseLength;
    uint32 openingPahseLength;
    uint256 public reservePrice;
    uint256 public depositRequired;
    address seller; // he deploys the contract to sell something he owns
    mapping(address => uint256) commitedEnvelops; 

    uint256 gracePeriod;
    
    uint256 firstBid;
    address firstBidAddress;
    uint256 secondBid;
    address secondBidAddress;
    
    // events
    event CommitedEnvelop(address bidderAddress);
    event Withdraw(address leavingBidderAddress);
    event Open(address bidderAddress, uint256 value);
    event FirstBid(address bidderAddress, uint256 value);
    event SecondBid(address bidderAddress, uint256 value);
    event Winner(address winnerBidder);
    
    // testing related evetnts
    event NewBlock(uint256 blockNum);
    event Hash(bytes32 h); 
    
    
    constructor (uint256  _reservePrice,
                uint32 _commitmentPhaseLength,
                uint32 _withdrawalPhaseLength,
                uint32 _openingPahseLength,
                uint256 _depositRequired,
                uint32 miningRate)public {
            // getting the address of the contract creator
            seller = msg.sender;
            reservePrice = _reservePrice;
            commitmentPhaseLength = _commitmentPhaseLength;
            withdrawalPhaseLength = _withdrawalPhaseLength;
            openingPahseLength = _openingPahseLength;
    
            depositRequired = _depositRequired;    
            
            // miningRate == 15 means that on average one block is mined every 15 seconds
            gracePeriod = block.number + 5*60 / miningRate; 
            
            /*
            * Since the first bid is init to reservePrice the bidder to win has to al least offer reservePrice + 1
            * The semantic is not perfect, but keeping it in this way allows the code to be more clean
            */
            secondBid = firstBid = reservePrice; 
            secondBidAddress = firstBidAddress = this;
        }


        modifier checkCommitmentPahseLenght(){
            require(gracePeriod < block.number &&
                        block.number <= gracePeriod + commitmentPhaseLength, "not in commitment phase");_;
        }
        modifier checkWithdrawalPhaseLength(){
            require(gracePeriod + commitmentPhaseLength < block.number &&
                        block.number <= gracePeriod + commitmentPhaseLength + withdrawalPhaseLength, "not in withdrawal phase" );_;
        }
        modifier checkOpeningPahseLength(){
            require(gracePeriod + commitmentPhaseLength + withdrawalPhaseLength < block.number &&
                        block.number <= gracePeriod + commitmentPhaseLength + withdrawalPhaseLength + openingPahseLength, "not in opening phase");_;
        }
        modifier checkAuctionEnd(){
            require(gracePeriod + commitmentPhaseLength + withdrawalPhaseLength + openingPahseLength < block.number, "auction not ended");_;
        }
        
 
        function commitBid( uint256 envelop) external payable checkCommitmentPahseLenght(){ 
            // the seller can't bid
            require(msg.sender != seller, "seller can't commit bid");
            // won't keeep the actual deposit given cuse its gas consuming,  the sender should send the right ammount 
            require(msg.value >= depositRequired, "need to send the deposit" );
            // the bidder can't bid more than one time
            require(commitedEnvelops[msg.sender] == 0, "you already called this function");
            
            commitedEnvelops[msg.sender] = envelop;
            emit CommitedEnvelop(msg.sender);
        }
        
        
        function withdraw() external checkWithdrawalPhaseLength(){

            if (commitedEnvelops[msg.sender] != 0){
                // this avoids to call the function multiple times
                commitedEnvelops[msg.sender] = 0;
                msg.sender.transfer(depositRequired/2);
                emit Withdraw(msg.sender);
            }
        }
        
        
        function open(uint256 nonce) external payable checkOpeningPahseLength(){
            // checking if the bid and the evelop match
            uint256 tmphash = uint256(keccak256(msg.value, nonce));
            // the last condition is useful to a avoid a fake withdraw: a bidder can bid 0 then open to get the deposit back 
            require((commitedEnvelops[msg.sender] == tmphash) && (msg.value >= reservePrice), "haven't sent the right ammount" );
            
            // to avoid more calls of the function from the same bidder
            commitedEnvelops[msg.sender] = 0;
            emit Open(msg.sender, msg.value);
            
            uint256 tmpBid;
            address tmpAddress;
            if(msg.value > firstBid){
                tmpBid = secondBid;
                tmpAddress = secondBidAddress;
                
                // first bid will become the secondBid, the old second bidder will be refounded
                secondBid = firstBid;
                secondBidAddress = firstBidAddress;
                    
                firstBid = msg.value;
                firstBidAddress = msg.sender;
                emit FirstBid(msg.sender, msg.value);
                
                // prefer first to set the values and then to transfer the money
                if (tmpBid > reservePrice)
                    tmpAddress.transfer(tmpBid + depositRequired);
                
            }else if (msg.value > secondBid) {
                tmpBid = secondBid;
                tmpAddress = secondBidAddress;
                
                secondBid = msg.value;
                secondBidAddress = msg.sender;
                emit SecondBid(msg.sender, msg.value);
                
                if (tmpBid > reservePrice)
                    tmpAddress.transfer(tmpBid + depositRequired);
            
            }else
                msg.sender.transfer(msg.value + depositRequired);
        }
        
        
        function finalize() external checkAuctionEnd(){
            // only the seller can call this
            require(msg.sender == seller, "only the seller can call this function");
            
            if (secondBid != reservePrice)
                secondBidAddress.transfer(secondBid + depositRequired);
            
            // the winner pays the ammount offered by the second winner
            emit Winner(firstBidAddress);
            firstBidAddress.transfer(firstBid - secondBid + depositRequired);
            
            // TODO implement escrow??
            
            seller.transfer(secondBid);
            
            //burning remaining ether
            address burnAddress = 0x0;
            burnAddress.transfer(address(this).balance);
        }
        
        
        /*
        * The function above are added only to test better the contract.
        * In a real environment they should be removed
        */
        function addBlock() public  payable{
            emit NewBlock(block.number);
        }
        
        /*
        * Can be used to retrive the hash to be passed to the open function
        */
        function doKeccak(uint256 nonce) external payable{
            emit Hash(keccak256(msg.value,nonce));
        }
        
        
}









