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
                        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 3500"><style>.logo { fill: white; font-family: mono; font-size: 8px; } .base { fill: white; font-family: mono; font-size: 8px; background: white }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="logo">',
                        "&#8203; &#8203; _____&#8203; &#8203; &#8203; ___&#8203; __&#8203; ___&#8203; &#8203; &#8203; &#8203; &#8203; &#8203; &#8203; &#8203; _&#8203; __&#8203; _&#8203; &#8203; &#8203; _&#8203; _&#8203; __&#8203; &#8203; _&#8203; __&#8203; &#8203; &#8203; ___&#8203; _&#8203; __&#8203; ___&#8203;",
                        '</text><text x="10" y="30" class="logo">',
                        "&#8203; /&#8203; _&#8203; \\&#8203; \\&#8203; /&#8203; /&#8203; '_&#8203; '&#8203; _&#8203; \\&#8203; _____|&#8203; '__|&#8203; |&#8203; |&#8203; |&#8203; '_&#8203; \\|&#8203; '_&#8203; \\&#8203; /&#8203; _&#8203; \\&#8203; '__/&#8203; __|",
                        '</text><text x="10" y="40" class="logo">',
                        "|&#8203; &#8203; __/\\&#8203; V&#8203; /|&#8203; |&#8203; |&#8203; |&#8203; |&#8203; |_____|&#8203; |&#8203; &#8203; |&#8203; |_|&#8203; |&#8203; |&#8203; |&#8203; |&#8203; |&#8203; |&#8203; |&#8203; &#8203; __/&#8203; |&#8203; &#8203; \\__&#8203; \\",
                        '</text><text x="10" y="50" class="logo">',
                        "&#8203; \\___|&#8203; \\_/&#8203; |_|&#8203; |_|&#8203; |_|&#8203; &#8203; &#8203; &#8203; &#8203; |_|&#8203; &#8203; &#8203; \\__,_|_|&#8203; |_|_|&#8203; |_|\\___|_|&#8203; &#8203; |___/",
                        '</text><text x="30" y="90" class="base">',
                        "Username: ",
                        userName,
                        '</text><text x="30" y="110" class="base">',
                        "Level: ",
                        levelName,
                        '</text><text x="30" y="130" class="base">',
                        "Size: ",
                        toString(size),
                        '</text><text x="30" y="150" class="base">',
                        "Gas: ",
                        toString(gas),
                        '</text><text x="30" y="170" class="base">',
                        "Optimized For: ",
                        optimizedFors[optimizedFor],
                        '</text><text x="30" y="190" class="base">',
                        "Solution Type: ",
                        solutionTypes[solutionType],
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
