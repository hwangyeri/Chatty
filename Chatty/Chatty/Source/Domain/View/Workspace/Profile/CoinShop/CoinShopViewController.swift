//
//  CoinShopViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/28.
//

import UIKit
import RxSwift
import RxCocoa
import iamport_ios
import WebKit

final class CoinShopViewController: BaseViewController {
    
    lazy var webView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
     }()
    
    var coin: Int?
    
    private let mainView = CoinShopView()
    
    private let viewModel = CoinShopViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.coin = coin
        viewModel.fetchCoinShopData()
        bind()
    }
    
    override func configureLayout() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }

    private func bind() {
        
        let input = CoinShopViewModel.Input(
            backButton: mainView.backButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 뒤로가기 버튼 탭
        output.backButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 서버 통신 완료 트리거
        output.isCompleted
            .subscribe(with: self) { owner, isValid in
                print("✅ 서버 통신 완료")
                if isValid {
                    owner.mainView.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: TableView
extension CoinShopViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.coinData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinShopTableViewCell.identifier, for: indexPath) as? CoinShopTableViewCell else { return UITableViewCell() }
        let data = viewModel.coinData?[indexPath.row]
        
        if indexPath.section == 0 {
            cell.coinLabel.isHidden = false
            cell.subLabel.isHidden = false
            cell.coinButton.isHidden = true
            cell.mainLabel.text = "🌱 현재 보유한 코인"
            cell.coinLabel.text = "\(viewModel.coin ?? 0)"
        } else if indexPath.section == 1 {
            cell.coinLabel.isHidden = true
            cell.subLabel.isHidden = true
            cell.coinButton.isHidden = false
            cell.mainLabel.text = "🌱 \(data?.item ?? "")"
            cell.coinButton.setTitle("₩\(data?.amount ?? "")", for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.coinData?[indexPath.row]
        
        if indexPath.section == 1 {
            print(#function, "셀 클릭")
            
            // 웹뷰로 결제창 띄우기
            self.addWebView()
            
            // 결제 요청 데이터
            let payment = viewModel.configurePGData(indexPath)
            
            // 2. 포트원 SDK에 결제를 요청
            Iamport.shared.paymentWebView(
                webViewMode: self.webView,
                userCode: APIKey.userCode,
                payment: payment
            ) { [weak self] iamportResponse in // 결제가 종료가 되면 해당 콜백이 호출됨
                print("✅ PG 결제 요청 데이터")
                print(String(describing: iamportResponse)) // 결제 요청 데이터
                
                self?.removeWebView()
                
                // 결제 성공 시
                if iamportResponse?.success == true {
                    print("🩵 PG 결제 성공")
                    // 유효성 검증
                    self?.viewModel.isValidPG(iamportResponse)
                    // 토스트 메시지
                    self?.showToast(message: "\(data?.item ?? "Coin")이 결제되었습니다", y: 400)
                } else {
                    print("💛 PG 결제 실패")
                    self?.showToast(message: "결제가 취소되었습니다.", y: 400)
                }
            }
        }
    }
    
    
}

// MARK: WebView
extension CoinShopViewController {
    
    func addWebView() {
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func removeWebView() {
        self.view.willRemoveSubview(webView)
        webView.stopLoading()
        webView.removeFromSuperview()
    }
    
}
