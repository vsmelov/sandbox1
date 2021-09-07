from brownie import BitClusterNordToken, A, B


def test_gas(admin):
    a = A.deploy(2, {'from': admin})
    b = B.deploy(2, {'from': admin})
    tx_a = a.stub(2, {'from': admin})
    tx_b = b.stub(2, {'from': admin})
    tx_a.info()
    tx_b.info()
    assert False
