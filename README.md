# ERC1155Groupable
ERC1155Groupable and preset contract and a test script for that contract

## Installation
ERC1155Groupable recommends [Node.js](https://nodejs.org/) v16.0.0+ to run.

Install the dependencies and test the contract.

```sh
cd ERC1155Groupable
npm install
npx hardhat compile
npx hardhat coverage
```

## Coverage
```sh
-----------------------------|----------|----------|----------|----------|----------------|
File                         |  % Stmts | % Branch |  % Funcs |  % Lines |Uncovered Lines |
-----------------------------|----------|----------|----------|----------|----------------|
 contracts/                  |      100 |      100 |      100 |      100 |                |
  ERC1155GroupableSupply.sol |      100 |      100 |      100 |      100 |                |
-----------------------------|----------|----------|----------|----------|----------------|
All files                    |      100 |      100 |      100 |      100 |                |
-----------------------------|----------|----------|----------|----------|----------------|

  ERC1155GroupableSupply
    setGroup
      Normal Case
        ✔ setGroup 호출 시 groupId 정상 등록 여부 (78ms)
        ✔ setGroup 호출 시 groupTotalSupply 정상 적용 여부 (61ms)
        ✔ setGroup 먼저 호출 후 mint 호출 시 groupTotalSupply 정상 적용 여부 (49ms)
      Abnormal Case
        ✔ setGroup 중복 호출 시 revert 여부 (65ms)
        ✔ groupId를 0으로 적용시키려는 경우 revert 여부 (41ms)
    changeGroup
      Normal Case
        ✔ changeGroup 호출 시 groupId 정상 변경 여부
        ✔ changeGroup 호출 시 groupTotalSupply 정상 적용 여부
      Abnormal Case
        ✔ group이 없는 경우 changeGroup 호출 시 revert 여부
        ✔ groupId를 0으로 적용시키려는 경우 revert 여부
    ETC
      burn
        ✔ group 매핑 후 burn 호출 시 정상 적용 여부
        ✔ group 매핑 후 수량이 부족한 경우
        ✔ group 매핑 전 burn 호출 시 정상 적용 여부 (44ms)
        ✔ group 매핑 전 수량이 부족한 경우 (43ms)
```