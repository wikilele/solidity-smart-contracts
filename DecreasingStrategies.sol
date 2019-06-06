pragma solidity >=0.4.22 <0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./DecreasingStrategies.sol";    
      
      
      contract test_1 {
        IDecreasingStrategy ds;
        function beforeAll() public {
          ds = new LinearDecreasingStrategy();
        }

        function check1() public returns(bool) {
          // use 'Assert' to test the contract
          
          uint256  res1  = ds.getCurrentPrice(1,4,4,0);
          //Assert.equal(uint(2), uint(1), "error message");
          //Assert.equal(uint(2), uint(2), "error message");
          Assert.equal(res1, 3, "not working");

        }

        function check2() public returns(bool) {
          // use 'Assert' to test the contract
          
          uint256  res1  = ds.getCurrentPrice(3,4,4,0);
          //Assert.equal(uint(2), uint(1), "error message");
          //Assert.equal(uint(2), uint(2), "error message");
          Assert.equal(res1, 1, "not working");

        }
      }
