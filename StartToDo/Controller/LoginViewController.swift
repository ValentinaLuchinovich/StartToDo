//
//  ViewController.swift
//  StartToDo
//
//  Created by Валентина Лучинович on 23.12.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var warnLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        // Рассчитывыем точную величину клавиатуры
        // Чтобы знать на сколько смещать контент при появлении клавиатуры
        // Клавиатура появилась на экране, применяем метод kbDidShow
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        // Клавиатура исчезла - применяем kbDidHide
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        // Делаем предупреждение об ошибке невидимым
        warnLabel.alpha = 0
        
        //В случае если пользователь не изменился не запрашиваем данные повторно
        // А сразу переходим на второй экран
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self?.performSegue(withIdentifier: "taskSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Очищаем поля логина и пароля
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // Узнаем размеры вью при появлении клавивтуры
    @objc func kbDidShow(notification: NSNotification) {
        // Получаем инфориацию, хранящуюся в notification
        // добавляем проверку на nil
        guard let userInfo = notification.userInfo else { return }
        // Получаем размер фпкйма клавиатуры
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // Работа с вью
        // Увеличиваем размер контента хранящегося в скролл вью
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        // Редактируем правый позунок scroll view
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    // Указываем размеры вью при исчезновении клавиатуры
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    // Задаём текст для лейбла с ошибкой
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        // Добавляем анимацию
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warnLabel.alpha = 0
        }

    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            // Ошибка на случай не выполнения хотя бы одного условия описанного выше
            displayWarningLabel(withText: "Информация неверна")
            return
        }
        // Реализуем поиск юзера в базе даннныъ
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            // В случае ошибки
            if error != nil {
                self?.displayWarningLabel(withText: "Произошла ошибка")
                return
            }
            // Проверяем, что пользователь с таким именем и паролем существует
            if user != nil {
                self?.performSegue(withIdentifier: "taskSegue", sender: nil)
                return
            }
            // Если такого пользователя не существует
            self?.displayWarningLabel(withText: "Пользователь с таким иминем и паролем не существует")
      }
    }
    
    @IBAction func registertapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            // Ошибка на случай не выполнения хотя бы одного условия описанного выше
            displayWarningLabel(withText: "Информация неверна")
            return
        }
        // Реализуем сохоранение юзера в базу данных
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            // В случае если регистрация прошла успещно переходим на следующий экран
            guard error == nil, let uid = result?.user.uid else { return }
            // Записываем данные о регистрации
            let userRef = self?.ref.child(uid)
            userRef?.setValue(["email": email])
        }
    }
    
}

