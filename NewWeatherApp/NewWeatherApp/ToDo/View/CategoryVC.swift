//
//  TodListVC.swift
//  NewWeatherApp
//
//  Created by Arun on 04/10/23.
//

import UIKit
import Combine

class CategoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel : CategoryViewModel!
    private var backgroundGradient: CAGradientLayer!
    private var cancellables = Set<AnyCancellable>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind(viewModel.outuputs)
        viewModel.inputs.loadCategories()
        // Do any additional setup after loading the view.
    }
    func setupView(){
        configureBackground()
        let buttonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), 
                                         style: .plain, target: self,
                                         action:  #selector(addCategoryAction))
        buttonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = buttonItem
        self.navigationController?.navigationBar.backItem?.backButtonTitle = "Weather"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "To Do"
        self.navigationItem.titleView?.tintColor = .white
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil),
                           forCellReuseIdentifier: "CategoryCell")
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
        

    }
    
    private func bind(_ outputs: CategoryViewModelOutputType) {
      
        outputs
            .tableDataSource
            .sink { [weak self] dataSource in
                dataSource.tableView = self?.tableView
                self?.tableView.dataSource = dataSource
                self?.tableView.delegate = dataSource
            }
            .store(in: &cancellables)
    }
    private func configureBackground() {
        backgroundGradient = CAGradientLayer.gradientLayer(in: view.bounds)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
    @objc func addCategoryAction(){
        var textField = UITextField()
        let listNames = viewModel.categories.map { $0.name }
        let alert = UIAlertController(title: "Add new list", message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add list", style: .default){ _ in
            let newListName = textField.text!.trimmingCharacters(in: 
                    .whitespacesAndNewlines)
            
            if !newListName.isEmpty && !listNames.contains(newListName){
                self.viewModel.inputs.didPressAdd(categoryName: newListName)
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            self.dismiss(animated: true)
        }))
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "list name"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
}
