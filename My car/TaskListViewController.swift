//
//  ViewController.swift
//  My car
//
//  Created by Kirill Frolovskiy on 05.04.2023.
//

import UIKit
import CoreData

protocol TaskViewControllerDeligate {
  func reloadData()
}

class TaskListViewController: UITableViewController {



  private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  private var taskList: [Task] = []
  private let cellID = "task"

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    view.backgroundColor = .white
    setupNavigationBar()
    fetchData()
  }


  /// ```
  /// Navigation bar setup
  /// ```
  private func setupNavigationBar() {
    title = "Expenses List"
    navigationController?.navigationBar.prefersLargeTitles = true

    let navBarApperance = UINavigationBarAppearance()
    navBarApperance.configureWithOpaqueBackground()
    navBarApperance.backgroundColor = UIColor(red: 124/255, green: 113/255, blue: 212/255, alpha: 1.0)

    navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    navigationController?.navigationBar.standardAppearance = navBarApperance
    navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))

    //цвет всех элемнтов в navigation bar
    navigationController?.navigationBar.tintColor = .white
  }

  @objc private func addNewTask() {

    //    //Создали экземпляр класса нового экрана и вызвали метод present для перехода на него
    //    let taskVS = TaskViewController()
    //    taskVS.delegate = self
    //    present(taskVS, animated: true)
    showAlert(with: "New Task", and: "What do you want to do?")
  }

  private func fetchData() {
    let fetchRequest = Task.fetchRequest()
    do {
      taskList = try viewContext.fetch(fetchRequest)
    } catch  {
      print(error.localizedDescription)
    }
  }
  private func showAlert(with title: String, and message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
      guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
      self.save(task)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    alert.addTextField { textField in
      textField.placeholder = "New Task"
    }
    present(alert, animated: true)
  }

  private func save(_ taskName: String) {
    let task = Task(context: viewContext)
    task.title = taskName
    taskList.append(task)

    let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
    tableView.insertRows(at: [cellIndex], with: .automatic)

    if viewContext.hasChanges {
      do {
        try viewContext.save()
      } catch  {
        print(error.localizedDescription)
      }
    }
//    delegate.reloadData()
//    dismiss(animated: true)
  }
}

extension TaskListViewController: TaskViewControllerDeligate {
  func reloadData() {
    fetchData()
    tableView.reloadData()
  }


}

extension TaskListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    taskList.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    let task = taskList[indexPath.row]
    var content = cell.defaultContentConfiguration()
    content.text = task.title
    cell.contentConfiguration = content
    return cell
  }


}
