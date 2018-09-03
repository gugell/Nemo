//
//  DispatchPresenter.swift
//  Legato
//
//  Created by Luis Burgos on 7/23/18.
//  Copyright © 2018 Yellowme. All rights reserved.
//

import Foundation

class DispatchPresenter: DispatchViewPresenter {
    
    private var flowHandler: FlowHandler<NemoKeys>
    private var currentFlow: NemoKeys = .login
    
    let view: DispatchView!
    
    required init(view: DispatchView) {
        self.view = view
        flowHandler = SessionFlowHandler(SessionFaker(), exitFlow: .login)
        
        _ = flowHandler
            .link(with: ValidSessionFlowHandler(
                ValidSessionFaker(), exitFlow: .login
            ))
            .link(with: FetchUserFlowHandler(
                UserFaker(), exitFlow: .error
            ))
    }
    
    func decideUserMainScreen() {
        view.setProgress(active: true)
        flowHandler.runValidations(self)
    }
    
    func sendToMainScreen() {
        switch currentFlow.description {
        case NemoKeys.login.description:
            view.sendToLogin()
            break
        case NemoKeys.error.description:
            view.sendToError()
            break
        default:
            view.sendToMain()
        }
    }
}

extension DispatchPresenter: FlowHandlerCallback {
    func onEndReached() {
        executeAfterDecideMainScreenAction()
    }
    
    func onEarlyExit(flow: Any) {
        currentFlow = flow as! NemoKeys
        executeAfterDecideMainScreenAction();
    }
}

extension DispatchPresenter {
    private func executeAfterDecideMainScreenAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.setProgress(active: false)
            self.sendToMainScreen()
        }
    }
}
