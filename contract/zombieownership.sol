pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";  //导入erc721标准

//继承erc721标准并实现
contract ZombieOwnerShip is ZombieAttack, ERC721 {

  //定义拥有approve权限映射
  mapping (uint => address) zombieApprovals;

  // 1. 在这里返回 `_owner` 拥有的僵尸数
  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }
    // 2. 在这里返回 `_tokenId` 的所有者
  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }

  // 在这里定义 _transfer()用来封装transfer()函数和takenOwnerShip()函数的实现
  function _transfer(address _from, address _to, uint256 _tokenId) private {
      ownerZombieCount[_to]++;  //将接收者拥有的数量+1
      ownerZombieCount[_from]--;  //拥有着数量-1
      zombieToOwner[_tokenId] = _to;  //将zombie转移至接收者_to
      Transfer(_from, _to, _tokenId);  //出发erc721协议里的事件
  }

  //添加修饰符
  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  //实现approve函数，将_tokenId转移为一个可以领走的地址
  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    // 3. 在这里定义方法
    zombieApprovals[_tokenId] = _to;  //保存在可领养的映射中
    Approval(msg.sender, _to, _tokenId);
  }

 //从approve领走_tokenId
  function takeOwnership(uint256 _tokenId) public {
     require(zombieApprovals[_tokenId] == msg.sender);
     address owner = ownerOf(_tokenId);
     _transfer(owner, msg.sender, _tokenId);
   }

}
