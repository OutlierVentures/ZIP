const Supertoken = artifacts.require("Supertoken");

contract('Supertoken', function(accounts) {
  it("should put 10000 Supertoken in the first account", function() {
    return Supertoken.deployed().then(function(instance) {
      return instance.getBalance.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
    });
  });
  it("should call a function that depends on a linked library", function() {
    var sup;
    var supertokenBalance;
    var supertokenEthBalance;

    return Supertoken.deployed().then(function(instance) {
      sup = instance;
      return sup.getBalance.call(accounts[0]);
    }).then(function(outCoinBalance) {
      supertokenBalance = parseInt(outCoinBalance);
      return sup.getBalanceInEth.call(accounts[0]);
    }).then(function(outCoinBalanceEth) {
      supertokenEthBalance = parseInt(outCoinBalanceEth);
    }).then(function() {
      assert.equal(supertokenEthBalance, 2 * supertokenBalance, "Library function returned unexpected function, linkage may be broken");
    });
  });
  it("should send coin correctly", function() {
    var sup;

    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var amount = 10;

    return Supertoken.deployed().then(function(instance) {
      sup = instance;
      return sup.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = parseInt(balance);
      return sup.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = parseInt(balance);
      return sup.sendCoin(account_two, amount, {from: account_one});
    }).then(function() {
      return sup.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = parseInt(balance);
      return sup.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = parseInt(balance);

      assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
      assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
    });
  });
});

