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
    public var identity: String { return UUID().uuidString }
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
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let refreshControl = UIRefreshControl() <~ {
        $0.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        collectionView.addSubview(refreshControl)
        
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

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.actions.onNext(.reload)
            })
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
            .map { $0.map(self.createAnimatableSection) }
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        states.capture(case: ProjectsState.loading).toVoid()
        .asDriverIgnoreError()
        .drive(onNext: { [weak self] in
            self?.activityIndicator.startAnimating()
        }).disposed(by: disposeBag)

        states.exclude(case: ProjectsState.loading)
            .toVoid()
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] in
                self?.activityIndicator.stopAnimating()
            }).disposed(by: disposeBag)

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
               height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: 55)
    }
    
    private func createAnimatableSection(_ section: ProjectsSection)-> AnimatableSectionModel<String, Project> {
        switch section {
        case let .recent(title, projects): return AnimatableSectionModel(model: title,
                                                                         items: projects)
        case let .list(team, projects): return AnimatableSectionModel(model: "\(team.name ?? "Unknown")",
                                                                      items: projects)
        }
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
