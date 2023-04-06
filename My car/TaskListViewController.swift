//
//  ViewController.swift
//  My car
//
//  Created by Kirill Frolovskiy on 05.04.2023.
//

import UIKit

class TaskListViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupNavigationBar()
  }


  /// ```
  /// Navigation bar setup
  /// ```
  private func setupNavigationBar() {
    title = "Expenses List"
    navigationController?.navigationBar.prefersLargeTitles = true

    let navBarApperance = UINavigationBarAppearance()
    navBarApperance.configureWithOpaqueBackground()
    navBarApperance.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 235/255, alpha: 1.0)

    navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    navigationController?.navigationBar.standardAppearance = navBarApperance
    navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))

    //цвет всех элемнтов в navigation bar
    navigationController?.navigationBar.tintColor = .white
  }
//132
  //987
  //432
  @objc private func addNewTask() {

  }
}

