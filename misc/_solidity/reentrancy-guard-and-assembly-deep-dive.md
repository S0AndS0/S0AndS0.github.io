---
vim: textwidth=79 nowrap
title: Reentrancy guard and assembly deep dive
description:
layout: post
date: 2025-03-29 10:00:30 -0700
time_to_live: 1800
author: S0AndS0
tags: [ solidity, assembly, gas-optimizations, blockchain, evm ]
image: assets/images/solidity/reentrancy-guard-and-assembly-deep-dive/first-code-block.png

# social_comment:
#   links:
#     - text: LinkedIn
#       href:
#       title: Link to LinkedIn thread for this post
#
#     - text: Mastodon
#       href:
#       title: Link to Toot thread for this post
#
#     - text: Twitter
#       href:
#       title: Link to Tweet thread for this post

attribution:
  links:
    - text: Solidity Language Blog -- Transient Storage Opcodes in Solidit 0.8.24
      href: https://soliditylang.org/blog/2024/01/26/transient-storage/
      title: Transient Storage Opcodes in Solidit 0.8.24

    - text: Solidity Language Documentation -- Layout of State Variables in Storage and Transient Storage
      href: https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html
      title: Layout of State Variables in Storage and Transient Storage

    - text: Stack Exchange -- Solidity gas execution/storage costs of `enum` vs `uint constant`
      href: https://ethereum.stackexchange.com/questions/168395/solidity-gas-execution-storage-costs-of-enum-vs-uint-constant
      title: Solidity gas execution/storage costs of `enum` vs `uint constant`

#     - text:
#       href:
#       title:

---


**ToC**


- [TLDR][heading__tldr]
- [Story time][heading__story_time]
- [Project setup][heading__project_setup]
- [Useful commands][heading__useful_commands]
- [Reentrancy Guards][heading__reentrancy_guards]
  - [`ReentrancyGuard_Enum`][heading__reentrancyguard_enum]
  - [`ReentrancyGuard_Enum_transient`][heading__reentrancyguard_enum_transient]
  - [`ReentrancyGuard_OpenZeppelin`][heading__reentrancyguard_openzeppelin]
  - [`ReentrancyGuard_OpenZeppelin_transient`][heading__reentrancyguard_openzeppelin_transient]
- [Implementations and tests][heading__implementations_and_tests]
  - [`Implments_ReentrancyGuard`][heading__implments_reentrancyguard]
  - [Reentrancy Tests][heading__reentrancy_tests]
- [Assembly differences][heading__assembly_differences]
  - [`src/Implments_ReentrancyGuard_Enum.sol` vs `src/Implments_ReentrancyGuard_Enum_transient.sol`][heading__srcimplments_reentrancyguard_enumsol_vs_srcimplments_reentrancyguard_enum_transientsol]
  - [`src/Implments_ReentrancyGuard_OpenZeppelin.sol` vs `src/Implments_ReentrancyGuard_OpenZeppelin_transient.sol`][heading__srcimplments_reentrancyguard_openzeppelinsol_vs_srcimplments_reentrancyguard_openzeppelin_transientsol]
  - [`src/Implments_ReentrancyGuard_OpenZeppelin.sol` vs `src/Implments_ReentrancyGuard_Enum.sol`][heading__srcimplments_reentrancyguard_openzeppelinsol_vs_srcimplments_reentrancyguard_enumsol]
- [Gas usage][heading__gas_usage]
- [Thoughts and additional comments][heading__thoughts_and_additional_comments]


______


## TLDR
[heading__tldr]: #tldr


