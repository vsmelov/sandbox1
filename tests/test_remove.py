from brownie import RemoveMock
from brownie import reverts


def cutStr(_value):
    return _value.lstrip('\x00').encode()


def test_remove(admin):
    poolName = "duplicated".encode()
    propertyName = "ab".encode()
    propertyValue = "abab".encode()
    contract = RemoveMock.deploy({'from': admin})
    contract.addPool(poolName)

    assert contract.getPoolEnabled(poolName)

    contract.addProperty(poolName, propertyName, propertyValue)
    assert list(map(cutStr, contract.getPropertyNames(poolName))) == [propertyName]
    _value = contract.getPropertyString(poolName, propertyName)
    assert _value.lstrip('\x00').encode() == propertyValue

    contract.removePool(poolName)
    assert not contract.getPoolEnabled(poolName)
    actualPropertyName = list(map(cutStr, contract.getPropertyNames(poolName)))
    assert actualPropertyName == []
    with reverts('EnumerableSet: index out of bounds'):
        actualPropertyName0 = cutStr(contract.getPropertyNameByIndex(poolName, 0))
    _value = contract.getPropertyString(poolName, propertyName)
    assert _value.lstrip('\x00').encode() == propertyValue
