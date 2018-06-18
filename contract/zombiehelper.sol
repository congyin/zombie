pragma solidity ^0.4.19;

import "./zombiefeeding.sol"

contract ZombieHelper is ZombieFeeding {
  // 1. 在这里定义 levelUpFee
  uint levelUpFee = 0.001 ether;

  //等级修饰符
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  // 2. 在这里插入 levelUp 函数 ,充钱升级
 function levelUp(uint _zombieId) external payable {
   require(msg.value == levelUpFee);
   zombies[_zombieId].level++;
 }

  //当等级大于2级可以改name
  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20,_zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  //获取主人拥有的zombie
  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    //建立一个和主人拥有zombie数量的数组
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    // 在这里开始
    uint counter = 0;
    //遍历zombies数组，将属于主人的zombie的id保存在数组中
    for (uint i = 0; i < zombies.length; i++) {
        if (zombieToOwner[i] == _owner) {
            result[counter] = i;
            counter++;
        }
    }
    //返回数组
    return result;
  }
}
