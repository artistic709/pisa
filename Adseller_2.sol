pragma solidity ^0.4.10; //We have to specify what version of the compiler this code will use

contract Adseller {

  // We use the struct datatype to store the voter information.
  struct player {
    address playerAddress; 
    uint tokensBought;    
    uint balanceTokens;

    bytes32[] involvedAds;
    mapping (bytes32 => uint) involvedAdsBids;
  }

    struct ad{
        bytes32 adname;
        bytes32 content;
    }

  mapping (address => player) public playerInfo;
  mapping (bytes32 => uint) public highestBid;
  mapping (bytes32 => address) public highestBidder;

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
  
  function addAd(bytes32 adname, bytes32 content){
      for(uint i = 0; i < AdList.length; i++) {
          if (AdList[i].adname == adname) revert();
      }
      count_ad ++ ;
      AdList.push(ad({adname: adname, content:content}));
  }


  function bidForAd(bytes32 adID, uint bidInTokens) {
    uint index = indexOfAd(adID);
    player thisPlayer = playerInfo[msg.sender];
    if (index == uint(-1)) revert();

    // Make sure this player has enough tokens to cast the vote
    
    uint availableTokens = thisPlayer.tokensBought - totalTokensUsed(msg.sender);
    if (availableTokens < bidInTokens) revert();

    if (highestBid[adID] < bidInTokens){
        // able to bid
        
        bool first_time = true;
        for (uint i=0; i < thisPlayer.involvedAds.length; i++ ){
            if (thisPlayer.involvedAds[i] == adID) first_time=false;
        }
        if (first_time) thisPlayer.involvedAds.push(adID);

      highestBid[adID] = bidInTokens;
      highestBidder[adID] = thisPlayer.playerAddress;
      thisPlayer.involvedAdsBids[adID] += bidInTokens;
    }
  }

  // Return the sum of all the tokens used by this player.
  function totalTokensUsed(address user) private constant returns (uint) {
    bytes32[] _involvedAds = playerInfo[user].involvedAds;
    uint totalUsedTokens = 0;
    for(uint i = 0; i < _involvedAds.length; i++) {
      totalUsedTokens += playerInfo[user].involvedAdsBids[_involvedAds[i]];
    }
    return totalUsedTokens;
  }
  

  function indexOfAd(bytes32 adID) constant returns (uint) {
    for(uint i = 0; i < AdList.length; i++) {
      if (AdList[i].adname == adID) {
        return i;
      }
    }
    return uint(-1);
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

  function voterDetails(address userAdr) constant returns (uint, bytes32[]) {
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

  function highestBidFor(bytes32 adID) constant returns (uint) {
    return highestBid[adID];
  }

  function highestBidderFor(bytes32 adID) constant returns (address) {
    return highestBidder[adID];
  }
}
