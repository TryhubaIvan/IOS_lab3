import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var passiveButton: UIButton!
    @IBOutlet weak var bonusButton: UIButton!

    private let game = Game()
    private var timer: Timer?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(coinTapped))
        coinImage.addGestureRecognizer(tap)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        { [weak self] _ in
            self?.game.tick()
            self?.updateUI()
        }

        updateUI()
    }

    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()

        if (view.bounds.width > view.bounds.height)
        {
            stackView.axis = .horizontal
        }
        else
        {
            stackView.axis = .vertical
        }
    }

    @objc private func coinTapped()
    {
        game.click()
        updateUI()
        animateCoin()
    }

    @IBAction func clickButtonTapped(_ sender: UIButton)
    {
        game.buy(game.clickUpgrade)
        updateUI()
    }

    @IBAction func passiveButtonTapped(_ sender: UIButton)
    {
        game.buy(game.passiveUpgrade)
        updateUI()
    }

    @IBAction func bonusButtonTapped(_ sender: UIButton)
    {
        game.buy(game.bonusUpgrade)
        updateUI()
    }

    private func updateUI()
    {
        coinsLabel.text = "● \(game.coins)"

        setButton(clickButton, text: "+1 per click", upgrade: game.clickUpgrade)
        
        setButton(passiveButton, text: "+2 per second", upgrade: game.passiveUpgrade)
        
        setButton(bonusButton, text: "+50 per 10 clicks", upgrade: game.bonusUpgrade)
    }

    private func setButton(_ button: UIButton, text: String, upgrade: Upgrade)
    {
        var title = AttributedString("\(text) — ● \(upgrade.cost)")
        title.font = UIFont.boldSystemFont(ofSize: 12)
        title.foregroundColor = UIColor.white

        button.configuration?.attributedTitle = title
        button.isEnabled = (game.coins >= upgrade.cost)
    }

    private func animateCoin()
    {
        UIView.animate(withDuration: 0.1, animations:
        {
            self.coinImage.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        })
        { _ in
            UIView.animate(withDuration: 0.1)
            {
                self.coinImage.transform = .identity
            }
        }
    }
}
