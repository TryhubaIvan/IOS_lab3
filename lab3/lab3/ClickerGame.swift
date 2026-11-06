import Foundation

class Upgrade
{
    private let baseCost: Int
    private(set) var level = 0

    init(baseCost: Int)
    {
        self.baseCost = baseCost
    }

    var cost: Int
    {
        return Int((Double(baseCost) * pow(1.5, Double(level))).rounded())
    }

    func levelUp()
    {
        level += 1
    }
}

class Game
{
    private(set) var coins = 0
    private(set) var clicks = 0

    let clickUpgrade = Upgrade(baseCost: 10)     // +1 за клік
    let passiveUpgrade = Upgrade(baseCost: 50)   // +2 за секунду
    let bonusUpgrade = Upgrade(baseCost: 200)    // +50 за кожні 10 кліків

    var coinsPerClick: Int
    {
        return 1 + clickUpgrade.level
    }

    var coinsPerSecond: Int
    {
        return passiveUpgrade.level * 2
    }

    var bonusPerTenClicks: Int
    {
        return bonusUpgrade.level * 50
    }

    func click()
    {
        clicks += 1
        coins += coinsPerClick

        if (clicks % 10 == 0)
        {
            coins += bonusPerTenClicks
        }
    }

    func tick()
    {
        coins += coinsPerSecond
    }

    func buy(_ upgrade: Upgrade)
    {
        if (coins < upgrade.cost)
        {
            return
        }

        coins -= upgrade.cost
        upgrade.levelUp()
    }
}
