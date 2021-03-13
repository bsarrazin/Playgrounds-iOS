import FoundationKit
import Foundation
import PlaygroundSupport
import RxCocoa
import RxSwift
import UIKit

struct Website {
    var author: String
    var desc: String
    var url: URL
}

protocol FooViewModelInput {
    var refresh: AnyObserver<Void> { get }
    var tap: AnyObserver<String> { get }
}

protocol FooViewModelOutput {
    var items: Driver<[Website]> { get }
    var title: Driver<String> { get }
}

class FooViewModel: FooViewModelInput, FooViewModelOutput {

    // MARK: - Inputs
    let refresh: AnyObserver<Void>
    let tap: AnyObserver<String>

    // MARK: - Outputs
    let items: Driver<[Website]>
    let title: Driver<String>

    // MARK: - Properties
    private let bag = DisposeBag()

    // MARK: - Initialization
    init() {
        let tap = Driver<String>.create()
        self.tap = tap.input
        tap.output
            .drive(onNext: {
                print("Tap: ", $0)
            })
            .disposed(by: bag)


        let items = Driver<Void>.create()
        self.refresh = items.input
        self.items = items.output.map {
            [
                Website(
                    author: "Steve Jobs",
                    desc: "This is the website for Apple Inc.",
                    url: URL(string: "https://apple.com")!
                ),
                Website(
                    author: "Larry Page & Sergey Brin",
                    desc: "The most powerful search engine in history.",
                    url: URL(string: "https://google.com")!
                )
            ]
        }

        let title = Driver<String>.create(startingWith: "Hello, World")
        self.title = title.output
    }
}

class FooView: UIView {

    // MARK: - Outlets
    private(set) var button: UIButton!
    private(set) var tableView: UITableView!
    private(set) var titleLabel: UILabel!

    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("This class does not support xib files or storyboards.")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        makeButton()
        makeTableView()
        makeTitleLabel()

        configureConstraints()
    }

    private func makeButton() {
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("PRINT", for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderColor = button.tintColor.cgColor
        button.layer.borderWidth = 1

        addSubview(button)
    }

    private func makeTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.style
        tableView.backgroundColor = .clear

        addSubview(tableView)
        sendSubviewToBack(tableView)
    }

    private func makeTitleLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
        ])
    }

}

class FooViewController: UIViewController, CustomizableView {
    // MARK: - Dependencies
    typealias ViewType = FooView
    var viewModel: ViewModel<FooViewModelInput, FooViewModelOutput>!

    // MARK: - Properties
    private let bag = DisposeBag()
    private var websites: [Website] = []

    // MARK: - Lifecycle
    override func loadView() {
        view = FooView(frame: UIDevice.Metrics.iPhoneX.rect)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

        bindInput()
        bindOutput()

        viewModel.input.refresh.onNext(())
    }

    private func configureView() {
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
    }

    private func bindInput() {
        customView.button.rx.tap
            .map { "print button tapped" }
            .bind(to: viewModel.input.tap)
            .disposed(by: bag)
    }

    private func bindOutput() {
        viewModel.output.title
            .drive(customView.titleLabel.rx.text)
            .disposed(by: bag)

        viewModel.output.items
            .drive(onNext: { [unowned self] websites in
                self.websites = websites
                self.customView.tableView.reloadData()
            })
            .disposed(by: bag)
    }
}

extension FooViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        let website = websites[indexPath.row]
        cell.textLabel?.text = website.desc
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Foo"
    }
}

extension FooViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}





// MARK: - Playground Support
let fooViewModel = FooViewModel()
let viewModel = ViewModel<FooViewModelInput, FooViewModelOutput>(input: fooViewModel, output: fooViewModel)
let viewController = FooViewController()
viewController.viewModel = viewModel
PlaygroundPage.current.liveView = viewController.view
print("END")
