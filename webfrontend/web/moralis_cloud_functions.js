Moralis.Cloud.beforeSave("ItemsForSale", async (request) => {
  const query = new Moralis.Query("EthNFTOwners");
  query.equalTo("token_id", request.object.get('tokenId'));
  query.equalTo("token_address", '0x289b7ccb04d4b666bb92b272c758d6dcad47e0f2');
  const object = await query.first();

  const creatorquery = new Moralis.Query("Item");
  creatorquery.equalTo("tokenId", request.object.get('tokenId'));
  const objectItem = await creatorquery.first();

  if (object) {
    const owner = object.attributes.owner_of;
    const userquery = new Moralis.Query(Moralis.User);
    userquery.equalTo("accounts", owner);
    const userobject = await userquery.first({ useMasterKey: true });
    if (userobject) {
      request.object.set('user', userobject);
    }
    request.object.set('token', object);
    request.object.set('creator', objectItem.attributes.creator);
  }
});

Moralis.Cloud.beforeSave("EthNFTOwners", async (request) => {
  const query = new Moralis.Query("Item");
  query.equalTo("tokenId", request.object.get('token_id'));
  const object = await query.first();
  request.object.set("creator", object.attributes.creator);
});

Moralis.Cloud.beforeSave("ItemsForAuction", async (request) => {
  const query = new Moralis.Query("EthNFTOwners");
  query.equalTo("token_id", request.object.get('tokenId'));
  query.equalTo("token_address", '0x289B7CCB04d4B666bB92B272C758D6dCad47E0F2'.toLowerCase());
  const object = await query.first();

  const creatorquery = new Moralis.Query("Item");
  creatorquery.equalTo("tokenId", request.object.get('tokenId'));
  const objectItem = await creatorquery.first();

  if (object) {
    const owner = object.attributes.owner_of;
    const userquery = new Moralis.Query(Moralis.User);
    userquery.equalTo("accounts", owner);
    const userobject = await userquery.first({ useMasterKey: true });
    if (userobject) {
      request.object.set('user', userobject);
    }
    request.object.set('token', object);
    request.object.set('creator', objectItem.attributes.creator);
  }
});

Moralis.Cloud.beforeSave("SoldItems", async (request) => {
  const saleQuery = new Moralis.Query("ItemsForSale");
  saleQuery.equalTo("uid", request.object.get('uid'));
  const saleItem = await saleQuery.first();
  const creatorquery = new Moralis.Query("Item");
  creatorquery.equalTo("tokenId", request.object.get('tokenId'));
  const objectItem = await creatorquery.first();

  if (saleItem) {
    request.object.set('itemSale', saleItem);
    saleItem.set('isSold', true);
    await saleItem.save();

    const userquery = new Moralis.Query(Moralis.User);
    userquery.equalTo("accounts", request.object.get('buyer'));
    const userobject = await userquery.first({ useMasterKey: true });
    if (userobject) {
      request.object.set('user', userobject);
      request.object.set('creator', objectItem.attributes.creator);
    }
  }
});

Moralis.Cloud.beforeSave("SoldItems", async (request) => {
  const auctionQuery = new Moralis.Query("ItemsForAuction");
  auctionQuery.equalTo("uid", request.object.get('uid'));
  const auctionItem = await auctionQuery.first();
  const creatorquery = new Moralis.Query("Item");
  creatorquery.equalTo("tokenId", request.object.get('tokenId'));
  const objectItem = await creatorquery.first();

  console.log(auctionItem);

  if (auctionItem) {
    request.object.set('itemAuction', auctionItem);
    auctionItem.set('isSold', true);
    await auctionItem.save();

    const userquery = new Moralis.Query(Moralis.User);
    userquery.equalTo("accounts", request.object.get('buyer'));
    const userobject = await userquery.first({ useMasterKey: true });
    if (userobject) {
      request.object.set('user', userobject);
      request.object.set('creator', objectItem.attributes.creator);
    }
  }
});

