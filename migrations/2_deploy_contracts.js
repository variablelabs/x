var xToken = artifacts.require("./xToken.sol");

module.exports = function(deployer) {
  deployer.deploy(xToken, 1000000);
};
