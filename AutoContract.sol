// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.13;

contract AutoContract{
    address public owner;
    address public buyer;
    address public dmv;
    address public courier;

    bool isMatch = false;
    uint256 buyerPrice;


    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier onlyBuyer(){
        require(msg.sender == buyer);
        _;
    }

    modifier canView(){
        require(isMatch == true);
        require(msg.sender == buyer);
        _;
    }

    modifier onlyDmv(){
        require(msg.sender == dmv);
        _;
    }

    struct carInfo{
        string model;
        string mileage;
        string vin;
        uint price;
        uint year;
        string insurance;
    }

    struct ownerInfo{
        string name;
    }

    struct buyerInfo{
        string name;
        address addr;
    }

    carInfo public carinfo;
    carInfo[] public car;

    ownerInfo public ownerinfo;
    ownerInfo[] public owners;

    buyerInfo public buyerinfo;
    buyerInfo[] public buyers;

    //event trigger when every owner registered
    event OwnerRegister(string name);

    //event trigger when every buyer registered
    event BuyerRegister(string name, address addr);

    //event trigger when every owner list their vehicle
    event VehicleList(string model, string mileage, string vin, uint price, uint year, string insurance);

    //event trigger when a buyer send a bid
    event SendBid(uint256 buyerPrice);

    //event trigger when the ownership of the vehicles has transferred
    event Transfer(string name);

    //event trigger when the insurance id is transferred or terminated 
    event Insurance(string insurance);

    //event trigger when delivering order
    event OrderDeliver(address addr);

    //this function is for owner to register an account
    function ownerRegister(string memory _name) public {
        ownerInfo storage _ownerinfo = owners[0];
        _ownerinfo.name = _name;

        emit OwnerRegister(_ownerinfo.name);
    }

    //this function is for buyer to register an account
    function buyerRegister(string memory _name, address _addr) public {
        buyerInfo storage _buyerinfo = buyers[0];
        _buyerinfo.name = _name;
        _buyerinfo.addr = _addr;

        emit BuyerRegister(_buyerinfo.name, _buyerinfo.addr);
        
    }

    //this function is to list the vehicle on the platform 
    //only owners can use this function
    //owners need to input the mileage, price, year of release, and vin number 
    function list (string memory _model, string memory _mileage, string memory _vin, uint _price, uint _year, string memory _insurance) public onlyOwner{
        carInfo storage _carinfo = car[0];
        _carinfo.model = _model;
        _carinfo.mileage = _mileage;
        _carinfo.vin = _vin;
        _carinfo.price = _price;
        _carinfo.year = _year;
        _carinfo.insurance = _insurance;

        emit VehicleList(_carinfo.model, _carinfo.mileage, _carinfo.vin, _carinfo.price, _carinfo.year, _carinfo.insurance);

    }

    //this function is to verify the vin number that buyers input
    //if the vin number has a match
    //buyers can view the documents
    //only buyers can use this function
    function verify(string memory _inputVin) public view returns (bool){
        return (keccak256(abi.encodePacked((_inputVin))) == keccak256(abi.encodePacked((carinfo.vin))));

    }

    //this function is to send bid to owners
    function sendBid(uint256 _buyerPrice) public {
        buyerPrice = _buyerPrice;

        emit SendBid(buyerPrice);
    }

    //this function is to transfer ownership
    function transfer() public {
        emit Transfer(buyerinfo.name);
    }

    //this function is to transfer / terminate insurance id
    function transferId() public{
        emit Insurance(carinfo.insurance);
    }
    //this function is to deliver the vehicles
    function deliver() public {
        require(msg.sender == courier);

        emit OrderDeliver(buyerinfo.addr);
    }
}
