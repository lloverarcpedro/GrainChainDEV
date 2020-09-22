"use strict";
const { Contract } = require("fabric-contract-api");

class grainContract extends Contract {
  async addContract(ctx,contractId, buyerId, maxWeight, commodityId) {
    let contract = {
      contractId: contractId,
      buyerId: buyerId,
      maxWeight: maxWeight,
      commodityId : commodityId
    };

    await ctx.stub.putState(contractId, Buffer.from(JSON.stringify(contract)));
    console.log("Truck added To the ledger Succesfully..");
  }

  async getContract(ctx, contractId) {
    let contractAsBytes = await ctx.stub.getState(contractId);
    if (!contractAsBytes || contractAsBytes.toString().length <= 0) {
      throw new Error("contract with this Id does not exist: ");
    }
    let contract = JSON.parse(contractAsBytes.toString());

    return JSON.stringify(contract);
  }
}

module.exports.grainContract = grainContract;