- Using `delete` vs re-writing original value does **not** produce measurable differences in gas costs, at least not for this specific use case regardless of if `enum` or `const uint` types are used
- Using `transient` should, as of author date of this post, be **avoided** in contracts requiring lowest gas costs when **executing**
- Using `transient` should, as of author date of this post, be _okay_ in contracts requiring lowest gas costs when **publishing**
- For details why for `enum` costs more than `const uint` when used for mutex/reentry guards, skip to: [`src/Implments_ReentrancyGuard_OpenZeppelin.sol` vs `src/Implments_ReentrancyGuard_Enum.sol`][heading__srcimplments_reentrancyguard_openzeppelinsol_vs_srcimplments_reentrancyguard_enumsol]...  Basically seems to be because `enum` adds at least four more operations
- For details why for `transient` costs more than regular storage when used for mutex/reentry guards, skip to: [`src/Implments_ReentrancyGuard_Enum.sol` vs `src/Implments_ReentrancyGuard_Enum_transient.sol`][heading__srcimplments_reentrancyguard_enumsol_vs_srcimplments_reentrancyguard_enum_transientsol] and [`src/Implments_ReentrancyGuard_OpenZeppelin.sol` vs `src/Implments_ReentrancyGuard_OpenZeppelin_transient.sol`][heading__srcimplments_reentrancyguard_openzeppelinsol_vs_srcimplments_reentrancyguard_openzeppelin_transientsol]...  In this case five more operations are added when using `transient`


______


## Story time
[heading__story_time]: #story-time


For a recent contracted project I had the _opportunity_ to confront assumptions
about optimal smart contract code; boss wanted `enum` types but memory led me
to believe `const uint256` would be less costly.  So instead of debating from a
place of ignorance I did a _bit_ of testing to check if/how wrong I may be.

What follows are the dry facts extracted from testing one specific feature set,
and additional testing likely be necessary to provide data on if/where one type
is more/less appropriate for a given use-case.  Readers are encouraged to
submit a Pull Request with corrections and/or post questions via various
social-media links provided.


______


## Project setup
[heading__project_setup]: #project-setup


```bash
pushd /tmp
forge init gassy
pushd "${_}"
mkdir out
```


______


## Useful commands
[heading__useful_commands]: #useful-commands

- Output optimized assembly
   ```bash
   ### Syntax
   forge inspect "<FILE>:<CONTRACT>" assemblyOptimized > "<OUTPUT>.asm"

   ### Example
   forge inspect "src/ReentrancyGuard_OpenZeppelin.sol:ReentrancyGuard_OpenZeppelin" assemblyOptimized > "out/ReentrancyGuard_OpenZeppelin.asm"
   ```
- Use optimized compilation when testing and produce a gas report for specific test file
   ```bash
   ### Syntax
   forge test --gas-report --optimize true --match-path "<FILE>"

   ### Example
   forge test --gas-report --optimize true --match-path test/reentry-gas.t.sol
   ```


______


## Reentrancy Guards
[heading__reentrancy_guards]: #reentrancy-guards

**Sub-sections**

- [`ReentrancyGuard_Enum`][heading__reentrancyguard_enum]
- [`ReentrancyGuard_Enum_transient`][heading__reentrancyguard_enum_transient]
- [`ReentrancyGuard_OpenZeppelin`][heading__reentrancyguard_openzeppelin]
- [`ReentrancyGuard_OpenZeppelin_transient`][heading__reentrancyguard_openzeppelin_transient]

---

### `ReentrancyGuard_Enum`
[heading__reentrancyguard_enum]: #reentrancyguard_enum

- Relative path: `src/ReentrancyGuard_Enum.sol`

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract ReentrancyGuard_Enum {
    enum LockState { NOT_ENTERED, ENTERED }
    LockState private _status;

    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = LockState.NOT_ENTERED;
    }

    modifier nonReentrant() {
        if (_status == LockState.ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }
        _status = LockState.ENTERED;
        _;
        _status = LockState.NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == LockState.ENTERED;
    }
}
```

---

### `ReentrancyGuard_Enum_transient`
[heading__reentrancyguard_enum_transient]: #reentrancyguard_enum_transient

- Relative path: `src/ReentrancyGuard_Enum_transient.sol`

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract ReentrancyGuard_Enum_transient {
    enum LockState { NOT_ENTERED, ENTERED }
    LockState private transient _status;

    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = LockState.NOT_ENTERED;
    }

    modifier nonReentrant() {
        if (_status == LockState.ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }
        _status = LockState.ENTERED;
        _;
        _status = LockState.NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == LockState.ENTERED;
    }
}
```

---

### `ReentrancyGuard_OpenZeppelin`
[heading__reentrancyguard_openzeppelin]: #reentrancyguard_openzeppelin

