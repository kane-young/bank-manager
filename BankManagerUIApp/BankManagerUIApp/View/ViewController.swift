//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private var evaluateLabel: UILabel = UILabel()
    private var taskLabel: UILabel = UILabel()
    private var waitLabel: UILabel = UILabel()
    private var addCustomersButton: UIButton = UIButton()
    private var resetButton: UIButton = UIButton()
    private lazy var buttonStackView: UIStackView = UIStackView(arrangedSubviews: [addCustomersButton, resetButton])
    
    private var taskCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var waitCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var evaluateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        configureButtons()
        setButtonsConstraints()

        configureLabels()
        setLabelsConstraints()

        configureCollectionViews()
        setCollectionViewsConstraints()
        setupFlowLayout()
    }
    
    private func configureCollectionViews() {
        taskCollectionView.translatesAutoresizingMaskIntoConstraints = false
        waitCollectionView.translatesAutoresizingMaskIntoConstraints = false
        evaluateLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCollectionView.backgroundColor = .systemGray
        waitCollectionView.backgroundColor = .red
        evaluateCollectionView.backgroundColor = .blue
        
        taskCollectionView.dataSource = self
        waitCollectionView.dataSource = self
        evaluateCollectionView.dataSource = self
        view.addSubview(taskCollectionView)
        view.addSubview(waitCollectionView)
        view.addSubview(evaluateCollectionView)
    }
    
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let width = UIScreen.main.bounds.width / 10
        flowLayout.itemSize = CGSize(width: width , height: self.taskLabel.bounds.height)
        flowLayout.scrollDirection = .horizontal
        self.taskCollectionView.collectionViewLayout = flowLayout
        self.waitCollectionView.collectionViewLayout = flowLayout
        self.evaluateCollectionView.collectionViewLayout = flowLayout
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
    }
    
    private func configureButtons() {
        view.addSubview(buttonStackView)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        addCustomersButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addCustomersButton.setTitle("고객 10명 추가", for: .normal)
        resetButton.setTitle("초기화", for: .normal)
        
        resetButton.setTitleColor(.systemRed, for: .normal)
        addCustomersButton.setTitleColor(.systemBlue, for: .normal)
        
        addCustomersButton.addTarget(self, action: #selector(addCustomers(_:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(reset(_:)), for: .touchUpInside)
    }
    
    private func configureLabels() {
        view.addSubview(waitLabel)
        view.addSubview(taskLabel)
        view.addSubview(evaluateLabel)
        
        waitLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        evaluateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        waitLabel.backgroundColor = .systemPurple
        taskLabel.backgroundColor = .systemGreen
        evaluateLabel.backgroundColor = .systemOrange
        
        waitLabel.textAlignment = .center
        taskLabel.textAlignment = .center
        evaluateLabel.textAlignment = .center
        
        waitLabel.textColor = .white
        taskLabel.textColor = .white
        evaluateLabel.textColor = .white
        
        waitLabel.text = "대기중"
        taskLabel.text = "업무중"
        evaluateLabel.text = "심사중"
    }
    
    private func setButtonsConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setLabelsConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            evaluateLabel.widthAnchor.constraint(equalToConstant: 70),
            taskLabel.widthAnchor.constraint(equalToConstant: 70),
            waitLabel.widthAnchor.constraint(equalToConstant: 70),
            evaluateLabel.heightAnchor.constraint(equalTo: taskLabel.heightAnchor),
            taskLabel.heightAnchor.constraint(equalTo: waitLabel.heightAnchor),
            evaluateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            taskLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            waitLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            evaluateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            taskLabel.topAnchor.constraint(equalTo: evaluateLabel.bottomAnchor),
            waitLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor),
            waitLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor)
        ])
    }
    
    private func setCollectionViewsConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            taskCollectionView.topAnchor.constraint(equalTo: taskLabel.topAnchor),
            taskCollectionView.bottomAnchor.constraint(equalTo: taskLabel.bottomAnchor),
            taskCollectionView.leadingAnchor.constraint(equalTo: taskLabel.trailingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
          
            evaluateCollectionView.topAnchor.constraint(equalTo: evaluateLabel.topAnchor),
            evaluateCollectionView.bottomAnchor.constraint(equalTo: evaluateLabel.bottomAnchor),
            evaluateCollectionView.leadingAnchor.constraint(equalTo: evaluateLabel.trailingAnchor),
            evaluateCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
          
            waitCollectionView.topAnchor.constraint(equalTo: waitLabel.topAnchor),
            waitCollectionView.bottomAnchor.constraint(equalTo: waitLabel.bottomAnchor),
            waitCollectionView.leadingAnchor.constraint(equalTo: waitLabel.trailingAnchor),
            waitCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    @objc private func addCustomers(_ sender: UIButton) {
        print("addCustomer")
    }
    
    @objc private func reset(_ sender: UIButton) {
        print("reset")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
