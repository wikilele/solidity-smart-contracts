pragma solidity >=0.4.22 <0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./DecreasingStrategies.sol";    
      
      
      contract test_1 {
        IDecreasingStrategy dslinear;
        IDecreasingStrategy dslog;
        function beforeAll() public {
          dslinear = new LinearDecreasingStrategy();
          dslog = new LogarithmicDecreasingStrategy();
          
        }

        function check1() public returns(bool) {
          // use 'Assert' to test the contract
          
          uint256  res1  = dslinear.getCurrentPrice(1,4,4,0);
          Assert.equal(res1, 3, "res 1 not working");
          uint256  res2  = dslinear.getCurrentPrice(3,4,4,0);
          Assert.equal(res2, 1, "res 2 not working");
          uint256  res3  = dslinear.getCurrentPrice(2,4,4,0);
          Assert.equal(res3, 2, "res 3 not working");

        }

        function check2() public returns(bool) {
          uint256  res1  = dslinear.getCurrentPrice(2,8,4,0);
          Assert.equal(res1, 3, "res 1 not working");
          uint256  res2  = dslinear.getCurrentPrice(6,8,4,0);
          Assert.equal(res2, 1, "res 2 not working");
          uint256  res3  = dslinear.getCurrentPrice(4,8,4,0);
          Assert.equal(res3, 2, "res 3 not working");
        
        }
        
        function check3() public returns(bool){
            uint256 res1 = dslog.getCurrentPrice(4,8,4,0);
            Assert.equal(res1, 3, "res 1 not working");
            uint256 res2 = dslog.getCurrentPrice(2,8,4,0);
            Assert.equal(res2, 3, "res 2 not working");
            uint256 res3 = dslog.getCurrentPrice(6,8,4,0);
            Assert.equal(res3, 2, "res 3 not working");
        }
        
        
      }
      
      
      
      
