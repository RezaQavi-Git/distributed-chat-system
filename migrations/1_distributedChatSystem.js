const DistributedChatSystem = artifacts.require("DistributedChatSystem");

module.exports = function(deployer) {
  deployer.deploy(DistributedChatSystem);
};