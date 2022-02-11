// SPDX-License-Identifier:YOGESH
pragma solidity 0.8.11;

contract bank {

    address owner;
    uint bank_funds;
    uint fees;
    string [] AllUsers;

    mapping(address => user) public Users;

    struct user {
        string name;
        uint256 balance;
        bool exists;
    }

    modifier only_owner(){
        require( msg.sender == owner);
        
       _;
    }

    modifier balance_check(uint _amount){
        require(_amount > 0 && _amount <= Users[msg.sender].balance);
        _;
    }

    modifier existing_user( address _add){
        require(Users[_add].exists,"Not An existing user");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function collect_fees(address payable _receiver) public  only_owner{
        _receiver.transfer(fees);
        fees = 0;
    }

    function show_fees() public view only_owner returns(uint) {
        return fees;
    }

    function register(string memory _username) public{
        require( Users[msg.sender].exists == false);
        Users[msg.sender] = user(_username, 0, true);
        AllUsers.push(_username);
    }

    function deposit(address _receiver_address) external payable existing_user(_receiver_address){
        Users[_receiver_address].balance += msg.value;
        bank_funds += msg.value;
    }

    function withdraw(uint256 _amount, address payable _to) external balance_check(_amount){
        uint amt = _amount * 99 / 100;
        _to.transfer(amt);
        Users[msg.sender].balance -= _amount;
        fees += _amount - amt;
        bank_funds -= amt;
    }

    function transferTo(uint256 _amount,address payable _to) external balance_check(_amount){
        uint amt = _amount * 95/100;
        _to.transfer(_amount);
        Users[msg.sender].balance -= _amount;
        Users[_to].balance += amt;
        fees += _amount - amt;
        bank_funds -= amt;
    }

    function balanceOf() public view returns (uint256) {
        return Users[msg.sender].balance;
    }

    function showAllUsers() public view only_owner returns(string [] memory){

        return AllUsers;
    }




    fallback() external{
        revert();
    }

}