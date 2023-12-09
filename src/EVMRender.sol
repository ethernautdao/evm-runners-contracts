//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./utils/Base64.sol";

contract EVMRender {
    string[] internal solutionTypes = ["Solidity", "Yul", "Vyper", "Huff", "Bytecode"];
    string[] internal optimizedFors = ["Gas", "Size"];

    function render(
        string memory levelName,
        uint256 gas,
        uint256 size,
        uint256 solutionType,
        uint256 optimizedFor,
        string memory userName
    ) public view returns (string memory) {
        bytes memory image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    abi.encodePacked(
                        '<?xml version="1.0" encoding="UTF-8"?>',
                        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">',
                        levelName,
                        '</text><text x="10" y="40" class="base">',
                        "Gas: ",
                        toString(gas),
                        '</text><text x="10" y="60" class="base">',
                        "Size: ",
                        toString(size),
                        '</text><text x="10" y="80" class="base">',
                        "Solution Type: ",
                        solutionTypes[solutionType],
                        '</text><text x="10" y="100" class="base">',
                        "Optimized For: ",
                        optimizedFors[optimizedFor],
                        '</text><text x="10" y="120" class="base">',
                        "User Name: ",
                        userName,
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
                            '{"name":"evm-runners", "image":"',
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
}
