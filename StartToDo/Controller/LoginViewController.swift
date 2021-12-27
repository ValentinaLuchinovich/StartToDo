//
//  ViewController.swift
//  StartToDo
//
//  Created by Валентина Лучинович on 23.12.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var warnLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Рассчитывыем точную величину клавиатуры
        // Чтобы знать на сколько смещать контент при появлении клавиатуры
        // Клавиатура появилась на экране, применяем метод kbDidShow
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        // Клавиатура исчезла - применяем kbDidHide
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
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
    
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
    @IBAction func registertapped(_ sender: Any) {
    }
    
}

