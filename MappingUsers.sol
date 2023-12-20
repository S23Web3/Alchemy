// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
//we make a struct that we can call with mapping
	struct User {
		uint balance;
		bool isActive;
	}
// this mapping will let the address be the key and the value the User struct, so one address and dot will make the value be including a balance and a bool value
	mapping (address => User) public users;

//make a new user
	function createUser () external {
//avoid double entries
//check if msg.sender already isActive (so it should be false as require must be positive in the first part)
		require(!users[msg.sender].isActive, "User already exists");
//make a new user in the temp memory with 100 and true
		User memory newUser = User (100,true);
//assign this newUser to the mapping users with slot msg.sender + 0x0
		users[msg.sender] = newUser;

	}
//now we can transfer from one user to another as long as they are active and there is enough balance at the senders address which is the one calling the function
 function transfer(address recipient, uint256 amount) external {
		require(users[msg.sender].isActive, "User is not active");
		require(users[recipient].isActive, "Recipient is not active");
		require(users[msg.sender].balance >= amount,"Not enough balance");
		users[msg.sender].balance -= amount;
		users[recipient].balance += amount;

	}

}
