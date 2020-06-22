const Web3 = require('web3'); 
const client = require('node-rest-client-promise').Client();
const INFURA_KEY = "REPLACE_THIS";
const web3 = new Web3('wss://mainnet.infura.io/ws/v3/' + INFURA_KEY);
const CONTRACT_ADDRESS = "0xADDRESS_HERE";
const etherescan_url = `http://api.etherscan.io/api?module=contract&action=getabi&address=${CONTRACT_ADDRESS}&apikey=${ETHERSCAN_API_KEY}`

class Listener {

    constructor() {
        const etherescan_response = await client.getPromise(etherescan_url)
        const CONTRACT_ABI = JSON.parse(etherescan_response.data.result);
        const CONTRACT_ABI = await getContractAbi();
        this.contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);
        // Will move to Redis or Mongo in near future
        this.lockEvents = [];
        this.redemptionEvents = [];
    }

    async lockQuery(contract){
        contract.events.Lock()
        .on('data', (event) => {
            storeData = await parseEvent(event);
            // Add to DB
            this.lockEvents.push(storeData);
        })
        .on('error', console.error);
    }

    async redemptionQuery(contract){
        contract.events.Redemption()
        .on('data', (event) => {
            storeData = await parseEvent(event);
            // Add to DB
            this.redemptionEvents.push(storeData);
        })
        .on('error', console.error);
    }

    async parseEvent(event) {
        // Get identifying fields
        blockData = {
            "transactionHash": event.transactionHash,
            "blockHash": event.blockHash, // Use this when waiting for block confirmations
            "blockNumber": event.blockNumber.num,
            "address": event.address
        }
        // Add the data fields
        storeData = Object.assign(blockData, event.returnValues);
        return storeData;
    }

    async getNBlocks(n) {
        var blocks = [];
        for (var i = 0; i < n; i++) {
            var block = web3.eth.getBlock(web3.eth.blockNumber - i);
            hash = block.hash;
            blocks.push({ hash: block.number });
        }
        return blocks;
    }

    // Process transactions which have at least 10 block confirmations
    async processTx(eventList) {
        past20blocks = await getNBlocks(20);
        for (var i; i < eventList.length; i++) {
            thisEvent = eventList[i];
            if (thisEvent.blockHash in past20blocks) {
                latestBlock = Math.max.apply(Math, past20blocks.map(function(obj) { return Object.values(obj)[0]; }))
                // Check for at least 10 block confirmations
                if (thisEvent.blockNumber < latestBlock - 9) {
                    console.log("Submit this transaction on the second chain.");
                }
            }
        }
    }

    async run() {
        await this.lockQuery(this.contract);
        await this.redemptionQuery(this.contract);
        await this.processTx(this.lockEvents);
        await this.processTx(this.redemptionEvents);
    }

}