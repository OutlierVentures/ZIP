const ConvertLib = artifacts.require("ConvertLib");
const FUEL = artifacts.require("FUEL");

module.exports = function(deployer) {
  deployer.deploy(FUEL, "FUEL", "FUEL", 18);
};
