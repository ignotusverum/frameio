//
//  ProjectsViewController.swift
//  ProjectsModule
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import EnumKit
import FrameIOFoundation
import RxDataSources
import RxEnumKit
import MERLin
import FrameUIKit

extension Project: IdentifiableType {
    public var identity: String { return id }
}

class ProjectsViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: ProjectsViewModel
    private let actions = PublishSubject<ProjectsUIAction>()
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()) <~ {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        $0.collectionViewLayout = layout
        $0.register(TitleCell.self)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.registerReusableView(CollectionHeaderView.self,
                                kind: UICollectionView.elementKindSectionHeader)
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Project>>!
    
    init(with viewModel: ProjectsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Projects"
        
        applyTheme()
        configureDatasource()
        bindViewModel()
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.dataSource[indexPath]
                self.actions.onNext(.itemSelected(item))
            })
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        
        states.capture(case: ProjectsState.sections)
            .asDriverIgnoreError()
            .map {
                $0.map { AnimatableSectionModel(model: $0.name,
                                                items: [$0]) } }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        states.connect()
            .disposed(by: disposeBag)
    }
    
    private func configureDatasource() {
        dataSource = RxCollectionViewSectionedAnimatedDataSource(
            configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
                self.configureCell(item: item, indexPath: indexPath, from: collectionView)
            },
            configureSupplementaryView: { [weak self] (dataSource, collectionView, kind, indexPath) in
                guard let self = self,
                    kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
                
                let section = dataSource.sectionModels[indexPath.section]
                return self.configureSectionHeader(title: section.model,
                                                   indexPath: indexPath)
            }
        )
    }
    
    func applyTheme() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: 40)
    }
}

extension ProjectsViewController {
    func configureCell(item: Project,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        let cell: TitleCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.title = item.name
        return cell
    }
    
    func configureSectionHeader(title: String,
                                indexPath: IndexPath) -> UICollectionReusableView {
        let header: CollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                           for: indexPath)
        header.title = title
        
        return header
    }
}
