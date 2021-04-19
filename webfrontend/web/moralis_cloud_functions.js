Moralis.Cloud.define("getUserItems", async (request) => {
    const query = new Moralis.Query("EthNFTTokenOwners");
    query.equalTo("contract_type", "ERC721");
    query.containedIn("owner_of", request.user.attributes.accounts);
    const queryresults = await query.find();
    const results = [];
    
    for (let i = 0; i < queryresults.length; ++i) {
      results.push({
          "id": queryresults[i].attributes.objectId,
            "tokenId": queryresults[i].attributes.token_id,
          "tokenAddress": queryresults[i].attributes.token_address,
          "symbol": queryresults[i].attributes.symbol,
          "tokenuri": queryresults[i].attributes.token_uri,
      })
    }
    return results;
  });