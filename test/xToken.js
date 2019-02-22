var xToken = artifacts.require("./xToken.sol");

contract('xToken', function(accounts){
    it('sets the total supply upon deplyoment', function(){
        return xToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.totalSupply();
        }).then(function(totalSupply){
            assert.equal(totalSupply.toNumber(), 1000000, 'sets the total supply to 100000');
        })
    })
})