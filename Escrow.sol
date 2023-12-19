// SPDX-License-Identifier: MIT
//This is the start of an Escrow contract. 

pragma solidity 0.8.20;

//first is the contract 
contract Escrow {

   // here come the standard values 
   address public depositor;
   address public beneficiary;
   address public arbiter;


   //I assign to the values whatever the contract gets given, if you call the contract 2 addresses needs to be inserted
    constructor(address _arbiter, address _beneficiary) {
      arbiter = _arbiter;
      beneficiary = _beneficiary;
      depositor = msg.sender;
    }

    //Here I give out the data that goes into the blockchain for this contract, particular to notify fyi that the transaction is approved
    event Approved(uint256);

    //the list of errors come here
    error NotAuthorized();

    function approve() external {
        //i believe that this part can be written with something like require msg.sender  or an isOwner variable
        if(msg.sender != arbiter) revert NotAuthorized(); 
        uint256 balance = address(this).balance;
    //this is the monkey wrench
        (bool success, ) = beneficiary.call{ value: balance }("");
    		require(success);

        emit Approved(balance);
    }
    
}
