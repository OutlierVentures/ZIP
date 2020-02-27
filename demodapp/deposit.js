if (typeof window.web3 !== 'undefined' && typeof window.web3.currentProvider !== 'undefined') {
    eth.setProvider(window.web3.currentProvider);
} else {
    eth.setProvider(provider); // set to TestRPC if not available
}
 