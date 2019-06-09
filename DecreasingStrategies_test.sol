pragma solidity >=0.4.22 <0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./DecreasingStrategies.sol";    
      
      
      contract test_1 {
        IDecreasingStrategy dslinear;
        IDecreasingStrategy dslog;
        IDecreasingStrategy dsinverselog;
        function beforeAll() public {
          dslinear = new LinearDecreasingStrategy();
          dslog = new LogarithmicDecreasingStrategy();
          dsinverselog = new InverseLogarithmicDecreasingStrategy();
          
        }

        function check1_linear() public returns(bool) {
          // use 'Assert' to test the contract
          
          uint256  res1  = dslinear.getCurrentPrice(1,4,4,0);
          Assert.equal(res1, 3, "res 1 not working");
          uint256  res2  = dslinear.getCurrentPrice(3,4,4,0);
          Assert.equal(res2, 1, "res 2 not working");
          uint256  res3  = dslinear.getCurrentPrice(2,4,4,0);
          Assert.equal(res3, 2, "res 3 not working");

        }

        function check2_linear() public returns(bool) {
          uint256  res1  = dslinear.getCurrentPrice(2,8,4,0);
          Assert.equal(res1, 3, "res 1 not working");
          uint256  res2  = dslinear.getCurrentPrice(6,8,4,0);
          Assert.equal(res2, 1, "res 2 not working");
          uint256  res3  = dslinear.getCurrentPrice(4,8,4,0);
          Assert.equal(res3, 2, "res 3 not working");
        
        }
        
        function check3_log() public returns(bool){
            uint256 res0 = dsinverselog.getCurrentPrice(0,8,4,0);
            Assert.equal(res0, 4, "res 1 not working");
            uint256 res1 = dslog.getCurrentPrice(4,8,4,0);
            Assert.equal(res1, 3, "res 1 not working");
            uint256 res2 = dslog.getCurrentPrice(2,8,4,0);
            Assert.equal(res2, 3, "res 2 not working");
            uint256 res3 = dslog.getCurrentPrice(6,8,4,0);
            Assert.equal(res3, 2, "res 3 not working");
            uint256 res4 = dslog.getCurrentPrice(8,8,4,0);
            Assert.equal(res4, 0, "res 3 not working");
        }
        
        function check4_inverselog() public returns(bool){
            uint256 res0 = dsinverselog.getCurrentPrice(0,8,4,0);
            Assert.equal(res0, 4, "res 0 not working");
            uint256 res1 = dsinverselog.getCurrentPrice(4,8,4,0);
            Assert.equal(res1, 1, "res 1 not working");
            uint256 res2 = dsinverselog.getCurrentPrice(2,8,4,0);
            Assert.equal(res2, 2, "res 2 not working");
            uint256 res3 = dsinverselog.getCurrentPrice(6,8,4,0);
            Assert.equal(res3, 1, "res 3 not working");
            uint256 res4 = dsinverselog.getCurrentPrice(8,8,4,0);
            Assert.equal(res4, 0, "res 4 not working");
        }
      }
      
      
      
      
