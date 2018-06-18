
//繁殖和猎食
progam solidity ^0.4.19;
import "./zombieFactory.sol";

//创建迷恋猫的接口
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    )
};
contract ZombieFeeding is ZombieFactory {
  //迷恋猫合约的地址
  //address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // Initialize kittyContract here using `ckAddress` from above
  //KittyInterface kittyContract = KittyInterface(ckAddress);  //初始化迷恋猫接口

//声明 迷恋猫接口
KittyInterface kittyContract；
//更改迷恋猫合约地址的函数
  function setKittyContractAddress(address _address) external onlyOwner {
   kittyContract = kittyInterface(_address);
 }


 // 1. 在这里定义 `_triggerCooldown` 函数
 function _triggerCooldown(Zombie storage _zombie) internal {
     _zombie.readyTime = uint32(now + cooldownTime);
 }

 // 2. 在这里定义 `_isReady` 函数
 function _isReady(Zombie storage _zombie) internal view returns(bool) {
     return (_zombie.readyTime <= now);
 }
  //猎食和繁殖  // 1. 使这个函数的可见性为 internal
function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal {
    require(zombieToOwner[_zombieId] == msg.sender); //检查是否是准人
    Zombie storage myZombie = zombies[_zombieId];  //得到zombie的指针
    _targetDna = _targetDna % dnaModulus;   //保证dna为16位
    // 2. 在这里为 `_isReady` 增加一个检查
    require(_isReady(myZombie));
    uint newDna = (myZombie.dna + _targetDna) / 2;   //计算新的dna
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);    //生成zombie
    // 3. 调用 `triggerCooldown`
    _triggerCooldown(myZombie);
  }
  //吃猫
function feedOnKitty(uint _zombieId, uint _kittyId, , string _species) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna);
  }
}
