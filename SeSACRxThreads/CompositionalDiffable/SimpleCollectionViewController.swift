//
//  SimpleCollectionViewController.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/26/25.
//

import UIKit
import SnapKit
/*
 Data
 -> Delegate, DataSource 사용했었음(특징: 인덱스 기반으로 데이터를 조회)
 list[indexPath.row]이런식으로 접근했자나여? 이 얘깁니다
 -> DiffableDataSource 더이상 인덱스사용안함 잘가랑 ~ ( 데이터 or 모델 기반으로 조회(표현))
 
 Layout
 -> FlowLayout
 ->
 -> List Configuration
 
 Presentation
 -> CellForRowAt / dequeueReusableCell
 ->
 -> List Cell / dequeueConfiguredReusableCell
 */
//0226
// uuid vs udid
//uuid 앱을 설치해서 사용하는 동안에는 사용자를 특정할 수 있고 고유성을 보장하기 위해 주는 값 앱을 지우면 사라짐 . 앱마다 다름
// udid 기기에 특정되는 것 앱별로 다 같아서 인물을 특정할 수 있음
// 5.3+ Identifiable 프로토콜 uuid를 사용할때 id라는 네이밍을 특정해서 id라는 프로퍼티가 있어야된다 라는 기능만 있음
struct Product: Hashable, Identifiable { // 왜 채택 해야하는가? -> 고유한 특성을 지닐거야~ 하고 알려줌. 겹치는 경우없이 name price count세개 합쳐진게 다 다를거라는 보장 / name은 다르게 쓸거징?
    let id = UUID() //  identity 설정할때 겹치지 않게 해주는것 실제로 사용할 값은 아님
    let name: String
    let price = 40000//Int.random(in: 1...10000) * 1000
    let count = 8 //  몇개를 살지 ~
}


