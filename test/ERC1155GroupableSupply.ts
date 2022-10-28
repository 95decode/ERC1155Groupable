import { expect } from "chai";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ERC1155PresetGroupSupply, ERC1155PresetGroupSupply__factory } from "../typechain-types"

let accounts: SignerWithAddress[];

let ERC1155PresetGroupSupply: ERC1155PresetGroupSupply;
let ERC1155PresetGroupSupply_factory: ERC1155PresetGroupSupply__factory;

describe("ERC1155GroupableSupply", () => {
    before(async () => {
        accounts = await ethers.getSigners();
        ERC1155PresetGroupSupply_factory = await ethers.getContractFactory("ERC1155PresetGroupSupply");
    });

    beforeEach(async () => {
        ERC1155PresetGroupSupply = await ERC1155PresetGroupSupply_factory.deploy();
        await ERC1155PresetGroupSupply.deployed();
    });

    after(async () => {
        await ERC1155PresetGroupSupply.setGroupURI(0, "Mock");
        expect(await ERC1155PresetGroupSupply.groupURI(0)).to.equal("Mock");
    });

    describe("setGroup", () => {
        describe("Normal Case", () => {
            it("setGroup 호출 시 groupId 정상 등록 여부", async () => {
                await ERC1155PresetGroupSupply.mint(accounts[0].address, 1, 1, "0x00");
                expect(await ERC1155PresetGroupSupply.groupID(1)).to.equal(0);
                await ERC1155PresetGroupSupply.setGroup(1, 1);
                expect(await ERC1155PresetGroupSupply.groupID(1)).to.equal(1);
                expect(await ERC1155PresetGroupSupply.groupExists(1)).to.equal(true);
            });

            it("setGroup 호출 시 groupTotalSupply 정상 적용 여부", async () => {
                expect(await ERC1155PresetGroupSupply.totalSupply(1)).to.equal(0);
                await ERC1155PresetGroupSupply.mint(accounts[0].address, 1, 1, "0x00");
                expect(await ERC1155PresetGroupSupply.totalSupply(1)).to.equal(1);
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1)).to.equal(0);
                await ERC1155PresetGroupSupply.setGroup(1, 1);
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1)).to.equal(1);
            });

            it("setGroup 먼저 호출 후 mint 호출 시 groupTotalSupply 정상 적용 여부", async () => {
                await ERC1155PresetGroupSupply.setGroup(1, 1);
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1)).to.equal(0);
                await ERC1155PresetGroupSupply.mint(accounts[0].address, 1, 1, "0x00");
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1)).to.equal(1);
            });
        });

        describe("Abnormal Case", () => {
            it("setGroup 중복 호출 시 revert 여부", async () => {
                await ERC1155PresetGroupSupply.mint(accounts[0].address, 1, 1, "0x00");
                await expect(ERC1155PresetGroupSupply.setGroup(1, 1))
                .to.not.reverted;
                await expect(ERC1155PresetGroupSupply.setGroup(1, 1))
                .to.be.revertedWith(
                    "ERC1155Groupable: token Id is aleady grouped");
            });

            it("groupId를 0으로 적용시키려는 경우 revert 여부", async () => {
                await ERC1155PresetGroupSupply.mint(accounts[0].address, 1, 1, "0x00");
                await expect(ERC1155PresetGroupSupply.setGroup(1, 0))
                .to.be.revertedWith(
                    "ERC1155Groupable: group Id must not be zero");
            });
        });
    });

    describe("changeGroup", () => {
        beforeEach(async () => {
            await ERC1155PresetGroupSupply.mint(accounts[0].address, 1, 1, "0x00");
            await ERC1155PresetGroupSupply.setGroup(1, 1);
            expect(await ERC1155PresetGroupSupply.groupID(1))
            .to.equal(1);
        });

        describe("Normal Case", () => {
            it("changeGroup 호출 시 groupId 정상 변경 여부", async () => {
                await ERC1155PresetGroupSupply.changeGroup(1, 2);
                expect(await ERC1155PresetGroupSupply.groupID(1))
                .to.equal(2);
            });

            it("changeGroup 호출 시 groupTotalSupply 정상 적용 여부", async () => {
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1))
                .to.equal(1);
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(2))
                .to.equal(0);
                await ERC1155PresetGroupSupply.changeGroup(1, 2);
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1))
                .to.equal(0);
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(2))
                .to.equal(1);
            });
        });

        describe("Abnormal Case", () => {
            it("group이 없는 경우 changeGroup 호출 시 revert 여부", async () => {
                await expect(ERC1155PresetGroupSupply.changeGroup(2, 2))
                .to.be.revertedWith("ERC1155Groupable: token Id is not grouped");
            });

            it("groupId를 0으로 적용시키려는 경우 revert 여부", async () => {
                await expect(ERC1155PresetGroupSupply.changeGroup(1, 0))
                .to.be.revertedWith("ERC1155Groupable: group Id must not be zero");
            });
        });
    });

    describe("ETC", () => {
        beforeEach(async () => {
            await ERC1155PresetGroupSupply.mint(accounts[0].address, 1, 2, "0x00");
            await ERC1155PresetGroupSupply.setGroup(1, 1);
            expect(await ERC1155PresetGroupSupply.groupID(1))
            .to.equal(1);
        });

        describe("burn", () => {
            it("group 매핑 후 burn 호출 시 정상 적용 여부", async () => {
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1))
                .to.equal(2);
                await ERC1155PresetGroupSupply.burn(accounts[0].address, 1, 1);
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1))
                .to.equal(1);
            });

            it("group 매핑 후 수량이 부족한 경우", async () => {
                expect(await ERC1155PresetGroupSupply.groupTotalSupply(1))
                .to.equal(2);
                await expect(ERC1155PresetGroupSupply.burn(accounts[0].address, 1, 3))
                .to.be.revertedWith("ERC1155: burn amount exceeds groupTotalSupply");
            });

            it("group 매핑 전 burn 호출 시 정상 적용 여부", async () => {
                await ERC1155PresetGroupSupply.mint(accounts[0].address, 2, 2, "0x00");
                expect(await ERC1155PresetGroupSupply.totalSupply(2))
                .to.equal(2);
                await ERC1155PresetGroupSupply.burn(accounts[0].address, 2, 1);
                expect(await ERC1155PresetGroupSupply.totalSupply(2))
                .to.equal(1);
            });

            it("group 매핑 전 수량이 부족한 경우", async () => {
                await ERC1155PresetGroupSupply.mint(accounts[0].address, 2, 1, "0x00");
                expect(await ERC1155PresetGroupSupply.totalSupply(2))
                .to.equal(1);
                await expect(ERC1155PresetGroupSupply.burn(accounts[0].address, 2, 2))
                .to.be.revertedWith("ERC1155: burn amount exceeds totalSupply");
            });
        });
    });
});