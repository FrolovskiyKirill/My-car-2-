//
//  TaskViewController.swift
//  My car
//
//  Created by Kirill Frolovskiy on 07.04.2023.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {

  var delegate: TaskViewControllerDeligate!

  //Добираемя до метода viewContext находящегося в классе AppDelegate(надо избавиться)
  private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  //Создается экземпляр UITextField с замыканием чтобы сразу задать его параметры.
  private lazy var taskTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "New Task"
    textField.borderStyle = .roundedRect
    return textField
  }()

  private lazy var saveButton: UIButton = {
    createButton(
      withTitle: "Save Task",
      andColor: UIColor(red: 124/255, green: 113/255, blue: 212/255, alpha: 1.0),
      action: UIAction { _ in self.save() })
  }()

  private lazy var cancelButton: UIButton = {
    createButton(
      withTitle: "Cancel",
      andColor: .systemRed,
      action: UIAction { _ in self.dismiss(animated: true) })
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    //    //Добавляем на вью (на супервью) наш новый элемент (UITextField)(так добавлять элементы можно по одному)
    //    view.addSubview(taskTextField)

    setupSubviews(taskTextField, saveButton, cancelButton)
    //Важна последовательность методов!
    setConstraints()
  }

  //Добавляем созданные элементы на супервью скопом. (UIView... - вариативный параметр который может принемать несколько элементов данного типа (массив))
  private func setupSubviews (_ subviews: UIView...) {
    subviews.forEach { subview in
      view.addSubview(subview)
    }
  }

  //Метод для расстановки констрейнтов
  private func setConstraints() {

    //Этот параметр необходимо отключать у кажного элементы чтобы настраивать констрейнты кодом
    taskTextField.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      //topAnchor - верхняя граница(т.е. верхнию границу Текстфилда цепляем к верхней границы Вью на 80 поинтов)
      taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
      taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      //Tralling необходимо задавать с минусом, а то уйдет за границу экрана
      taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
    ])

    saveButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
      saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
    ])

    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
      cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
    ])

  }
  //Создаем метод для создания кнопок.
  private func createButton(withTitle title: String, andColor color: UIColor, action: UIAction) -> UIButton {
    var attributes = AttributeContainer()
    attributes.font = UIFont.boldSystemFont(ofSize: 18)

    var buttonConfiguration = UIButton.Configuration.filled()
    buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
    buttonConfiguration.baseBackgroundColor = color

    return UIButton(configuration: buttonConfiguration, primaryAction: action)

  }

  private func save() {
    let task = Task(context: viewContext)
    task.title = taskTextField.text

    if viewContext.hasChanges {
      do {
        try viewContext.save()
      } catch  {
        print(error.localizedDescription)
      }
    }
    delegate.reloadData()
    dismiss(animated: true)
  }
}
