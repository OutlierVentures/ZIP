// Requires ETHJS with TestRPC (for no Metamask).
// Based on ETHJS example here: https://github.com/ethjs/examples/blob/master/token-wallet.html

var eth = new Eth(TestRPC.provider());
var el = function(id){ return document.querySelector(id); };

// Metamask support
if (typeof window.web3 !== 'undefined' && typeof window.web3.currentProvider !== 'undefined') {
    eth.setProvider(window.web3.currentProvider);
} else {
    eth.setProvider(provider); // set to TestRPC if not available
}

eth.accounts().then(function(accounts){
    el('#accountAddress').innerHTML = accounts[0];

    var TokenBytecode = 'TOKEN BYTECODE HERE';
    var TokenABI = [{"ABI": "HERE"}];
    var Token = eth.contract(TokenABI, TokenBytecode, { from: accounts[0], gas: 3000000 });
    var tokenInstance = null;

    var initialAmount = 100000000;
    var tokenName = 'ZIP';
    var decimalUnits = 1000;
    var tokenSymbol = 'ZIP';

    function updateBalanceHTML() {
        if(!tokenInstance) { return; }

        tokenInstance.balanceOf(accounts[0]).then(function(tokenBalance){
            el('#tokenBalance').innerHTML = tokenBalance[0].toString(10);
        });
        }

        Token.new(initialAmount, tokenName, decimalUnits, tokenSymbol)
        .then(function(txHash){
        var checkTransactionInterval = setInterval(function(){
            eth.getTransactionReceipt(txHash)
            .then(function(receipt){
                if (receipt) {
                    clearInterval(checkTransactionInterval);

                    tokenInstance = Token.at(receipt.contractAddress);

                    updateBalanceHTML();

                    el('#balanceOf').addEventListener('click', function(){
                        el('#balanceResponse').style.display = 'block';

                        tokenInstance.balanceOf(el('#balanceAddress').value)
                        .then(function(tokenBalance){
                            el('#balanceResponse').innerHTML = 'Token balance is: ' + tokenBalance[0].toNumber(10);
                        })
                        .catch(function(balanceError){
                            el('#balanceResponse').innerHTML = 'Hmm.. there was an error: ' + String(balanceError);
                        });
                    });

                    el('#transferTokens').addEventListener('click', function(){
                        el('#transferResponse').style.display = 'block';

                        tokenInstance.transfer(el('#transferAddress').value, el('#transferAmount').value)
                        .then(function(transferTxHash) {
                            el('#transferResponse').innerHTML = 'Transfering tokens with transaction hash: ' + String(transferTxHash);
                        })
                        .catch(function(transferError) {
                            el('#transferResponse').innerHTML = 'Hmm.. there was an error: ' + String(transferError);
                        });
                    });

                    tokenInstance.symbol().then(function(tokenSymbol){
                        el('.tokenSymbol').innerHTML = tokenSymbol[0];
                    });

                    tokenInstance.name().then(function(tokenName){
                        el('#tokenName').innerHTML = tokenName[0];
                    });
                }
            })
            .catch(function(deploymentError){
                el('#response').innerHTML = 'Hmm.. there was an error: ' + String(deploymentError);
            });
        }, 400);
    })
    .catch(function(deploymentError){
    el('#response').innerHTML = 'Hmm.. there was an error: ' + String(deploymentError);
    });
});