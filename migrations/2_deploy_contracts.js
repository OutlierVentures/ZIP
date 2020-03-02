const ConvertLib = artifacts.require("ConvertLib");
const Supertoken = artifacts.require("Supertoken");

module.exports = function(deployer) {
  deployer.deploy(Supertoken, "Supertoken", "FUEL", 18);
};
