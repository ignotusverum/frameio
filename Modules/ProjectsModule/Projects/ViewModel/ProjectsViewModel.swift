//
//  ProjectsViewModel.swift
//  ProjectsModule
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import FrameIOFoundation

protocol ProjectsViewModelProtocol {
    func transform(input: Observable<ProjectsUIAction>) -> Observable<ProjectsState>
    func transform(input: Observable<ProjectsUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<ProjectsState>
}

class ProjectsViewModel: ProjectsViewModelProtocol {
    let events: PublishSubject<ProjectsModuleEvents>
    
    init(events: PublishSubject<ProjectsModuleEvents>) {
        self.events = events
    }
    
    func transform(input: Observable<ProjectsUIAction>) -> Observable<ProjectsState> {
        return transform(input: input,
                         scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<ProjectsUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<ProjectsState> {
        Observable.feedbackLoop(initialState: .sections([]),
                                scheduler: scheduler,
                                reduce: { (state, action) -> ProjectsState in
                                    switch action {
                                    case let .ui(action): return .reduce(state, action: action)
                                    case let .model(action): return .reduce(state, model: action)
                                    }
                                },
                                feedback: { _ in input.map(ProjectsActions.ui) },
                                weakify(self,
                                        default: .empty()) { (me: ProjectsViewModel, state) in
                                            Observable.merge(ProjectsAdapter
                                                .fetchProjects()
                                                .asObservable()
                                                .map(ProjectsModelAction.sectionsChanged))
                                            .map(ProjectsActions.model)
        })
            .sendSideEffects({ state in
                input.capture(case: ProjectsUIAction.itemSelected)
                    .map(ProjectsModuleEvents.projectSelected)
            }, to: events.asObserver())
    }
}
