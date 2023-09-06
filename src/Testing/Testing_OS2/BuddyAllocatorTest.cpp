#include "../../../h/Testing/Testing_OS2/BuddyAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"

void BuddyAllocatorTest::runTests() {
    printString("Running tests for BuddyAllocator.\n\n");
    if (!assertGetExponentForNumberOfBlocks() ||
        !assertGetExponentForNumberOfBytes() ||
        !assertSetup() ||
        !assertGetBlockAddress() ||
        !assertAllocate() ||
        !assertDeallocate()) {
        printString("*****Some tests for BuddyAllocator have failed*****\n\n");
    } else {
        printString("All tests for BuddyAllocator have passed.\n\n");
    }
}

bool BuddyAllocatorTest::assertGetExponentForNumberOfBlocks() {
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
        return true;
    } else {
        printString("*****There are failed assertions for getExponentForNumberOfBlocks method*****\n\n");
        return false;
    }
}

bool BuddyAllocatorTest::assertGetExponentForNumberOfBytes() {
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
        return true;
    } else {
        printString("*****There are failed assertions for getExponentForNumberOfBytes method*****\n\n");
        return false;
    }
}

bool BuddyAllocatorTest::assertSetup() {
    printString("Testing setup method.\n");
    bool testPassed = true;

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

    size_t expectedNumberOfFreeBlocks = 1;
    size_t actualNumberOfFreeBlocks = getNumberOfFreeBlocks();
    if (expectedNumberOfFreeBlocks != actualNumberOfFreeBlocks) {
        printString("Assert 3 has failed. Expected ");
        printInt(expectedNumberOfFreeBlocks);
        printString(", but actually got ");
        printInt(actualNumberOfFreeBlocks);
        printString(".\n\n");
        testPassed = false;
    }

    bool isNumberOfBlocksOfSameSizeArrayOkay = true;
    size_t expectedNumberOfBlocksOfSameSize = 2048, actualNumberOfBlocksOfSameSize;
    for (int i = 0; i <= BuddyAllocator::getInstance().maxUsedExponent; i++, expectedNumberOfBlocksOfSameSize >>= 1) {
        actualNumberOfBlocksOfSameSize = BuddyAllocator::getInstance().numberOfBlocksOfSameSize[i];
        if (expectedMaxUsedNumberOfBlocksOfSameSize != actualMaxUsedNumberOfBlocksOfSameSize) {
            isNumberOfBlocksOfSameSizeArrayOkay = false;
            break;
        }
    }
    if (!isNumberOfBlocksOfSameSizeArrayOkay) {
        printString("Assert 4 has failed. Expected ");
        printInt(expectedNumberOfBlocksOfSameSize);
        printString(", but actually got ");
        printInt(actualNumberOfBlocksOfSameSize);
        printString(".\n\n");
        testPassed = false;
    }

    if (testPassed) {
        printString("All assertions for setup method have passed.\n\n");
        return true;
    } else {
        printString("*****There are failed assertions for setup method*****\n\n");
        return false;
    }
}

bool BuddyAllocatorTest::assertGetBlockAddress() {
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

    size_t expectedBlockAddress4 = firstAlignedAddress;
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
            + 60 * (BLOCK_SIZE << 5);
    auto actualBlockAddress5 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().getBlockAddress(5, 60));
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
        return true;
    } else {
        printString("*****There are failed assertions for getBlockAddress method*****\n\n");
        return false;
    }
}

bool BuddyAllocatorTest::assertAllocate() {
    printString("Testing allocate method.\n");
    bool testPassed = true;

    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    size_t expectedBlockAddress1 = 0;
    auto actualBlockAddress1 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().allocate(0));
    if (expectedBlockAddress1 != actualBlockAddress1) {
        printString("Assert 1 has failed. Expected ");
        printInt(expectedBlockAddress1);
        printString(", but actually got ");
        printInt(actualBlockAddress1);
        printString(".\n\n");
        testPassed = false;
    }

    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    size_t expectedBlockAddress2 = MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator();
    auto actualBlockAddress2 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().allocate(1));
    bool areFreedBlocksInCorrectPositions = true;
    for (int i = 0; i < BuddyAllocator::getInstance().maxUsedExponent; i++) {
        if (!BuddyAllocator::getInstance().isBlockFree[i][1]) {
            areFreedBlocksInCorrectPositions = false;
            break;
        }
    }
    if (expectedBlockAddress2 != actualBlockAddress2 || !areFreedBlocksInCorrectPositions
        || getNumberOfFreeBlocks() != 11 || BuddyAllocator::getInstance().isBlockFree[11][0]) {
        printString("Assert 2 has failed. Expected ");
        printInt(expectedBlockAddress2);
        printString(", but actually got ");
        printInt(actualBlockAddress2);
        printString(".\n\n");
        testPassed = false;
    }

    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    size_t expectedBlockAddress3 = MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator();
    auto actualBlockAddress3 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().allocate(2048 * BLOCK_SIZE));
    if (expectedBlockAddress3 != actualBlockAddress3 || getNumberOfFreeBlocks() != 0) {
        printString("Assert 3 has failed. Expected ");
        printInt(expectedBlockAddress3);
        printString(", but actually got ");
        printInt(actualBlockAddress3);
        printString(".\n\n");
        testPassed = false;
    }

    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    bool areAllBlockAddressesCorrect = true;
    size_t expectedBlockAddress4 = MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator();
    for (int i = 0; i < 2048; i++, expectedBlockAddress4 += BLOCK_SIZE) {
        auto actualBlockAddress4 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().allocate(BLOCK_SIZE));
        if (expectedBlockAddress4 != actualBlockAddress4) {
            areFreedBlocksInCorrectPositions = false;
            break;
        }
    }
    if (!areAllBlockAddressesCorrect || getNumberOfFreeBlocks() != 0) {
        printString("Assert 4 has failed");
        printString(".\n\n");
        testPassed = false;
    }

    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    size_t expectedBlockAddress51 = MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator();
    auto actualBlockAddress51 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().allocate(1024 * BLOCK_SIZE));
    size_t expectedBlockAddress52 = MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator()
            + 1024 * BLOCK_SIZE;
    auto actualBlockAddress52 = reinterpret_cast<size_t>(BuddyAllocator::getInstance().allocate(BLOCK_SIZE));
    if (expectedBlockAddress51 != actualBlockAddress51 || expectedBlockAddress52 != actualBlockAddress52
        || getNumberOfFreeBlocks() != 10) {
        printString("Assert 5 has failed. Expected ");
        printInt(expectedBlockAddress51);
        printString(", but actually got ");
        printInt(actualBlockAddress51);
        printString(".\n\n");
        testPassed = false;
    }

    if (testPassed) {
        printString("All assertions for allocate method have passed.\n\n");
        return true;
    } else {
        printString("*****There are failed assertions for allocate method*****\n\n");
        return false;
    }
}

