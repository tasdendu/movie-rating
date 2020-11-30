var MovieRating = artifacts.require('./MovieRating.sol');

module.exports = function (deployer) {
  deployer.deploy(MovieRating);
};
