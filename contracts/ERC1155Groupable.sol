// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/**
 * @dev Extension of {ERC1155} that makes token groups with groupId and groupSubId
 */
abstract contract ERC1155Groupable is ERC1155 {
    // Optional mapping for group URIs
    mapping(uint256 => string) private _groupURIs;

    mapping(uint256 => mapping(uint256 => uint256)) private _groupIds;

    function _setGroupURI(uint256 groupId, string memory groupURI) internal virtual {
        _groupURIs[groupId] = groupURI;
    }

    function _setGroup(uint256 tokenId, uint256 groupId, uint256 groupSubId) internal virtual {
        _groupIds[groupId][groupSubId] = tokenId;
    }

    function findGroupURI(uint256 groupId) public view virtual returns (string memory) {
        return _groupURIs[groupId];
    }

    function findIdWithGroup(uint256 groupId, uint256 groupSubId) public view virtual returns (uint256) {
        return _groupIds[groupId][groupSubId];
    }

    function mintWithGroup(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data,
        uint256 groupId, 
        uint256 groupSubId 
    ) public virtual {
        _mint(to, id, amount, data);
        _setGroup(id, groupId, groupSubId);
    }

    function transferWithGroup(
        address from,
        address to,
        uint256 groupId,
        uint256 groupSubId,
        uint256 amount,
        bytes memory data
    ) public virtual {
        safeTransferFrom(
            from,
            to,
            findIdWithGroup(groupId, groupSubId),
            amount,
            data
        );
    }

    // balanceOfWithGroup()

    // 
}