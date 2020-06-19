const Web3 = require('web3'); 
const client = require('node-rest-client-promise').Client();
const INFURA_KEY = "SECRET_INFURA_KEY"; // Insert your own key here :)
const ETHERSCAN_API_KEY = "SECRET_ETHERSCAN_KEY";
const web3 = new Web3('wss://mainnet.infura.io/ws/v3/'  +  INFURA_KEY);
const CONTRACT_ADDRESS = "0xADDRESSHERE";
const etherescan_url = `http://api.etherscan.io/api?module=contract&action=getabi&address=${CONTRACT_ADDRESS}&apikey=${ETHERSCAN_API_KEY}`

async function getContractAbi() {
    const etherescan_response = await client.getPromise(etherescan_url)
    const CONTRACT_ABI = JSON.parse(etherescan_response.data.result);
    return CONTRACT_ABI;
}

async function eventQuery(){
    const CONTRACT_ABI = getContractAbi();
    const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);
}

eventQuery();