[GitHub -- `OpenZeppelin/openzeppelin-contracts` -- `contracts/utils/ReentrancyGuard.sol`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol)

- Relative path: `src/ReentrancyGuard_OpenZeppelin_transient.sol`

```solidity
/// License-Identifier: MIT
pragma solidity ^0.8.13;

abstract contract ReentrancyGuard_OpenZeppelin {
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}
```

---

### `ReentrancyGuard_OpenZeppelin_transient`
[heading__reentrancyguard_openzeppelin_transient]: #reentrancyguard_openzeppelin_transient

- Relative path: `src/ReentrancyGuard_OpenZeppelin_transient.sol`

```solidity
/// License-Identifier: MIT
pragma solidity ^0.8.13;

abstract contract ReentrancyGuard_OpenZeppelin_transient {
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private transient _status;

    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}
```


______


## Implementations and tests
[heading__implementations_and_tests]: #implementations-and-tests

**Sub-sections**

- [`Implments_ReentrancyGuard`][heading__implments_reentrancyguard]
- [Reentrancy Tests][heading__reentrancy_tests]

### `Implments_ReentrancyGuard`
[heading__implments_reentrancyguard]: #implments_reentrancyguard

- Relative path: `src/Implments_ReentrancyGuard.sol`

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { ReentrancyGuard_Enum } from "src/ReentrancyGuard_Enum.sol";
import { ReentrancyGuard_Enum_transient } from "src/ReentrancyGuard_Enum_transient.sol";
import { ReentrancyGuard_OpenZeppelin } from "src/ReentrancyGuard_OpenZeppelin.sol";
import { ReentrancyGuard_OpenZeppelin_transient } from "src/ReentrancyGuard_OpenZeppelin_transient.sol";

interface IAccount_Counter {
    function increment() external payable;
}

contract Implments_ReentrancyGuard_Enum is IAccount_Counter, ReentrancyGuard_Enum {
    mapping(address => uint256) public account_counter;
    function increment() external payable virtual {
        ++account_counter[msg.sender];
    }
}

contract Implments_ReentrancyGuard_Enum_transient is IAccount_Counter, ReentrancyGuard_Enum_transient {
    mapping(address => uint256) public account_counter;
    function increment() external payable virtual {
        ++account_counter[msg.sender];
    }
}

contract Implments_ReentrancyGuard_OpenZeppelin is IAccount_Counter, ReentrancyGuard_OpenZeppelin {
    mapping(address => uint256) public account_counter;
    function increment() external payable virtual {
        ++account_counter[msg.sender];
    }
}

contract Implments_ReentrancyGuard_OpenZeppelin_transient is IAccount_Counter, ReentrancyGuard_OpenZeppelin_transient {
    mapping(address => uint256) public account_counter;
    function increment() external payable virtual {
        ++account_counter[msg.sender];
    }
}
```

---


### Reentrancy Tests
[heading__reentrancy_tests]: #reentrancy-tests

- Relative path: `test/reentry-gas.t.sol`

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";

import {
    Implments_ReentrancyGuard_Enum,
    Implments_ReentrancyGuard_Enum_transient,
    Implments_ReentrancyGuard_OpenZeppelin,
    Implments_ReentrancyGuard_OpenZeppelin_transient,
} from "../src/Implments_ReentrancyGuard.sol";

contract Implments_ReentrancyGuard_Enum_Test is Test {
    Implments_ReentrancyGuard_Enum implments_reentrancyguard_enum;

    function setUp() public {
        implments_reentrancyguard_enum = new Implments_ReentrancyGuard_Enum();
    }

    function test_gas_costs() public {
        uint256 runs = 1000;
        for (uint i; i < runs; ) {
            implments_reentrancyguard_enum.increment();
            unchecked { ++i; }
        }
    }
}

contract Implments_ReentrancyGuard_Enum_transient_Test is Test {
    Implments_ReentrancyGuard_Enum_transient implments_reentrancyguard_enum_transient;

    function setUp() public {
        implments_reentrancyguard_enum_transient = new Implments_ReentrancyGuard_Enum_transient();
    }

    function test_gas_costs() public {
        uint256 runs = 1000;
        for (uint i; i < runs; ) {
            implments_reentrancyguard_enum_transient.increment();
            unchecked { ++i; }
        }
    }
}

contract Implments_ReentrancyGuard_OpenZeppelin_Test is Test {
    Implments_ReentrancyGuard_OpenZeppelin implments_reentrancyguard_openzeppelin;

    function setUp() public {
        implments_reentrancyguard_openzeppelin = new Implments_ReentrancyGuard_OpenZeppelin();
    }

    function test_gas_costs() public {
        uint256 runs = 1000;
        for (uint i; i < runs; ) {
            implments_reentrancyguard_openzeppelin.increment();
            unchecked { ++i; }
        }
    }
}

contract Implments_ReentrancyGuard_OpenZeppelin_transient_Test is Test {
    Implments_ReentrancyGuard_OpenZeppelin_transient implments_reentrancyguard_openzeppelin_transient;

    function setUp() public {
        implments_reentrancyguard_openzeppelin_transient = new Implments_ReentrancyGuard_OpenZeppelin_transient();
    }

    function test_gas_costs() public {
        uint256 runs = 1000;
        for (uint i; i < runs; ) {
            implments_reentrancyguard_openzeppelin_transient.increment();
            unchecked { ++i; }
        }
    }
}
```




