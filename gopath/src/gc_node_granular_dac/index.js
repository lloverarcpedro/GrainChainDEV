"use strict";

const truckContract = require('./contract/truck-contract').truckContract;
const futureContract = require('./contract/future-contract').futureContract;

module.exports.truckContract = truckContract;
module.exports.futureContract = futureContract;


module.exports.contracts = [truckContract, futureContract];
