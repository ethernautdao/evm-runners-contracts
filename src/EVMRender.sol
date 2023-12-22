//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./utils/Base64.sol";

contract EVMRender {
    bytes16 private constant HEX_DIGITS = "0123456789abcdef";

    string[] internal solutionTypes = ["Solidity", "Yul", "Vyper", "Huff", "Bytecode"];
    string[] internal optimizedFors = ["Gas", "Size"];

    function render(
        uint256 id,
        string memory levelName,
        uint256 gas,
        uint256 size,
        uint256 solutionType,
        uint256 optimizedFor,
        bytes32 bytecode_hash,
        string memory userName
    ) public view returns (string memory) {
        bytes memory image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    abi.encodePacked(
                        '<?xml version="1.0" encoding="UTF-8"?>',
                        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.logo { fill: white; font-family: \'Courier New\', monospace; font-size: 8px; white-space: pre; } .base { fill: white; font-family: \'Courier New\', monospace; font-size: 8px; background: white }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="logo" xml:space="preserve">',
                        "  _____   ___ __ ___        _ __ _   _ _ __  _ __   ___ _ __ ___ ",
                        '</text><text x="10" y="30" class="logo" xml:space="preserve">',
                        " / _ \\ \\ / / '_ ' _ \\ _____| '__| | | | '_ \\| '_ \\ / _ \\ '__/ __|",
                        '</text><text x="10" y="40" class="logo" xml:space="preserve">',
                        "|  __/\\ V /| | | | | |_____| |  | |_| | | | | | | |  __/ |  \\__ \\",
                        '</text><text x="10" y="50" class="logo" xml:space="preserve">',
                        " \\___| \\_/ |_| |_| |_|     |_|   \\__,_|_| |_|_| |_|\\___|_|  |___/",
                        '</text><text x="20" y="90" class="base">',
                        "Username: ",
                        userName,
                        '</text><text x="20" y="110" class="base">',
                        "Level: ",
                        levelName,
                        '</text><text x="20" y="130" class="base">',
                        "Size: ",
                        toString(size),
                        '</text><text x="20" y="150" class="base">',
                        "Gas: ",
                        toString(gas),
                        '</text><text x="20" y="170" class="base">',
                        "Optimized For: ",
                        optimizedFors[optimizedFor],
                        '</text><text x="20" y="190" class="base">',
                        "Solution Type: ",
                        solutionTypes[solutionType],
                        '</text><text x="20" y="210" class="base">',
                        "Bytecode Hash (SHA256): ",
                        "</text>",
                        '<text x="20" y="230" class="base">', // Start a new line
                        toHexString(uint256(bytecode_hash), 32),
                        "</text>",
                        "</svg>"
                    )
                )
            )
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"evm-runners #',
                            toString(id),
                            '", "image":"',
                            image,
                            unicode'", "description": "This is a submission certificate for evm-runners."}'
                        )
                    )
                )
            )
        );
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        uint256 localValue = value;
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = HEX_DIGITS[localValue & 0xf];
            localValue >>= 4;
        }
        if (localValue != 0) {
            return "Insufficient length";
        }
        return string(buffer);
    }
}
