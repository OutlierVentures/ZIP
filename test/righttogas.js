const RightToGas = artifacts.require("RightToGas");

contract('RightToGas', function(accounts) {
  it("should put 10000 RightToGas in the first account", function() {
    return RightToGas.deployed().then(function(instance) {
      return instance.getBalance.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
    });
  });
  it("should call a function that depends on a linked library", function() {
    var rtg;
    var rightToGasBalance;
    var rightToGasEthBalance;

    return RightToGas.deployed().then(function(instance) {
      rtg = instance;
      return rtg.getBalance.call(accounts[0]);
    }).then(function(outCoinBalance) {
      rightToGasBalance = parseInt(outCoinBalance);
      return rtg.getBalanceInEth.call(accounts[0]);
    }).then(function(outCoinBalanceEth) {
      rightToGasEthBalance = parseInt(outCoinBalanceEth);
    }).then(function() {
      assert.equal(rightToGasEthBalance, 2 * rightToGasBalance, "Library function returned unexpected function, linkage may be broken");
    });
  });
  it("should send coin correctly", function() {
    var rtg;

    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var amount = 10;

    return RightToGas.deployed().then(function(instance) {
      rtg = instance;
      return rtg.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = parseInt(balance);
      return rtg.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = parseInt(balance);
      return rtg.sendCoin(account_two, amount, {from: account_one});
    }).then(function() {
      return rtg.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = parseInt(balance);
      return rtg.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = parseInt(balance);

      assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
      assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
    });
  });
});

