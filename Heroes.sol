This code needs to be commented. 

/*

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./Hero.sol";

// TODO: create Mage/Warrior Heroes

contract Warrior is Hero(200) {
    function attack(Enemy enemy) public override{
        enemy.takeAttack(AttackTypes.Brawl);
        super.attack(enemy);
    }
    
    
}

contract Mage is Hero(50) {
    function attack(Enemy enemy) public override{
        enemy.takeAttack(AttackTypes.Spell);
        super.attack(enemy);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./Enemy.sol";

contract Hero {
	uint public health;
	uint public energy = 10;
	constructor(uint _health) {
		health = _health;
	}

	enum AttackTypes { Brawl, Spell }
	function attack(Enemy) public virtual {
		energy--;
	}
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Hero.sol";
import "../src/SuperHeroes.sol";
import "../src/Enemy.sol";

contract EscrowTest is Test {
    Warrior public warrior;
    Mage public mage;
    Enemy public enemy;
    
    function setUp() public {
        warrior = new Warrior();
        mage = new Mage();
        enemy = new Enemy();
    }

    function testWarriorAttack() public {
        warrior.attack(enemy);
        assertEq(enemy.health(), 50);
        assertEq(warrior.energy(), 9);
    }

    function testMageAttack() public {
        mage.attack(enemy);
        assertEq(enemy.health(), 20);
        assertEq(mage.energy(), 9);
    }
}

*/