bool BuddyAllocatorTest::assertDeallocate() {
    printString("Testing deallocate method.\n");
    bool testPassed = true;

    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    size_t numberOfFreeBlocksBeforeAllocation1 = getNumberOfFreeBlocks();
    void* ptr1 = BuddyAllocator::getInstance().allocate(15690);
    void* ptr2 = BuddyAllocator::getInstance().allocate(50 * BLOCK_SIZE);
    void* ptr3 = BuddyAllocator::getInstance().allocate(103094);
    void* ptr4 = BuddyAllocator::getInstance().allocate(523489);
    void* ptr5 = BuddyAllocator::getInstance().allocate(88888);
    BuddyAllocator::getInstance().deallocate(ptr1, 15690);
    BuddyAllocator::getInstance().deallocate(ptr2, 50 * BLOCK_SIZE);
    BuddyAllocator::getInstance().deallocate(ptr3, 103094);
    BuddyAllocator::getInstance().deallocate(ptr4, 523489);
    BuddyAllocator::getInstance().deallocate(ptr5, 88888);
    size_t numberOfFreeBlocksAfterDeallocation1 = getNumberOfFreeBlocks();
    if (numberOfFreeBlocksBeforeAllocation1 != numberOfFreeBlocksAfterDeallocation1) {
        printString("Assert 1 has failed. Expected ");
        printInt(numberOfFreeBlocksBeforeAllocation1);
        printString(", but actually got ");
        printInt(numberOfFreeBlocksAfterDeallocation1);
        printString(".\n\n");
        testPassed = false;
        testPassed = false;
    }

    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    size_t numberOfFreeBlocksBeforeAllocation2 = getNumberOfFreeBlocks();
    void* ptr11 = BuddyAllocator::getInstance().allocate(1);
    BuddyAllocator::getInstance().deallocate(ptr11, 1);
    size_t numberOfFreeBlocksAfterDeallocation2 = getNumberOfFreeBlocks();
    if (numberOfFreeBlocksBeforeAllocation2 != numberOfFreeBlocksAfterDeallocation2) {
        printString("Assert 2 has failed. Expected ");
        printInt(numberOfFreeBlocksBeforeAllocation2);
        printString(", but actually got ");
        printInt(numberOfFreeBlocksAfterDeallocation2);
        printString(".\n\n");
        testPassed = false;
        testPassed = false;
    }

    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    size_t numberOfFreeBlocksBeforeAllocation3 = getNumberOfFreeBlocks();
    typedef struct RandomStruct {
        char c;
        int num1;
        long num2;
        long long num3;
        size_t arr1[150];
    } RandomStruct;
    RandomStruct* randomStructArray[100];
    for (int i = 0; i < 100; i++) {
        randomStructArray[i] = static_cast<RandomStruct*>(BuddyAllocator::getInstance().allocate(sizeof(RandomStruct)));
    }
    for (int i = 0; i < 100; i++) {
        BuddyAllocator::getInstance().deallocate(randomStructArray[i], sizeof(RandomStruct));
    }
    size_t numberOfFreeBlocksAfterDeallocation3 = getNumberOfFreeBlocks();
    if (numberOfFreeBlocksBeforeAllocation3 != numberOfFreeBlocksAfterDeallocation3) {
        printString("Assert 3 has failed. Expected ");
        printInt(numberOfFreeBlocksBeforeAllocation3);
        printString(", but actually got ");
        printInt(numberOfFreeBlocksAfterDeallocation3);
        printString(".\n\n");
        testPassed = false;
        testPassed = false;
    }

    if (testPassed) {
        printString("All assertions for deallocate method have passed.\n\n");
        return true;
    } else {
        printString("*****There are failed assertions for deallocate method*****\n\n");
        return false;
    }
}

size_t BuddyAllocatorTest::getNumberOfFreeBlocks() {
    size_t numberOfFreeBlocks = 0;
    for (int i = 0; i <= BuddyAllocator::getInstance().maxUsedExponent; i++) {
        for (int j = 0; j < BuddyAllocator::getInstance().numberOfBlocksOfSameSize[i]; j++) {
            numberOfFreeBlocks += BuddyAllocator::getInstance().isBlockFree[i][j] ? 1 : 0;
        }
    }
    return numberOfFreeBlocks;
}