______



## Assembly differences
[heading__assembly_differences]: #assembly-differences

**Notes**

- changes in comments and other non-executable code differences have been redacted
- line/column numbers in following `diff` examples are likely inaccurate

**Sub-sections**

- [`src/Implments_ReentrancyGuard_Enum.sol` vs `src/Implments_ReentrancyGuard_Enum_transient.sol`][heading__srcimplments_reentrancyguard_enumsol_vs_srcimplments_reentrancyguard_enum_transientsol]
- [`src/Implments_ReentrancyGuard_OpenZeppelin.sol` vs `src/Implments_ReentrancyGuard_OpenZeppelin_transient.sol`][heading__srcimplments_reentrancyguard_openzeppelinsol_vs_srcimplments_reentrancyguard_openzeppelin_transientsol]
- [`src/Implments_ReentrancyGuard_OpenZeppelin.sol` vs `src/Implments_ReentrancyGuard_Enum.sol`][heading__srcimplments_reentrancyguard_openzeppelinsol_vs_srcimplments_reentrancyguard_enumsol]

---

### `src/Implments_ReentrancyGuard_Enum.sol` vs `src/Implments_ReentrancyGuard_Enum_transient.sol`
[heading__srcimplments_reentrancyguard_enumsol_vs_srcimplments_reentrancyguard_enum_transientsol]: #srcimplments_reentrancyguard_enumsol-vs-srcimplments_reentrancyguard_enum_transientsol

```diff
diff --git a/Implments_ReentrancyGuard_Enum.asm b/Implments_ReentrancyGuard_Enum_transient.asm
index 09c3337..7738799 100644
--- a/Implments_ReentrancyGuard_Enum.asm
+++ b/Implments_ReentrancyGuard_Enum_transient.asm
@@ -8,16 +8,19 @@
   revert(0x00, 0x00)
 tag_1:
   pop
   0x00
   dup1
-  sload
+  tload
   not(0xff)
   and
-  swap1
-  sstore
+  dup2
+  tstore
+  pop
   dataSize(sub_0)
   dup1
   dataOffset(sub_0)
@@ -61,8 +64,11 @@ sub_0: assembly {
       tag_7
       jump	// in
     tag_6:
-      mstore(0x20, 0x01)
       0x00
+      0x20
+      dup2
+      swap1
+      mstore
       swap1
       dup2
       mstore
@@ -97,29 +103,30 @@ sub_0: assembly {
     tag_11:
       stop
     tag_12:
       caller
       0x00
       swap1
       dup2
       mstore
-      0x01
       0x20
+      dup2
+      swap1
       mstore
       0x40
       dup2
       keccak256
```

---

