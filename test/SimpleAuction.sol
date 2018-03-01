pragma solidity ^0.4.0;

contract SimpleAuction {

    address public beneficiary;
    uint public auctionEnd;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) pendingReturns;

    bool ended;

    event HeghestBidIncreased(adress bidder, uint amount);
    event AuctionEnded(adress winner, uint amount);


    function SimpleAuction(uint _biddingTime, adress _beneficiary) public {
        beneficiary = _beneficiary;
        auctionEnd = now + _biddingTime;
    }

    function bid() public payable {
        require(now <= auctionEnd);
        require(msg.value > highestBid);

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if(amount > 0){
            pendingReturns[msg.sender] = 0;
            if (!msg.sender.send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() public {
        //conditions
        require(now >= auctionEnd);
        require(!ended);

        //Effects
        ended = true;
        AuctionEnded(highestBidder, highestBid);

        //Interaction
        beneficiary.transfer(highestBid);
    }
}
