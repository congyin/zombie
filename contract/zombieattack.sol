pragma solidity ^0.4.19;

// zombie攻击合约
import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
  //用于计算随机数的状态变量
  uint randNonce = 0;
  //胜利的胜率
uint attackVictoryProbability = 70;

  //生成随机函数
  function randMod(uint _modulus) internal returns(uint) {
    //使的每一次的输入值不一样
    randNonce++;
    return uint(keccak256(now, msg.sender,randNonce)) % _modulus;
  }
  //攻击函数
  function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
    //获得双方Zombie的 storage指针，方便交互
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    //战斗赢了 70%赢，30%输
    if (rand <= attackVictoryProbability) { //成功操作
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");   //该函数已调用进入进入冷却函数
    } else {   //失败操作
      myZombie.lossCount++;
      enemyZombie.winCount++;
      _triggerCooldown(myZombie);  //进入冷却
    }
  }
}
