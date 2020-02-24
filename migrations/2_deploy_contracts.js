const ConvertLib = artifacts.require("ConvertLib");
const Supertoken = artifacts.require("Supertoken");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, Supertoken);
  deployer.deploy(Supertoken);
};
