pragma solidity ^0.4.19;
//zombie工厂合约

//引入ownable文件
import "./ownable.sol";

//继承
contract ZombieFactory is Ownable {

  //newZombie事件
  event NewZombie(uint zombieId, string name, uint dna);
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;

  // 1. 在这里定义 `cooldownTime`
    uint cooldownTime = 1 days;

  //zombie数据结构
  struct Zombie {
    string name;
    uint dna;
    uint32 level;   //等级
    uint32 readyTime; //冷却时间
    uint16 winCount; //胜利次数
    uint16 lossCount; //失败次数
  }

  //zombie数组
  Zombie[] public zombies;

  //映射
  mapping(uint => address) public zombieToOwner;
  mapping(address => uint) ownerZombieCount;

  //生成zombie存储在数组中，并触发NewZombie事件
  function _createZombie(string _name, uint _dna) internal {
    //生成zombie
    uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0));  //得到id
    zombieToOwner[id] = msg.sender;     //把该zombie归属于调用者
    ownerZombieCount[msg.sender]++;  //调用者用所有数量+1
    NewZombie(id, _name, _dna);       //触发事件
  }
  //根据name生成dna
  function _generateRandomDna(string _str) private view returns(uint) {
    uint rand = uint(keccak256(_str));
    return rand % dnaModulus;
  }

//根据 name生成zombie
  function createRandomZombie(string _name) public {
    require(ownerZombieCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
  }
}
