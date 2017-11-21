pragma solidity ^0.4.15;

contract adseller {
    address private owner;
    
    mapping (address => uint256) public bidDueTime;
    mapping (address => uint) public marginRatio;
    mapping (address => string) public currentAdContent;
    mapping (address => address) private currentAdOwner;
    mapping (address => uint256) private currentAdValue;
    mapping (address => string)  private nextAdContent;
    mapping (address => address) private nextAdOwner;
    mapping (address => uint256) public highestBid;
    mapping (address => uint256) public revenue;
    mapping (address => bool) public registered;
    
    function adseller(){
        owner=msg.sender;
    }
    
    function register(){
        address this_user = msg.sender;
        bidDueTime[this_user] = now + 1 weeks;
        registered[this_user] = true;
    }
    
    function gotoNext(address ad_id) returns(bool success){
        if(bidDueTime[ad_id] > now){
            return false;
        }
        else{
            bidDueTime[ad_id] += 1 weeks;
            address redeemaddress = currentAdOwner[ad_id];
            uint256 redeemvalue = marginRatio[ad_id]*currentAdValue[ad_id]/(marginRatio[ad_id]+1);
            uint256 revenue_value = currentAdValue[ad_id] - redeemvalue;
            currentAdValue[ad_id] = highestBid[ad_id];
            currentAdContent[ad_id] = nextAdContent[ad_id];
            currentAdOwner[ad_id] = nextAdOwner[ad_id];
            nextAdContent[ad_id] = "-";
            nextAdOwner[ad_id] = 0x0;
            highestBid[ad_id] = 0;
            
            revenue[ad_id] += revenue_value;
            redeemaddress.transfer(redeemvalue);
            return true;
        }
    }
    
    function bid(string ad_content, address ad_id) payable returns(bool success){
        require(registered[ad_id]==true);
        if(bidDueTime[ad_id] < now){
            gotoNext(ad_id);
        }
        if(msg.value*105<=100*highestBid[ad_id]){
            revert();
            return false;
        }
        else{
            address redeemaddress = nextAdOwner[ad_id];
            uint256 redeemvalue = highestBid[ad_id];
            nextAdContent[ad_id] = ad_content;
            nextAdOwner[ad_id] = msg.sender;
            highestBid[ad_id] = msg.value;

            if(redeemaddress!=0x0)
                redeemaddress.transfer(redeemvalue);
            return true;
        }
    }
    
    function judge(address ad_id) returns(bool success){
        require(msg.sender==owner);
        
        uint256 revenue_value = currentAdValue[ad_id];
        currentAdValue[ad_id] = 0;
        currentAdContent[ad_id] = "-";
        currentAdOwner[ad_id] = 0x0;
        
        revenue[ad_id] += revenue_value;
        
        return true;
    }
    
    function collect() returns(bool success){
        msg.sender.transfer(revenue[msg.sender]);
        return true;
    }
    
    function setRatio(uint newRatio) returns(bool success){
        marginRatio[msg.sender] = newRatio;
        return true;
    }
}