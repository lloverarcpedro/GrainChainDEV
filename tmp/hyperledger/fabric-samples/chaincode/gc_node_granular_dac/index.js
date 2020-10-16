"use strict";

const truckContract = require('./contract/truck-contract').truckContract;

module.exports.truckContract = truckContract;


module.exports.contracts = [ truckContract ];
