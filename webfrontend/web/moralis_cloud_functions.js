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


Moralis.Cloud.beforeSave("ItemsForSale", async (request) => {
  const query = new Moralis.Query("EthNFTTokenOwners");
  //query.equalTo("token_address", request.object.get('');
  query.equalTo("tokenId", request.object.get('token_Id'));
  const object = await query.first();
  if (object) {
    const owner = object.attributes.owner_of;
    const userquery = new Moralis.Query(Moralis.User);
    userquery.equalTo("accounts", owner);
    const userobject = await userquery.first({ useMasterKey: true });
    if (userobject) {
      request.object.set('user', userobject);
    }
    request.object.set('token', object);
  }
});

Moralis.Cloud.beforeSave("SoldItems", async (request) => {
  const query = new Moralis.Query("ItemsForSale");
  //query.equalTo("token_address", request.object.get('');
  query.equalTo("uid", request.object.get('uid'));
  const item = await query.first();
  if (item) {
    request.object.set('item', item);
    item.set('isSold', true);
    await item.save();


    const userquery = new Moralis.Query(Moralis.User);
    userquery.equalTo("accounts", request.object.get('buyer'));
    const userobject = await userquery.first({ useMasterKey: true });
    if (userobject) {
      request.object.set('user', userobject);
    }
  }
});

Moralis.Cloud.define("getItems", async (request) => {
  const query = new Moralis.Query("ItemsForSale");
  query.notEqualTo("isSold", true);

  if (request.user) {
    query.notContainedIn("token.owner_of", request.user.attributes.accounts);
  }

  query.select("uid", "tokenId", "price", "token.token_uri", "token.symbol", "token.owner_of", "user.username");
  const queryresults = await query.find({ useMasterKey: true });
  const results = [];

  for (let i = 0; i < queryresults.length; ++i) {
    results.push({
      "uid": queryresults[i].attributes.uid,
      "tokenId": queryresults[i].attributes.token_id,
      "tokenAddress": queryresults[i].attributes.token_address,
      "price": queryresults[i].attributes.price,
      "symbol": queryresults[i].attributes.token.attributes.symbol,
      "tokenuri": queryresults[i].attributes.token.attributes.token_uri,
      "ownerOf": queryresults[i].attributes.token.attributes.owner_of,
      "userName": queryresults[i].attributes.user.attributes.username,
    })
  }
  return results;
});