final class SimpleCollectionViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
        case sub
    }

    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    //    // collectionView.register 대신 // UICollectionViewListCell 시스템셀 역할
    //    private var registration: UICollectionView.CellRegistration<UICollectionViewListCell, Product>! //  무조건 값이 들어올거니까 !로 해결쓰
    //                                                                                            ↑ 타입 일치를 아래 item과 일치 시켜줘야디 !
    // configureDataSource로 옮김 ↑↑
    
    
    // <SectionIdentifierType, ItemIdentifierType>
    // <섹션을 구분해 줄 데이터 타입, 셀에 들어가는 데이터 타입>
    // numberOfItemInSection 사용하지 않는다 , cellForItemAt도 없어도된다, 정들었었다 안녕~ 또봐 ~
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>! // 완벽하게 collectionviewDataSource를 대체
    // Product Confirm to Hashable
    
    
    var list = [
        //        "Hue", "Jack", "Bran", "Den"
        //        1,2,3,4,5,5,67,7,898
        Product(name: "Macbook Pro M5"),
        Product(name: "키보드"),
        Product(name: "키보드"),
        Product(name: "금")
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        configureCell()
        configureDataSource()
        updateSnapShot()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
                collectionView.delegate = self
        //        collectionView.dataSource = self
    }
    
    private func updateSnapShot() {
        //
        
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        
        snapshot.appendSections(Section.allCases) // 섹션을 하나만  ([0,1,2]) -> 세개의 섹션인것 / 문자열도 가능 // 데이터 기반 인덱스 기반x
        // 고유성을 보장하기 위해 열거형을 사용한다 휴먼에러 방지용 -> 꼭써야하는건 아니다 근디 대소문자 구분하니까 에러나기 쉽구로
        
        snapshot.appendItems(
            list,
            toSection: .main
        ) //배열에 추가될 내용 // -> 0번 인덱스에 이 배열을 넣겠다 이말이야  toSection: 1 넣어줄 섹션 지정가능
        
        snapshot.appendItems([
            Product(name: "JackJack")
        ], toSection: .sub)
        
        snapshot.appendItems([
            Product(name: "고래밥")
        ], toSection: .sub) // 뒤에 갖다 붙음 배열의 append처럼 동작하는디?
        dataSource.apply(snapshot)
    }
    
    private func configureDataSource() {
        // collectionView.register 대신 // UICollectionViewListCell 시스템셀 역할
        //        var registration: UICollectionView.CellRegistration<UICollectionViewListCell, Product>! //  무조건 값이 들어올거니까 !로 해결쓰 -> 선언과 초기화를 밑에서 합침 🔵
        //                                                                                  ↑ 타입 일치를 아래 item과 일치 시켜줘야디 !
        // cellForItemAt에 작성 했던 코드 들이 registration안에 들어가는 것 !  // 컬렉션부에서 register하는 과정이 같이 들어가있는게 registration이라고 보면 될거 같다
        var registration = UICollectionView.CellRegistration<UICollectionViewListCell, Product> { cell, indexPath, itemIdentifier in // 🔵
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .brown
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            content.secondaryText = "\(itemIdentifier.price.formatted())원"
            content.secondaryTextProperties.color = .blue
            
            content.image = UIImage(systemName: "star")
            content.imageProperties.tintColor = .orange
            
            cell.contentConfiguration = content
            
            
            // MARK: - backgroundConfig
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .yellow
            backgroundConfig.cornerRadius = 40
            backgroundConfig.strokeColor = .systemRed
            backgroundConfig.strokeWidth = 2
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            //cellForItemAt에 들어갔던 코드가 여기 들어가게된다, 해당 메서드가 필요없어진거지 그 기능을 여기서 해버린다
            // Q. 인덱스 기반 조회 안하는건 알겠는데... 그럼 각셀에 어떤 데이터가 보여질지 어디서 가져옴? ->
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier) // 클로저 안에 있어서 self로 조회 가능 메모리 누수 가능성이 있을 수 있다
            return cell
        })
    }
    
    
    //    private func configureCell() {
    //        // cellForItemAt에 작성 했던 코드 들이 registration안에 들어가는 것 !  // 컬렉션부에서 register하는 과정이 같이 들어가있는게 regustration이라고 보면 될거 같다
    //        registration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
    //
    //            var content = UIListContentConfiguration.valueCell()
    //
    //            content.text = itemIdentifier.name
    //            content.textProperties.color = .brown
    //            content.textProperties.font = .boldSystemFont(ofSize: 20)
    //            content.secondaryText = "\(itemIdentifier.price.formatted())원"
    //            content.secondaryTextProperties.color = .blue
    //
    //            content.image = UIImage(systemName: "star")
    //            content.imageProperties.tintColor = .orange
    //
    //            cell.contentConfiguration = content
    //
    //
    //            // MARK: - backgroundConfig
    //            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
    //            backgroundConfig.backgroundColor = .yellow
    //            backgroundConfig.cornerRadius = 40
    //            backgroundConfig.strokeColor = .systemRed
    //            backgroundConfig.strokeWidth = 2
    //
    //            cell.backgroundConfiguration = backgroundConfig
    //        }
    //    }
    
    
    // Flow -> Compsitional -> List Configuration
    // 테이블뷰 시스템 기능을 컬렉션뷰로도 만들 수 있어 !
    func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped) //-> ListConfiguration 디바이스 너비에 꽉차게 (테이블뷰처럼 수직 스크롤 고정이므로 다른 레이아웃 코드가 필요가 없다)
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemGreen
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        //        layout.itemSize
        //        layout.minimumLineSpacing -> 이건 FlowLayout에 들어있셔
        
        return layout
    }
}


extension SimpleCollectionViewController: UICollectionViewDelegate  { // UICollectionViewDataSource// Diffable이 대체 하기때문에 이 프로토콜을 사용하지 않게 된다
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let data = list[indexPath.item] //  diffable에서 이거 이상하잖아~
//        dump(data)
        let data = dataSource.itemIdentifier(for: indexPath)
        
        
//        list.remove(at: indexPath.item)
//        let product = Product(name: "고래밥\(Int.random(in: 1...100))")
////        list.append(product)
//        list.insert(product, at: 2)
        updateSnapShot()
    }
    
    //    Q. 얘는 어디로 가는겨?
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return list.count
    //    }
    /*
     컬렉션뷰에서는
     dequeueReusableCell
     customCell + identifier + register
     ↓
     dequeueConfiguredReusableCell
     systemCell +     X      + CellRegistration
     
     configuration이 되면서 systemCell을 사용할거다 !
     register -> using에 들어가는 친구가 그역할을 하게될 것이다! (using: )
     
     */
    //    configureDataSource가 생겼기 때문에 사라져도 됨
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // iOS 14+ // item 각 셀의 들어가야하는 모델
    //        // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>) // 지금까지 해왔던 방식
    //
    //        let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: list[indexPath.item])
    //        return cell
    //    }
    
    
    //}
}
