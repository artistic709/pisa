pragma solidity ^0.4.10; 

contract Adseller {

  struct player {
    address playerAddress; 
    uint tokensBought;    
    uint balanceTokens;
    uint[] involvedAds;
    mapping (uint => uint) involvedAdsBids;
  }

    struct ad{
        uint adID;
        bytes32 adname;
        bytes32 content;
        bytes32 host_url;
        bytes32 img_url;
    }

  mapping (address => player) public playerInfo;
  mapping (uint => uint) public highestBid;
  mapping (uint => address) public highestBidder;

  ad[] public AdList;

  uint public totalTokens; // Total no. of tokens available for this election
  uint public balanceTokens; // Total no. of tokens still available for purchase
  uint public tokenPrice;
  uint public count_ad=0;

  function Adseller(uint tokens, uint pricePerToken) {
    totalTokens = tokens;
    balanceTokens = tokens;
    tokenPrice = pricePerToken;
  }
  
  function addAd(bytes32 adname, bytes32 host_url, 
  bytes32 content, bytes32 img_url) {
      uint adID = AdList.length + 1;
      count_ad ++ ;
      AdList.push(ad({adname:adname, adID:adID,host_url: host_url, content:content, img_url:img_url}));
  }


  function updateAd(uint adID, bytes32 content, bytes32 img_url, bytes32 host_url){
    if (highestBidder[adID] == msg.sender){
      AdList[adID].content = content;
      AdList[adID].img_url = img_url;
      AdList[adID].host_url = host_url;
    }
    else {revert();}
  }


  function bidForAd(uint adID, uint bidInTokens) {
    uint index = adID;
    player thisPlayer = playerInfo[msg.sender];

    // Make sure this player has enough tokens to cast
    
    uint availableTokens = thisPlayer.tokensBought - totalTokensUsed(msg.sender);
    if (availableTokens < bidInTokens) revert();

    if (highestBid[adID] < bidInTokens){
 
        
        bool first_time = true;
        for (uint i=0; i < thisPlayer.involvedAds.length; i++ ){
            if (thisPlayer.involvedAds[i] == adID) 
                {
                    first_time = false;
                    break;
                }
        }
        if (first_time) thisPlayer.involvedAds.push(adID);
        
        
        // payback the previous bidder 
        player previous_bidder =  playerInfo[highestBidder[adID]];
        uint previous_bid = highestBid[adID];
        previous_bidder.balanceTokens += previous_bid;

      
      highestBid[adID] = bidInTokens;
      highestBidder[adID] = thisPlayer.playerAddress;
      thisPlayer.involvedAdsBids[adID] += bidInTokens;
    }
  }

  
  function totalTokensUsed(address user) private constant returns (uint) {
    uint[] _involvedAds = playerInfo[user].involvedAds;
    uint totalUsedTokens = 0;
    for(uint i = 0; i < _involvedAds.length; i++) {
      totalUsedTokens += playerInfo[user].involvedAdsBids[_involvedAds[i]];
    }
    return totalUsedTokens;
  }

  
  function buy() payable returns (uint) {
    uint tokensToBuy = msg.value / tokenPrice;
    if (tokensToBuy > balanceTokens) revert();
    playerInfo[msg.sender].playerAddress = msg.sender;
    playerInfo[msg.sender].tokensBought += tokensToBuy;
    playerInfo[msg.sender].balanceTokens += tokensToBuy;
    
    balanceTokens -= tokensToBuy;
    return tokensToBuy;
  }

  function tokensSold() constant returns (uint) {
    return totalTokens - balanceTokens;
  }

  function voterDetails(address userAdr) constant returns (uint, uint[]) {
    return (playerInfo[userAdr].tokensBought, playerInfo[userAdr].involvedAds);
  }

  function transferTo(address account) {
    account.transfer(this.balance);
  }
  
  function allCandidates() constant returns (bytes32[]) {
    bytes32[] Adnamelist;
    for(uint i =0; i< AdList.length;i++){
      Adnamelist.push(AdList[i].adname);
    }
    return Adnamelist;
  }

  function highestBidFor(uint adID) constant returns (uint) {
    return highestBid[adID];
  }

  function highestBidderFor(uint adID) constant returns (address) {
    return highestBidder[adID];
  }
}
