// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SocialMedia {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target; 
        uint256 deadline;
        uint256 amountCollected; 
        string image; 
        address[] donators; 
        uint256[] donations; 
        uint256 likes;
    }
    mapping(uint256 => Campaign) public campaigns; 
    uint256 public numberOfCampaigns = 0; 
    
    struct Post{
        address owner;
        string content; 
        string image; 
        uint256 likes; 
    }
    mapping(uint256 => Post) public posts;
    uint256 public numberOfPosts = 0; 

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns(uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");
        campaign.owner = _owner;
        campaign.title = _title; 
        campaign.description = _description;
        campaign.target = _target; 
        campaign.deadline = _deadline; 
        campaign.amountCollected = 0; 
        campaign.image = _image; 
        campaign.likes = 0;

        numberOfCampaigns++;

        return numberOfCampaigns-1; 
    } 

    function createPost( address _owner, string memory _content, string memory _image, uint256 _likes) public returns(uint256) {
        Post storage post = posts[numberOfPosts];

        require(bytes(_content).length!= 0, "There should be some textual content to be posted.");
        post.owner = _owner; 
        post.content = _content;
        post.image = _image;
        post.likes = _likes;

        numberOfPosts++;
        return numberOfPosts;
    }

    function donatoToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value; // how do we get msg
        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if(sent){
            campaign.amountCollected += amount; 
        }
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() view public returns (Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i=0; i<numberOfCampaigns; i++){
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item; 
        }
        
        return allCampaigns;
    }

}