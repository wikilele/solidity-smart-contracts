pragma solidity ^0.4.22;
import "./SimpleEscrow.sol";
import "./DecreasingStrategies.sol";


contract DutchAuction{
    uint256 openedForLength;
    
    uint256 reservePrice;
    address seller; 
    
    IDecreasingStrategy decrStratedy;
    
    // used for escrow
    address escrowTrustedThirdParty;
    SimpleEscrow simpleescrow;
    
    uint256 gracePeriod;
    
    // events
    event AuctionCreated(uint32 availableIn); // getting the number of blocks corresponding to the grace period

    event Winner(address winnerBidder);
    
    // testing related evetnts
    event NewBlock(uint256 blockNum);

    
    constructor (uint256  _reservePrice,
                uint256 _openedForLength,
                address _seller,
                IDecreasingStrategy _decrStratedy,
                uint32 miningRate) public{
            
            openedForLength = _openedForLength;
            seller = _seller;
            reservePrice = _reservePrice;
            
            decrStratedy = _decrStratedy;

            // the auction house will also be the trusted third party for the escrow
            escrowTrustedThirdParty = msg.sender;
            
            // miningRate == 15 means that on average one block is mined every 15 seconds
            gracePeriod = block.number + 5*60 / miningRate; 
            
            
            emit AuctionCreated( 5*60 / miningRate);
            
        }
        
    }    
        
        
        
        
        
        