### `src/Implments_ReentrancyGuard_OpenZeppelin.sol` vs `src/Implments_ReentrancyGuard_OpenZeppelin_transient.sol`
[heading__srcimplments_reentrancyguard_openzeppelinsol_vs_srcimplments_reentrancyguard_openzeppelin_transientsol]: #srcimplments_reentrancyguard_openzeppelinsol-vs-srcimplments_reentrancyguard_openzeppelin_transientsol

```diff
diff --git a/Implments_ReentrancyGuard_OpenZeppelin.asm b/Implments_ReentrancyGuard_OpenZeppelin_transient.asm
index 978d18b..6172a99 100644
--- a/Implments_ReentrancyGuard_OpenZeppelin.asm
+++ b/Implments_ReentrancyGuard_OpenZeppelin_transient.asm
@@ -8,13 +8,15 @@
   revert(0x00, 0x00)
 tag_1:
   pop
   0x01
+  dup1
   0x00
-  sstore
+  tstore
+  pop
   dataSize(sub_0)
   dup1
   dataOffset(sub_0)
@@ -58,8 +60,11 @@ sub_0: assembly {
       tag_7
       jump	// in
     tag_6:
-      mstore(0x20, 0x01)
       0x00
+      0x20
+      dup2
+      swap1
+      mstore
       swap1
       dup2
       mstore
@@ -94,29 +99,30 @@ sub_0: assembly {
     tag_11:
       stop
     tag_12:
       caller
       0x00
       swap1
       dup2
       mstore
-      0x01
       0x20
+      dup2
+      swap1
       mstore
       0x40
       dup2
       keccak256
```

---

### `src/Implments_ReentrancyGuard_OpenZeppelin.sol` vs `src/Implments_ReentrancyGuard_Enum.sol`
[heading__srcimplments_reentrancyguard_openzeppelinsol_vs_srcimplments_reentrancyguard_enumsol]: #srcimplments_reentrancyguard_openzeppelinsol-vs-srcimplments_reentrancyguard_enumsol

```diff
diff --git a/Implments_ReentrancyGuard_OpenZeppelin.asm b/Implments_ReentrancyGuard_Enum.asm
index 978d18b..09c3337 100644
--- a/Implments_ReentrancyGuard_OpenZeppelin.asm
+++ b/Implments_ReentrancyGuard_Enum.asm
@@ -8,13 +8,16 @@
   revert(0x00, 0x00)
 tag_1:
   pop
-  0x01
   0x00
+  dup1
+  sload
+  not(0xff)
+  and
+  swap1
   sstore
   dataSize(sub_0)
   dup1
   dataOffset(sub_0)
```


______


## Gas usage
[heading__gas_usage]: #gas-usage

 Contract                                          | Deployment Cost | Deployment Size | `increment` average cost
================================================== | =============== | =============== | ========================
`Implments_ReentrancyGuard_Enum`                   | `114_204`       | `307`           | `26_353`
`Implments_ReentrancyGuard_Enum_transient`         | `112_222`       | `308`           | `26_356`
`Implments_ReentrancyGuard_OpenZeppelin`           | `134_012`       | `302`           | `26_353`
`Implments_ReentrancyGuard_OpenZeppelin_transient` | `112_049`       | `304`           | `26_356`


______



## Thoughts and additional comments
[heading__thoughts_and_additional_comments]: #thoughts-and-additional-comments


The execution costs being identical between `enum` vs `const uint256` is a
_bit_ surprising, because the `enum` type adds four/five op-codes.  Also when
value variants increases beyond two it becomes possible to measure this
difference via gas consumption again...  Perhaps, if there is sufficient
interest, a second blog post will be posted about state-machines in solidity.

Deployment costs being cheaper for `transient` vs traditional private storage
is kinda annoying, because much like `enum` there are more operations plus the
resulting byte-code is larger.  But this is less annoying as it being more
expensive for execution, as the
[Solidity Language blog][solidity-lang-blog__transient-storage]
post advertises cheaper reentrancy locks;

> ...
> An expected canonical use case for transient storage is cheaper reentrancy
> locks, which can be readily implemented with the opcodes as showcased below
> ...

But perhaps this too warrants a follow-up blog post with something less trivial
for the test use-case.



[solidity-lang-blog__transient-storage]: https://soliditylang.org/blog/2024/01/26/transient-storage/