Moralis.Cloud.define("getItemsForSale", async (request) => {
  const query = new Moralis.Query("ItemsForSale");
  query.notEqualTo("isSold", true);

  query.select("uid", "tokenId", "price", "token.token_uri", "token.symbol", "token.owner_of", "user.username", "user.avatar", "creator.username", "creator.avatar");
  const queryresults = await query.find({ useMasterKey: true });
  const results = [];

  for (let i = 0; i < queryresults.length; ++i) {
    if (queryresults[i].attributes.user && queryresults[i].attributes.user != undefined) {
      results.push({
        "uid": queryresults[i].attributes.uid,
        "tokenId": queryresults[i].attributes.tokenId,
        "price": queryresults[i].attributes.price,
        "symbol": queryresults[i].attributes.token.attributes.symbol,
        "tokenuri": queryresults[i].attributes.token.attributes.token_uri,
        "ownerOf": queryresults[i].attributes.token.attributes.owner_of,
        "userName": queryresults[i].attributes.user.attributes.username,
        "userAvatar": queryresults[i].attributes.user.attributes.avatar,
        "creatorName": queryresults[i].attributes.creator.attributes.username,
        "creatorAvatar": queryresults[i].attributes.creator.attributes.avatar,
      })
    }
  }

  return results;
});

Moralis.Cloud.define("getItemsForAuction", async (request) => {
  const query = new Moralis.Query("ItemsForAuction");
  query.notEqualTo("isSold", true);

  query.select("uid", "tokenId", "ending", "highestBid", "highestBidder", "token.token_uri", "token.symbol", "token.owner_of", "user.username", "user.avatar", "creator.username", "creator.avatar");
  const queryresults = await query.find({ useMasterKey: true });
  const results = [];

  for (let i = 0; i < queryresults.length; ++i) {

    if (queryresults[i].attributes.user && queryresults[i].attributes.user != undefined) {
      results.push({
        "uid": queryresults[i].attributes.uid,
        "tokenId": queryresults[i].attributes.tokenId,
        "ending": queryresults[i].attributes.ending,
        "highestBid": queryresults[i].attributes.highestBid,
        "highestBidder": queryresults[i].attributes.highestBidder,
        "symbol": queryresults[i].attributes.token.attributes.symbol,
        "tokenuri": queryresults[i].attributes.token.attributes.token_uri,
        "ownerOf": queryresults[i].attributes.token.attributes.owner_of,
        "userName": queryresults[i].attributes.user.attributes.username,
        "userAvatar": queryresults[i].attributes.user.attributes.avatar,
        "creatorName": queryresults[i].attributes.creator.attributes.username,
        "creatorAvatar": queryresults[i].attributes.creator.attributes.avatar,
      })
    }
  }

  return results;
});

Moralis.Cloud.define("getItem", async (request) => {
  const query = new Moralis.Query("ItemsForSale");
  query.equalTo("tokenId", request.params.tokenId);

  query.select("uid", "tokenId", "price", "token.token_uri", "token.symbol", "token.owner_of", "user.username");
  const queryresult = await query.first({ useMasterKey: true });
  if (!queryresult) return;

  return {
    "uid": queryresult.attributes.uid,
    "tokenId": queryresult.attributes.tokenId,
    "price": queryresult.attributes.price,
    "symbol": queryresult.attributes.token.attributes.symbol,
    "tokenuri": queryresult.attributes.token.attributes.token_uri,
    "ownerOf": queryresult.attributes.token.attributes.owner_of,
    "userName": queryresult.attributes.user.attributes.username,
  };
});

Moralis.Cloud.define("getSoldItems", async (request) => {
  const query = new Moralis.Query("SoldItems");
  query.select("tokenId", "price", "creator.username", "creator.avatar");
  const queryresults = await query.find({ useMasterKey: true });
  const results = [];
  if (!queryresults) return;
  for(let i = 0; i < queryresults.length; ++i) {
  	results.push({
    "tokenId": queryresults[i].attributes.tokenId,
    "price": queryresults[i].attributes.price,
    "creatorName": queryresults[i].attributes.creator.attributes.username,
    "creatorAvatar": queryresults[i].attributes.creator.attributes.avatar,
    })
  }
 return results;
});

Moralis.Cloud.define("getUserItems", async (request) => {
  const query = new Moralis.Query("EthNFTOwners");
  query.select("token_id", "token_uri", "creator.username", "creator.avatar");
  query.equalTo("owner_of", request.params.address);
  query.equalTo("token_address", "0x289B7CCB04d4B666bB92B272C758D6dCad47E0F2".toLowerCase());
  const queryresults = await query.find({ useMasterKey: true });
  const results = [];
  if (!queryresults) return;
  for(let i = 0; i < queryresults.length; ++i) {
  	results.push({
    "tokenId": queryresults[i].attributes.token_id,
    "tokenUri": queryresults[i].attributes.token_uri,
    "creatorName": queryresults[i].attributes.creator.attributes.username,
    "creatorAvatar": queryresults[i].attributes.creator.attributes.avatar,
    })
  }
 return results;
});