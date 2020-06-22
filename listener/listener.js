const Web3 = require('web3'); 
const client = require('node-rest-client-promise').Client();
const INFURA_KEY = "REPLACE_THIS";
const web3 = new Web3('wss://mainnet.infura.io/ws/v3/' + INFURA_KEY);
const CONTRACT_ADDRESS = "0xADDRESS_HERE";
const etherescan_url = `http://api.etherscan.io/api?module=contract&action=getabi&address=${CONTRACT_ADDRESS}&apikey=${ETHERSCAN_API_KEY}`

// Will move to Redis or Mongo in near future
var lockEvents = [];
var redemptionEvents = [];

async function getContractAbi() {
    const etherescan_response = await client.getPromise(etherescan_url)
    const CONTRACT_ABI = JSON.parse(etherescan_response.data.result);
    return CONTRACT_ABI;
}

async function lockQuery(){
    const CONTRACT_ABI = getContractAbi();
    const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);
    contract.events.Lock()
    .on('data', (event) => {
        // Get idenitfying fields
        blockData = {
            "transactionHash": event.transactionHash,
            "blockNumber": event.blockNumber.num,
            "address": event.address
        }
        // Add the data fields
        storeData = Object.assign(blockData, event.returnValues);
        // Add to DB
        lockEvents.push(storeData);
    })
    .on('error', console.error);
}

async function redemptionQuery(){
    const CONTRACT_ABI = getContractAbi();
    const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);
    contract.events.Redemption()
    .on('data', (event) => {
        // Get idenitfying fields
        blockData = {
            "transactionHash": event.transactionHash,
            "blockNumber": event.blockNumber.num,
            "address": event.address
        }
        // Add the data fields
        storeData = Object.assign(blockData, event.returnValues);
        // Add to DB
        lockEvents.push(storeData);
    })
    .on('error', console.error);
}

lockQuery();
redemptionQuery();
