//
//  CompositionalViewController.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
//0227
final class CompositionalViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    
    enum Section: CaseIterable {
        case First
        case Second
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    var list = [
        1,3,45,7,4,2,123,4567,478,47,9,0,321,431,5123,51346125376,134562457346541,124543753,61234124362345,61234
    ]
    
    var list2 = [
        121,5,7,346,456,1,267,9,99,999,9999,99999,999999,999999999,999999999999,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        updateSnapShot()
        
        multiUnicast()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    // 유니캐스트의 대표적인 예 == 옵저버블 / 개별적으로 생성이 된다 / 구독자간에 스트림이 공유 되지 않는다
    
    func multiUnicast() {
        //        let sampleInt = Observable<Int>.create { observer in
        //            observer.onNext(Int.random(in: 1...100))
        //            return Disposables.create()
        //        }
        // Hot Obsevable
//         Subject(multicast)
//         단일 스트림을 여러 구독자에게 공유한다.
//         모든 구독이 동일한 스트림을 받음.
//         subject는 구독시점과상관없인 이벤트를 방출 할 수 있다
//         스트림을 중간부터 확인하게 될 수도 있다.
        
        // Cold Obsevable
        // Observable (Unicast)
        // 구독이 발생할때 까지 기다렸다가 이벤트를 방출
        //처음부터 모든데이터 스트림을 확인할 수 있다.
        let sampleInt = BehaviorSubject(value: 0)
        
        sampleInt.onNext(Int.random(in: 1...100))
        
        sampleInt // 전달
            .subscribe { value in
                print("1: \(value)")
            }
            .disposed(by: disposeBag)
        
        sampleInt // 전달
            .subscribe { value in
                print("2: \(value)")
            }
            .disposed(by: disposeBag)
        
        sampleInt // 전달
            .subscribe { value in
                print("3: \(value)")
            }
            .disposed(by: disposeBag)
        
        
        
        
        
        
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/3)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let innerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let innerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: innerSize,
                    subitems: [item]
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(300),
                    heightDimension: .absolute(100)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
                
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 20
                return section
            }
        }
        return layout
    }
    
    
    // 외부 그룹, 내부 그룹 활용
    //    private func createLayout() -> UICollectionViewLayout {
    //        let itemSize = NSCollectionLayoutSize(
    //            widthDimension: .fractionalWidth(1),
    //            heightDimension: .fractionalHeight(1/3)
    //        )
    //
    //        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    //
    //        let innerSize = NSCollectionLayoutSize(
    //            widthDimension: .fractionalWidth(1),
    //            heightDimension: .fractionalHeight(1)
    //        )
    //        let innerGroup = NSCollectionLayoutGroup.vertical(
    //            layoutSize: innerSize,
    //            subitems: [item]
    //        )
    //
    //        let groupSize = NSCollectionLayoutSize(
    //            widthDimension: .absolute(300),
    //            heightDimension: .absolute(100)
    //        )
    //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])
    //
    //        let section = NSCollectionLayoutSection(group: group)
    //        section.orthogonalScrollingBehavior = .groupPaging
    //
    //        let layout = UICollectionViewCompositionalLayout(section: section)
    //       return layout
    //    }
    // 수평스크롤
    //    private func createLayout() -> UICollectionViewLayout {
    //        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
    //        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    //
    //        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
    //
    //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    //
    //        let section = NSCollectionLayoutSection(group: group)
    //        section.orthogonalScrollingBehavior = .groupPaging
    //        //.none이 아니면 전부 수평스크롤
    //
    //        let layout = UICollectionViewCompositionalLayout(section: section)
    //       return layout
    //    }
    
    //    private func createLayout() -> UICollectionViewLayout {
    //        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1.0))
    //        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    //
    //        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
    //
    //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    //
    //        let section = NSCollectionLayoutSection(group: group)
    //        section.interGroupSpacing = 20
    //
    //        let layout = UICollectionViewCompositionalLayout(section: section)
    //       return layout
    //    }
    
    //    private func createLayout() -> UICollectionViewLayout {
    //        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    //        configuration.backgroundColor = .purple
    //        configuration.showsSeparators = true
    //        //        configuration.leadingSwipeActionsConfigurationProvider 스와이프해서 나올 옵셜에 관한 프로퍼티
    //        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
    //        return layout
    //    }
    
    
    private func configureDataSource() {
        // cell register
        let cellRegistration = UICollectionView.CellRegistration<CompositionalCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            
            cell.label.text = "\(indexPath)" //  커스텀 셀
            
            //            var content = UIListContentConfiguration.subtitleCell()
            //            content.text = "\(itemIdentifier)"
            //            content.image = UIImage(named: "star")
            //            print("CellRegistration", indexPath)
            //            cell.contentConfiguration = content
        }
        // cellForItemAt
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            print("ReusableCell", indexPath)
            return cell
        })
    }
    
    private func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .First)
        snapshot.appendItems(list2, toSection: .Second)
        // collectionview에서는 동일한 데이터가 나와선 안되고 셀들이 고유해야하니까 합쳐버린다.. Hasable때무니야
        dataSource.apply(snapshot)
    }
    
    
    
    
}
