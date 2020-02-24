pragma solidity >=0.4.22 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Supertoken.sol";

contract TestSupertoken {

  function testInitialBalanceUsingDeployedContract() public {
    Supertoken meta = Supertoken(DeployedAddresses.Supertoken());

    uint expected = 10000;

    Assert.equal(meta.getBalance(msg.sender), expected, "Owner should have 10000 Supertoken initially");
  }

  function testInitialBalanceWithNewSupertoken() public {
    Supertoken meta = new Supertoken();

    uint expected = 10000;

    Assert.equal(meta.getBalance(msg.sender), expected, "Owner should have 10000 Supertoken initially");
  }

}

