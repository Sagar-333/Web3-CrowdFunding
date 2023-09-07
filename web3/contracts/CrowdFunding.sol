// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image; // our image is string because we are going to give URL
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampings=0;
    
    //memory is a keyword used to store data for the execution of a contract. It holds functions argument data and is wiped after execution.
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image ) public returns (uint256)  {        
        Campaign storage campaign = campaigns[numberOfCampings];

        //used to check is everything ok
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.deadline = _deadline;
        campaign.target = _target;
        campaign.image = _image;
        campaign.amountCollected=0;

        numberOfCampings++;

        return numberOfCampings - 1;
    }

    //payable is a keyword used to specify that we are going to send some crypto
    function donateToCampaign(uint256 _id) public payable{
        uint256 amount = msg.value;  // this is what we will send from our frontend

        Campaign storage campaign = campaigns[_id]; // id of campaign to access it 

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        // we have used a , because payable returns 2 values and we have to let solidity know that it has to expcept another value over there
        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent){ 
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns(address[] memory, uint256[] memory){
        return(campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampings);

        for (uint256 i = 0; i < numberOfCampings; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }
        return allCampaigns;
    }
}