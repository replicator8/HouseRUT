//
//  AccountViewController.swift
//  RutApp
//
//  Created by Michael Kivo on 15/01/2024.
//

import UIKit
import SnapKit
import FirebaseAuth
import Firebase

final class AccountViewController: UIViewController {

    // MARK: - Properties
    
    private var emailText = ""
    
    private var passwordText = ""
    
    private var fioText = ""
    
    private var instituteText = ""
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private lazy var viewback: UIView = {
        let view = UIView()
        
        return view
    }()
      
    private lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки профиля"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = AppColors.miitColor
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var FIOTextField: UITextField = {
        let fio = UITextField()
        fio.textColor = .black
        fio.backgroundColor = AppColors.grayColor
        fio.layer.cornerRadius = 12
        fio.delegate = self
        fio.returnKeyType = .go
        fio.isUserInteractionEnabled = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: fio.frame.height))
        fio.leftView = paddingView
        fio.leftViewMode = .always
        
        return fio
    }()
    
    private lazy var emailTextField: UITextField = {
        let email = UITextField()
        email.textColor = .black
        email.backgroundColor = AppColors.grayColor
        email.layer.cornerRadius = 12
        email.delegate = self
        email.returnKeyType = .go
        email.keyboardType = .emailAddress
        email.isUserInteractionEnabled = false

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: email.frame.height))
        email.leftView = paddingView
        email.leftViewMode = .always
        
        return email
    }()
    
    private lazy var instituteTextField: UITextField = {
        let institute = UITextField()
        institute.textColor = .black
        institute.backgroundColor = AppColors.grayColor
        institute.layer.cornerRadius = 12
        institute.delegate = self
        institute.returnKeyType = .go
        institute.isUserInteractionEnabled = false

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: institute.frame.height))
        institute.leftView = paddingView
        institute.leftViewMode = .always
        
        return institute
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let password = CustomTextField()
        password.textColor = .black
        password.isSecureTextEntry = true
        password.backgroundColor = AppColors.grayColor
        password.layer.cornerRadius = 12
        password.delegate = self
        password.returnKeyType = .go
        password.allowsEditingTextAttributes = false
        password.isUserInteractionEnabled = false

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: password.frame.height))
        password.leftView = paddingView
        password.leftViewMode = .always
        
        let eye = UIButton(type: .custom)
        eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eye.setImage(UIImage(systemName: "eye"), for: .selected)
        eye.addTarget(self, action: #selector(eyeTapped), for: .touchUpInside)
        eye.tintColor = AppColors.hintColor
        eye.frame = CGRect(x: 0, y: 0, width: 45, height: 20)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: 20))
        eye.center = view.center
        view.addSubview(eye)
        
        password.rightView = view
        password.rightViewMode = .always
        
        return password
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email:"
        label.textColor = AppColors.placeholderColor
        label.font = UIFont(name: "Extra Light", size: 20)
        
        return label
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль:"
        label.textColor = AppColors.placeholderColor
        label.font = UIFont(name: "Extra Light", size: 20)
        
        return label
    }()
    
    private lazy var fioLabel: UILabel = {
        let label = UILabel()
        label.text = "ФИО:"
        label.textColor = AppColors.placeholderColor
        label.font = UIFont(name: "Extra Light", size: 20)
        
        return label
    }()
    
    private lazy var instituteLabel: UILabel = {
        let label = UILabel()
        label.text = "Институт:"
        label.textColor = AppColors.placeholderColor
        label.font = UIFont(name: "Extra Light", size: 20)
        
        return label
    }()
        
    private lazy var changeDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить данные", for: .normal)
        button.backgroundColor = AppColors.miitColor
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(changeDataButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.backgroundColor = AppColors.miitColor
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить аккаунт", for: .normal)
        button.backgroundColor = AppColors.miitColor
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        addSubviews()
        setUpConstraints()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUp() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setData() {          
        emailText = UserModel.email
        passwordText = UserModel.password
        fioText = UserModel.fio
        instituteText = UserModel.institute
        
        emailTextField.text = emailText
        passwordTextField.text = passwordText
        FIOTextField.text = fioText
        instituteTextField.text = instituteText
        
        print("Данные пользователя: \(emailText) \(passwordText) \(fioText) \(instituteText)")
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(viewback)
        
        [changeDataButton, signOutButton, deleteAccountButton].forEach { viewback.addSubview($0) }
        
        [passwordTextField, FIOTextField, instituteTextField, emailTextField].forEach { viewback.addSubview($0) }
        
        [titlelabel, passwordLabel, emailLabel, fioLabel, instituteLabel].forEach { viewback.addSubview($0) }
    }
    
    private func setUpConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        viewback.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(700)
            make.width.equalTo(self.view)
        }
        
        titlelabel.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(4)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(247)
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(109)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalTo(247)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(200)
        }
        
        FIOTextField.snp.makeConstraints { make in
            make.width.equalTo(247)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(291)
        }
        
        instituteTextField.snp.makeConstraints { make in
            make.width.equalTo(247)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(382)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.leading.equalTo(emailTextField.snp.leading)
            make.top.equalToSuperview().inset(86)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.leading.equalTo(passwordTextField.snp.leading)
            make.top.equalToSuperview().inset(177)
        }
        
        fioLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.leading.equalTo(FIOTextField.snp.leading)
            make.top.equalToSuperview().inset(268)
        }
        
        instituteLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.leading.equalTo(instituteTextField.snp.leading)
            make.top.equalToSuperview().inset(359)
        }
        
        changeDataButton.snp.makeConstraints { make in
            make.height.equalTo(63)
            make.width.equalTo(215)
            make.top.equalToSuperview().inset(460)
            make.centerX.equalToSuperview()
        }
        
        signOutButton.snp.makeConstraints { make in
            make.height.equalTo(63)
            make.width.equalTo(215)
            make.top.equalToSuperview().inset(533)
            make.centerX.equalToSuperview()
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.height.equalTo(63)
            make.width.equalTo(215)
            make.top.equalToSuperview().inset(606)
            make.centerX.equalToSuperview()
        }
    }
    
    private func signInUser() {
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                print("Sign In doesn't successful")
            }
        }
    }
    
    @objc private func changeDataButtonTapped() {
        [emailTextField, passwordTextField, FIOTextField, instituteTextField].forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    @objc private func signOutButtonTapped() {
        
        let alert = UIAlertController(title: "Выйти из аккаунта", message: "Вы уверены что хотите выйти из аккаунта?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { action in
            return
        }))
        
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { action in
            print("Выход из аккаунта...")
            
            let firebaseAuth = Auth.auth()
            
            do {
                try firebaseAuth.signOut()
                print("Пользователь успешно вышел из аккаунта")
                
                // MARK: Delete user info from UserDefaults
                
                UserModel.deleteUser()
                
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }))
        present(alert, animated: true)
    }
            
    
    @objc private func deleteAccountButtonTapped() {
        
        let alert = UIAlertController(title: "Удалить аккаунт", message: "Вы уверены что хотите удалить аккаунт?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { action in
            return
        }))
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
            print("Deleting account...")
            
            self.signInUser()
            
            let user = Auth.auth().currentUser
            
            // MARK: Delete user account from Firestore
            
            Firestore.firestore().collection("users").document(user!.uid).delete { error in
                if error != nil {
                    print(error!.localizedDescription)
                    print("Account in Firestore doesn't deleted.")
                    
                } else {
                    print("Account in Firestore successfully deleted.")
                }
            }
            
            // MARK: Delete user account from Firebase
            
            self.signInUser()
            
            user?.delete { error in
              if let error = error {
                  print("User account doesn't deleted. \(error.localizedDescription)")
              } else {
                  print("User Account successfully deleted.")
                  [self.passwordTextField, self.FIOTextField, self.instituteTextField, self.emailTextField].forEach { $0.text = "" }
                  
                  let alert = Validate.showAlert(title: "Готово", message: "Вы успешно удалили аккаунт")
                  self.present(alert, animated: true)
              }
            }
            
            // MARK: Delete user info from UserDefaults
            
            UserModel.deleteUser()
            
            // MARK: Delete all notifications
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            self.signInUser()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                do {
                try Auth.auth().signOut()
                    print("Successfully sign out")
                } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                }
            })
            
        }))
        
        present(alert, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc private func eyeTapped(sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if emailTextField.text != emailText || passwordTextField.text != passwordText || FIOTextField.text != fioText || instituteTextField.text != instituteText {
            
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let fio = FIOTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let institute = instituteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !Validate.emailIsValid(email) {
                
                let alert = Validate.showAlert(title: "Неверный email", message: "Введите корректный email")
                present(alert, animated: true)
                return true
            }
            
            if !Validate.passwordIsValid(password) {
                
                let alert = Validate.showAlert(title: "Неверный пароль", message: "Пароль должен состоять из не менее 8 символов, цифр, специальных знаков, а также букв в обоих регистрах")
                present(alert, animated: true)
                return true
            }
            
            if !Validate.fioIsValid(fio) {
                
                let alert = Validate.showAlert(title: "Неверный ФИО", message: "Введите ваш ФИО через пробел")
                present(alert, animated: true)
                return true
            }
            
            if !Validate.instituteIsValid(institute) {
                
                let alert = Validate.showAlert(title: "Неверный институт", message: "Институт должен входить в состав РУТ (МИИТ)")
                present(alert, animated: true)
                return true
            }
            
            let newEmail = emailTextField.text!
            let newPassword = passwordTextField.text!
            let newFIO = FIOTextField.text!
            let newInstitute = instituteTextField.text!
            
            let uid = Auth.auth().currentUser?.uid
            
            let updatedData = ["email": newEmail, "password": newPassword, "fio": newFIO, "institute": newInstitute, "uid": uid!]
            
            if uid != nil {
                
                // MARK: Update email
                
                if emailTextField.text != emailText {
                    
                    Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                        if let error = error {
                            print("User email doesn't update.")
                            print(error.localizedDescription)
                        } else {
                            print("User email updated successfully.")
                        }
                    }
                }
                
                // MARK: Update password
                
                if passwordTextField.text != passwordText {
                    Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                        if let error = error {
                            print("User password doesn't update.")
                            print(error.localizedDescription)
                        } else {
                            print("User password updated successfully.")
                        }
                    }
                }
                
                emailText = newEmail
                passwordText = newPassword
                fioText = newFIO
                instituteText = newInstitute
                
                let userDocument = Firestore.firestore().collection("users").document(uid!)
                
                // MARK: Update user data in Firestore
                
                userDocument.updateData(updatedData) { error in
                    if let error = error {
                        print("Ошибка обновления дных пользователя: \(error.localizedDescription)")
                    } else {
                        print("Данные пользователя успешно обновлены")
                        let alert = Validate.showAlert(title: "Готово", message: "Ваши данные успешно обновлены")
                        self.present(alert, animated: true)
                    }
                }
                
                // MARK: Update user data in UserDefaults
                
                UserModel.email = newEmail
                UserModel.password = newPassword
                UserModel.fio = newFIO
                UserModel.institute = newInstitute
                UserModel.uid = uid!
                UserModel.synchronize()
                
            }
        }
        return true
    }
}
