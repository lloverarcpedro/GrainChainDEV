"use strict";

const truckContract = require('./contract/truck-contract').truckContract;
const grainContract = require('./contract/grain-contract').grainContract;

module.exports.grainContract = grainContract;
module.exports.truckContract = truckContract;

module.exports.contracts = [truckContract, grainContract];
