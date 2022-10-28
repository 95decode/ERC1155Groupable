// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "./ERC1155GroupableSupply.sol";

contract ERC1155PresetGroupSupply is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155GroupableSupply {
    constructor() ERC1155("") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function setGroupURI(uint256 groupId, string memory uri) public onlyOwner {
        _setGroupURI(groupId, uri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function setGroup(uint256 tokenId, uint256 groupId)
        public
        onlyOwner 
    {
        _setGroup(tokenId, groupId);
    }

    function changeGroup(uint256 tokenId, uint256 groupId)
        public
        onlyOwner 
    {
        _changeGroup(tokenId, groupId);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155GroupableSupply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
