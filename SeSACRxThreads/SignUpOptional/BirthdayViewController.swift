//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BirthDayViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = BirthDayViewModel()
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "33월"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "99일"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = PointButton(title: "가입하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bind()
        
        
        
        //        birthDayPicker.rx.date
        //            .subscribe(onNext: { [weak self] date in
        //                let calendar = Calendar.current
        //                let year = calendar.component(.year, from: date)
        //                let month = calendar.component(.month, from: date)
        //                let day = calendar.component(.day, from: date)
        //
        //                self?.yearLabel.text = "\(year)년"
        //                self?.monthLabel.text = "\(month)월"
        //                self?.dayLabel.text = "\(day)일"
        //
        //                // 25년기준이니까...
        //                if year > 2008 {
        //                    self?.nextButton.isEnabled = false
        //                    self?.infoLabel.textColor = .red
        //                    self?.infoLabel.text = "만 17세 이상만 가입 가능합니다."
        //                } else {
        //                    self?.nextButton.isEnabled = true
        //                    self?.infoLabel.textColor = .black
        //                    self?.infoLabel.text = "가입 가넝~!"
        //                }
        //            })
        //            .disposed(by: disposeBag)
        //
        //
        //        nextButton.rx.tap
        //            .bind(with: self) { owner, _ in
        //                let vc = PhoneViewController()
        //                owner.navigationController?.pushViewController(vc, animated: true)
        //            }
        //            .disposed(by: disposeBag)
        
        //        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    // 수업
    func bind() {
        //nextButton.rx.tap 탭이 되었다는 사실
        //birthDayPicker.rx.date date가 선택되었다는 사실
        
        let input = BirthDayViewModel.Input(
            birthday: birthDayPicker.rx.date,
            nextTap: nextButton.rx.tap // 탭은 그대로 다시 뱉어줄거야~
        )
        
        let output = viewModel.transform(input: input)
        
        output.year
            .bind(with: self) { owner, year in
                owner.yearLabel.text = "\(year)년"
            }
            .disposed(by: disposeBag)
        
        output.month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text) // map을통해 거른것을 bind to 로 바로
            .disposed(by: disposeBag)
        
        output.day
            .map {"\($0)일"}
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        
        output.nextTap
            .bind(with: self) { owner, _ in
                let vc = SearchViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
    
    //    @objc func nextButtonClicked() {
    //        navigationController?.pushViewController(SimpleValidationViewController(), animated: true)
    //    }
    //
    
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
