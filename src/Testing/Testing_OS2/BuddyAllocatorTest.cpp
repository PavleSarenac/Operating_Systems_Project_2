#include "../../../h/Testing/Testing_OS2/BuddyAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"

void BuddyAllocatorTest::runTests() {
    printString("Running tests for BuddyAllocator.\n\n");
    assertGetExponentForNumberOfBlocks();
    assertGetExponentForNumberOfBytes();
    assertSetup();
    assertGetBlockAddress();
    assertAllocate();
}

void BuddyAllocatorTest::assertGetExponentForNumberOfBlocks() {
    printString("Testing getExponentForNumberOfBlocks method.\n");
    bool testPassed = true;

    int numberOfBlocks1 = 0;
    int expectedExponent1 = 0;
    int actualExponent1 = BuddyAllocator::getExponentForNumberOfBlocks(numberOfBlocks1);
    if (expectedExponent1 != actualExponent1) {
        printString("Assert 1 has failed. Expected ");
        printInt(expectedExponent1);
        printString(", but actually got ");
        printInt(actualExponent1);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBlocks2 = 1;
    int expectedExponent2 = 0;
    int actualExponent2 = BuddyAllocator::getExponentForNumberOfBlocks(numberOfBlocks2);
    if (expectedExponent2 != actualExponent2) {
        printString("Assert 2 has failed. Expected ");
        printInt(expectedExponent2);
        printString(", but actually got ");
        printInt(actualExponent2);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBlocks3 = 2;
    int expectedExponent3 = 1;
    int actualExponent3 = BuddyAllocator::getExponentForNumberOfBlocks(numberOfBlocks3);
    if (expectedExponent3 != actualExponent3) {
        printString("Assert 3 has failed. Expected ");
        printInt(expectedExponent3);
        printString(", but actually got ");
        printInt(actualExponent3);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBlocks4 = 3;
    int expectedExponent4 = 2;
    int actualExponent4 = BuddyAllocator::getExponentForNumberOfBlocks(numberOfBlocks4);
    if (expectedExponent4 != actualExponent4) {
        printString("Assert 4 has failed. Expected ");
        printInt(expectedExponent4);
        printString(", but actually got ");
        printInt(actualExponent4);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBlocks5 = 4;
    int expectedExponent5 = 2;
    int actualExponent5 = BuddyAllocator::getExponentForNumberOfBlocks(numberOfBlocks5);
    if (expectedExponent5 != actualExponent5) {
        printString("Assert 5 has failed. Expected ");
        printInt(expectedExponent5);
        printString(", but actually got ");
        printInt(actualExponent5);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBlocks6 = 5;
    int expectedExponent6 = 3;
    int actualExponent6 = BuddyAllocator::getExponentForNumberOfBlocks(numberOfBlocks6);
    if (expectedExponent6 != actualExponent6) {
        printString("Assert 6 has failed. Expected ");
        printInt(expectedExponent6);
        printString(", but actually got ");
        printInt(actualExponent6);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBlocks7 = 2048;
    int expectedExponent7 = 11;
    int actualExponent7 = BuddyAllocator::getExponentForNumberOfBlocks(numberOfBlocks7);
    if (expectedExponent7 != actualExponent7) {
        printString("Assert 7 has failed. Expected ");
        printInt(expectedExponent7);
        printString(", but actually got ");
        printInt(actualExponent7);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBlocks8 = 2049;
    int expectedExponent8 = 12;
    int actualExponent8 = BuddyAllocator::getExponentForNumberOfBlocks(numberOfBlocks8);
    if (expectedExponent8 != actualExponent8) {
        printString("Assert 8 has failed. Expected ");
        printInt(expectedExponent8);
        printString(", but actually got ");
        printInt(actualExponent8);
        printString(".\n\n");
        testPassed = false;
    }

    if (testPassed) {
        printString("All assertions for getExponentForNumberOfBlocks method have passed.\n\n");
    } else {
        printString("*****There are failed assertions for getExponentForNumberOfBlocks method*****\n\n");
    }
}

void BuddyAllocatorTest::assertGetExponentForNumberOfBytes() {
    printString("Testing getExponentForNumberOfBytes method.\n");
    bool testPassed = true;

    int numberOfBytes1 = 0;
    int expectedExponent1 = 0;
    int actualExponent1 = BuddyAllocator::getExponentForNumberOfBytes(numberOfBytes1);
    if (expectedExponent1 != actualExponent1) {
        printString("Assert 1 has failed. Expected ");
        printInt(expectedExponent1);
        printString(", but actually got ");
        printInt(actualExponent1);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBytes2 = 1;
    int expectedExponent2 = 0;
    int actualExponent2 = BuddyAllocator::getExponentForNumberOfBytes(numberOfBytes2);
    if (expectedExponent2 != actualExponent2) {
        printString("Assert 2 has failed. Expected ");
        printInt(expectedExponent2);
        printString(", but actually got ");
        printInt(actualExponent2);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBytes3 = 4096;
    int expectedExponent3 = 0;
    int actualExponent3 = BuddyAllocator::getExponentForNumberOfBytes(numberOfBytes3);
    if (expectedExponent3 != actualExponent3) {
        printString("Assert 3 has failed. Expected ");
        printInt(expectedExponent3);
        printString(", but actually got ");
        printInt(actualExponent3);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBytes4 = 4097;
    int expectedExponent4 = 1;
    int actualExponent4 = BuddyAllocator::getExponentForNumberOfBytes(numberOfBytes4);
    if (expectedExponent4 != actualExponent4) {
        printString("Assert 4 has failed. Expected ");
        printInt(expectedExponent4);
        printString(", but actually got ");
        printInt(actualExponent4);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBytes5 = 10000;
    int expectedExponent5 = 2;
    int actualExponent5 = BuddyAllocator::getExponentForNumberOfBytes(numberOfBytes5);
    if (expectedExponent5 != actualExponent5) {
        printString("Assert 5 has failed. Expected ");
        printInt(expectedExponent5);
        printString(", but actually got ");
        printInt(actualExponent5);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBytes6 = 69632;
    int expectedExponent6 = 5;
    int actualExponent6 = BuddyAllocator::getExponentForNumberOfBytes(numberOfBytes6);
    if (expectedExponent6 != actualExponent6) {
        printString("Assert 6 has failed. Expected ");
        printInt(expectedExponent6);
        printString(", but actually got ");
        printInt(actualExponent6);
        printString(".\n\n");
        testPassed = false;
    }

    int numberOfBytes7 = 65536;
    int expectedExponent7 = 4;
    int actualExponent7 = BuddyAllocator::getExponentForNumberOfBytes(numberOfBytes7);
    if (expectedExponent7 != actualExponent7) {
        printString("Assert 7 has failed. Expected ");
        printInt(expectedExponent7);
        printString(", but actually got ");
        printInt(actualExponent7);
        printString(".\n\n");
        testPassed = false;
    }

    if (testPassed) {
        printString("All assertions for getExponentForNumberOfBytes method have passed.\n\n");
    } else {
        printString("*****There are failed assertions for getExponentForNumberOfBytes method*****\n\n");
    }
}

void BuddyAllocatorTest::assertSetup() {
    printString("Testing setup method.\n");
    bool testPassed = true;

    BuddyAllocator::getInstance().setup(
            reinterpret_cast<void*>(MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator()),
            static_cast<int>(MemoryAllocationHelperFunctions::getTotalNumberOfMemoryBlocksForBuddyAllocator()));

    int expectedMaxUsedExponent = 11;
    int actualMaxUsedExponent = BuddyAllocator::getInstance().maxUsedExponent;
    if (expectedMaxUsedExponent != actualMaxUsedExponent) {
        printString("Assert 1 has failed. Expected ");
        printInt(expectedMaxUsedExponent);
        printString(", but actually got ");
        printInt(actualMaxUsedExponent);
        printString(".\n\n");
        testPassed = false;
    }

    int expectedMaxUsedNumberOfBlocksOfSameSize = 2048;
    int actualMaxUsedNumberOfBlocksOfSameSize = BuddyAllocator::getInstance().maxUsedNumberOfBlocksOfSameSize;
    if (expectedMaxUsedNumberOfBlocksOfSameSize != actualMaxUsedNumberOfBlocksOfSameSize) {
        printString("Assert 2 has failed. Expected ");
        printInt(expectedMaxUsedNumberOfBlocksOfSameSize);
        printString(", but actually got ");
        printInt(actualMaxUsedNumberOfBlocksOfSameSize);
        printString(".\n\n");
        testPassed = false;
    }

    if (testPassed) {
        printString("All assertions for setup method have passed.\n\n");
    } else {
        printString("*****There are failed assertions for setup method*****\n\n");
    }
}

void BuddyAllocatorTest::assertGetBlockAddress() {
    printString("Testing getBlockAddress method.\n");
    bool testPassed = true;

    size_t firstAlignedAddress = MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator();

    size_t expectedBlockAddress1 = firstAlignedAddress;
    auto actualBlockAddress1 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().getBlockAddress(0, 0));
    if (expectedBlockAddress1 != actualBlockAddress1) {
        printString("Assert 1 has failed. Expected ");
        printInt(expectedBlockAddress1, 16);
        printString(", but actually got ");
        printInt(actualBlockAddress1, 16);
        printString(".\n\n");
        testPassed = false;
    }

    size_t expectedBlockAddress2 = firstAlignedAddress + BLOCK_SIZE;
    auto actualBlockAddress2 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().getBlockAddress(0, 1));
    if (expectedBlockAddress2 != actualBlockAddress2) {
        printString("Assert 2 has failed. Expected ");
        printInt(expectedBlockAddress2, 16);
        printString(", but actually got ");
        printInt(actualBlockAddress2, 16);
        printString(".\n\n");
        testPassed = false;
    }

    size_t expectedBlockAddress3 = firstAlignedAddress + 2047 * BLOCK_SIZE;
    auto actualBlockAddress3 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().getBlockAddress(0, 2047));
    if (expectedBlockAddress3 != actualBlockAddress3) {
        printString("Assert 3 has failed. Expected ");
        printInt(expectedBlockAddress3, 16);
        printString(", but actually got ");
        printInt(actualBlockAddress3, 16);
        printString(".\n\n");
        testPassed = false;
    }

    size_t expectedBlockAddress4 = firstAlignedAddress
            + BuddyAllocator::getInstance().maxUsedNumberOfBlocksOfSameSize * BLOCK_SIZE;
    auto actualBlockAddress4 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().getBlockAddress(1, 0));
    if (expectedBlockAddress4 != actualBlockAddress4) {
        printString("Assert 4 has failed. Expected ");
        printInt(expectedBlockAddress4, 16);
        printString(", but actually got ");
        printInt(actualBlockAddress4, 16);
        printString(".\n\n");
        testPassed = false;
    }

    size_t expectedBlockAddress5 = firstAlignedAddress
            + 9 * BuddyAllocator::getInstance().maxUsedNumberOfBlocksOfSameSize * BLOCK_SIZE
            + 1452 * BLOCK_SIZE;
    auto actualBlockAddress5 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().getBlockAddress(9, 1452));
    if (expectedBlockAddress5 != actualBlockAddress5) {
        printString("Assert 5 has failed. Expected ");
        printInt(expectedBlockAddress5, 16);
        printString(", but actually got ");
        printInt(actualBlockAddress5, 16);
        printString(".\n\n");
        testPassed = false;
    }


    if (testPassed) {
        printString("All assertions for getBlockAddress method have passed.\n\n");
    } else {
        printString("*****There are failed assertions for getBlockAddress method*****\n\n");
    }
}

void BuddyAllocatorTest::assertAllocate() {
    printString("Testing allocate method.\n");
    bool testPassed = true;

    int numberOfBytes1 = 0;
    int expectedExponent1 = 0;
    int actualExponent1 = BuddyAllocator::getExponentForNumberOfBytes(numberOfBytes1);
    if (expectedExponent1 != actualExponent1) {
        printString("Assert 1 has failed. Expected ");
        printInt(expectedExponent1);
        printString(", but actually got ");
        printInt(actualExponent1);
        printString(".\n\n");
        testPassed = false;
    }

    if (testPassed) {
        printString("All assertions for allocate method have passed.\n\n");
    } else {
        printString("*****There are failed assertions for allocate method*****\n\n");
    }
}