// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
//import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @dev Extension of {ERC1155}
 */
abstract contract ERC1155Groupable is ERC1155 {
    //using Strings for uint256;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _groupURIs;

    function groupURI(uint256 groupId) public view virtual override returns (string memory) {
        return = _groupURIs[groupId];
    }

    function _setGroupURI(uint256 groupId, string memory groupURI) internal virtual {
        _groupURIs[groupId] = groupURI;
    }

    mapping(uint256 => mapping(uint256 => uint256)) private _groupIds;

    function _setGroup(uint256 tokenId, uint256 groupId, uint256 groupSubId) internal virtual {
        _groupIds[groupId][groupSubId] = tokenId;
    };

    function findIdWithGroup(uint256 groupId, uint256 groupSubId) public view virtual override returns (uint256) {
        return _groupIds[groupId][groupSubId]
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
    };

    function transferWithGroup(
        address from,
        address to,
        uint256 groupId,
        uint256 groupSubId,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        safeTransferFrom(
            from,
            to,
            findIdWithGroup(groupId, groupSubId),
            amount,
            data
        );
    }

}