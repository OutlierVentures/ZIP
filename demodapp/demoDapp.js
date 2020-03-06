// Requires ETHJS with TestRPC (for no Metamask).
// Based on ETHJS example here: https://github.com/ethjs/examples/blob/master/dapp-wallet.html

var eth = new Eth(TestRPC.provider());
var el = function(id){ return document.querySelector(id); };

// Metamask support
if (typeof window.web3 !== 'undefined' && typeof window.web3.currentProvider !== 'undefined') {
    eth.setProvider(window.web3.currentProvider);
} else {
    eth.setProvider(provider); // set to TestRPC if not available
}

eth.accounts().then(function(accounts){

    var DappBytecode = 'DAPP BYTECODE HERE';
    var DappABI = [{"ABI": "HERE"}];
    var Dapp = eth.contract(DappABI, DappBytecode, { from: accounts[0], gas: 3000000 });
    var dappInstance = null;

    Dapp.new()
    .then(function(txHash){
    var checkTransactionInterval = setInterval(function(){
        eth.getTransactionReceipt(txHash)
        .then(function(receipt){
            if (receipt) {
                clearInterval(checkTransactionInterval);

                dappInstance = Dapp.at(receipt.contractAddress);

                el('#spendBaseTokens').addEventListener('click', function(){
                    el('#spendBaseTokensResponse').style.display = 'block';

                    dappInstance.spendBaseToken()
                    .then(function(success){
                        el('#spendBaseTokensResponse').innerHTML = 'Success!';
                    })
                    .catch(function(error){
                        el('#spendBaseTokensResponse').innerHTML = 'Hmm.. there was an error: ' + String(error);
                    });
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