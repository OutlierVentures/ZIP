const ConvertLib = artifacts.require("ConvertLib");
const ZIP = artifacts.require("ZIP");

module.exports = function(deployer) {
  deployer.deploy(ZIP, "ZIP", "ZIP", 18);
};
