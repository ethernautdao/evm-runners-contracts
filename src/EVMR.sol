// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "solady/src/tokens/ERC721.sol";
import "solady/src/auth/OwnableRoles.sol";

interface IRenderer {
    function render(
        string memory levelName,
        uint256 gas,
        uint256 size,
        uint256 solutionType,
        uint256 optimizedFor,
        string memory userName
    ) external view returns (string memory);
}

contract EVMR is ERC721, OwnableRoles {
    uint256 internal constant BACKEND_ROLE = _ROLE_0;

    string internal constant _name = "evm-runners";
    string internal constant _symbol = "EVMR";

    IRenderer public renderer;

    struct Submission {
        uint64 id;
        uint48 level_id;
        uint32 gas;
        uint32 size;
        uint8 solutionType; // 0 solidity, 1 yul, 2 vyper, 3 huff, 4 bytecode
        uint8 optimized_for; // 0 gas, 1 size
        uint64 submitted_at;
        string user_name;
    }

    // id => Submission
    mapping(uint256 => Submission) public idToSubmission;
    // level_id to level_name
    mapping(uint256 => string) public levelIdToName;

    constructor(address backend, address _renderer) {
        _initializeOwner(msg.sender);
        _grantRoles(backend, BACKEND_ROLE);
        renderer = IRenderer(_renderer);
    }

    // Admin functions
    function setRenderer(address _renderer) public onlyOwner {
        renderer = IRenderer(_renderer);
    }

    function updateBackend(address backend) public onlyOwner {
        _updateRoles(backend, BACKEND_ROLE, true);
    }

    function setLevelName(uint256 level_id, string memory level_name) public onlyRolesOrOwner(BACKEND_ROLE) {
        levelIdToName[level_id] = level_name;
    }

    function submit(address user, Submission memory submission) external onlyRolesOrOwner(BACKEND_ROLE) {
        idToSubmission[uint256(submission.id)] = submission;

        if (user != address(0)) {
            _mint(user, uint256(submission.id));
        }
    }

    function mint(address user, uint256 id) public onlyRolesOrOwner(BACKEND_ROLE) {
        _mint(user, id);
    }

    // public view functions

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // reverts if token does not exist
        if (!_exists(tokenId)) revert TokenDoesNotExist();

        return (
            renderer.render(
                levelIdToName[idToSubmission[tokenId].level_id],
                idToSubmission[tokenId].gas,
                idToSubmission[tokenId].size,
                idToSubmission[tokenId].solutionType,
                idToSubmission[tokenId].optimized_for,
                idToSubmission[tokenId].user_name
            )
        );
    }
}
