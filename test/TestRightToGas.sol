pragma solidity >=0.4.22 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RightToGas.sol";

contract TestRightToGas {

  function testInitialBalanceUsingDeployedContract() public {
    RightToGas meta = RightToGas(DeployedAddresses.RightToGas());

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 RightToGas initially");
  }

  function testInitialBalanceWithNewRightToGas() public {
    RightToGas meta = new RightToGas();

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 RightToGas initially");
  }

}
