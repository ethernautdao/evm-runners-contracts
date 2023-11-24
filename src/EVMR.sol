// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "solady/src/tokens/ERC721.sol";
import "solady/src/auth/OwnableRoles.sol";

interface IRenderer {
    function render(
        uint256 tokenId,
        string memory levelName,
        string memory userName,
        uint256 gas,
        uint256 size,
        string memory solutionType
    ) external view returns (string memory);
}

contract EVMR is ERC721, OwnableRoles {
    uint256 internal constant BACKEND_ROLE = _ROLE_0;

    string internal constant _name = "evm-runners";
    string internal constant _symbol = "EVMR";

    IRenderer public renderer;

    struct Submission {
        uint256 id;
        uint256 level_id;
        string level_name;
        uint256 user_id;
        string user_name;
        string bytecode;
        uint256 gas;
        uint256 size;
        uint256 submitted_at;
        string solutionType;
        string optimized_for;
    }

    // userAddress => Submission[]
    mapping(address => Submission[]) public submissionsToUser;
    // tokenId => Submission
    mapping(uint256 => Submission) public tokenIdToSubmission;

    constructor(address backend, address _renderer) {
        _initializeOwner(msg.sender);
        _grantRoles(backend, BACKEND_ROLE);
        renderer = IRenderer(_renderer);
    }

    // Admin functions

    function submit(
        address user,
        uint256 id,
        uint256 level_id,
        string memory level_name,
        uint256 user_id,
        string memory user_name,
        string memory bytecode,
        uint256 gas,
        uint256 size,
        uint256 submitted_at,
        string memory type_,
        string memory optimized_for
    ) external onlyRolesOrOwner(BACKEND_ROLE) {
        Submission memory newSubmission = Submission(
            id, level_id, level_name, user_id, user_name, bytecode, gas, size, submitted_at, type_, optimized_for
        );

        submissionsToUser[user].push(newSubmission);
    }

    function setRenderer(address _renderer) public onlyOwner {
        renderer = IRenderer(_renderer);
    }

    function mint(address user, uint256 id) external onlyRolesOrOwner(BACKEND_ROLE) {
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
        address tokenOwner = ownerOf(tokenId);

        return (
            renderer.render(
                tokenId,
                tokenIdToSubmission[tokenId].level_name,
                tokenIdToSubmission[tokenId].user_name,
                tokenIdToSubmission[tokenId].gas,
                tokenIdToSubmission[tokenId].size,
                tokenIdToSubmission[tokenId].solutionType
            )
        );
    }

    function getSubmissionsForUser(address userAddress) public view returns (Submission[] memory) {
        return submissionsToUser[userAddress];
    }
}
