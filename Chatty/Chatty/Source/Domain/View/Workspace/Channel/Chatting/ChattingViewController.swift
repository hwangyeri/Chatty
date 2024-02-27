//
//  ChattingViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class ChattingViewController: BaseViewController {
    
    var workspaceID: Int?
    
    var channelID: Int?
    
    var channelName: String?
    
    private let mainView = ChattingView()
    
    private let viewModel = ChattingViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var images = [UIImage]()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.workspaceID = workspaceID
        viewModel.channelID = channelID
        viewModel.channelName = channelName
        viewModel.fetchChannelChatData()
        bind()
        setTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        
        viewModel.closeSocket()
    }
    
    override func configureLayout() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.messageTextView.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    private func setTitle() {
        mainView.titleLabel.text = "#" + (channelName ?? "")
    }
    
    // 테이블뷰 스크롤
    private func scrollToBottom() {
        print(#function, "☑️ 아래로 스크롤")
        let indexPath = IndexPath(row: viewModel.channelChatData.count - 1, section: 0)
        mainView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func bind() {
        
        let input = ChattingViewModel.Input(
            backButton: mainView.backButton.rx.tap,
            listButton: mainView.listButton.rx.tap,
            plusImageButton: mainView.plusImageButton.rx.tap,
            messageTextField: mainView.messageTextView.rx.text.orEmpty,
            sendImageButton: mainView.sendImageButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 뒤로가기 버튼 탭
        output.backButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 리스트 버튼 탭
        output.listButtonTap
            .drive(with: self) { owner, _ in
                let vc = SettingViewController()
                vc.workspaceID = owner.viewModel.workspaceID
                vc.channelName = owner.viewModel.channelName
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 이미지 추가 버튼 탭
        output.plusImageButtonTap
            .drive(with: self) { owner, _ in
                let actionSheet = UIAlertController(title: .none, message: nil, preferredStyle: .actionSheet)
                
                let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
                    print("카메라 액션시트 클릭")
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    owner.present(imagePicker, animated: true)
                }
                
                let albumAction = UIAlertAction(title: "앨범", style: .default) { _ in
                    print("앨범 액션시트 클릭")
                    var configuration = PHPickerConfiguration()
                    configuration.selectionLimit = 5
                    configuration.filter = .images
                    
                    let phPicker = PHPickerViewController(configuration: configuration)
                    phPicker.delegate = self
                    
                    owner.present(phPicker, animated: true)
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .destructive)
                
                actionSheet.addAction(cameraAction)
                actionSheet.addAction(albumAction)
                actionSheet.addAction(cancelAction)
                
                owner.present(actionSheet, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 채널 채팅 조회 API 완료
        output.isCompletedFetch
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, isValid in
                if isValid {
                    owner.mainView.tableView.reloadData()
                    
                    if !owner.viewModel.channelChatData.isEmpty {
                        owner.scrollToBottom()
                    }
                } else {
                    owner.showOkAlert(title: "Error", message: "에러가 발생했어요. 😥\n다시 시도해 주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        // 채널 채팅 생성 API 완료
        output.isCreatedChat
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, isValid in
                owner.mainView.messageTextView.text = nil
                if isValid {
                    owner.mainView.tableView.reloadData()
                    owner.scrollToBottom()
                } else {
                    owner.showOkAlert(title: "Error", message: "에러가 발생했어요. 😥\n다시 시도해 주세요.")
                }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: TableView
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.channelChatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.identifier, for: indexPath) as? ChattingTableViewCell else { return UITableViewCell() }
        let data = viewModel.channelChatData[indexPath.row]
        
        cell.messageLabel.text = data.content
        cell.nameLabel.text = data.user.nickname
        
        let date = data.createdAt.toDate()
        cell.dateLabel.text = date?.formattedTime()
        
        if data.user.profileImage != nil, let profileImage = data.user.profileImage {
            cell.profileImageView.setImageKF(withURL: profileImage) 
        } else {
            cell.profileImageView.image = .noPhotoA
        }
        
        let files = data.files ?? []
        cell.imageLayout(files)
        
        if data.content.isEmpty {
            cell.messageBackView.isHidden = true
        } else {
            cell.messageBackView.isHidden = false
        }
        
        return cell
    }
    
}

// MARK: CollectionView
extension ChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageImageCollectionViewCell.identifier, for: indexPath) as? MessageImageCollectionViewCell else { return UICollectionViewCell() }
        let data = images[indexPath.row]
        
        if images.count > 0 {
            mainView.collectionView.isHidden = false
            cell.imgView.image = data
        } else {
            mainView.collectionView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (mainView.collectionView.frame.width) / 6
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
}

// MARK: TextView
extension ChattingViewController: UITextViewDelegate {
    
    // placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .textSecondary else { return }
        textView.text = nil
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메세지를 입력하세요"
            textView.textColor = .textSecondary
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            if estimatedSize.height >= 54 {
                textView.isScrollEnabled = true
                textView.snp.remakeConstraints { make in
                    make.height.equalTo(54)
                }
            } else {
                textView.isScrollEnabled = false
                constraint.constant = estimatedSize.height
            }
        }
    }
    
}

// MARK: UIImagePicker 카메라
extension ChattingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            // 이미지 배열에 추가
            images.append(image)
            mainView.collectionView.reloadData()
            if let imageToData = image.jpegData(compressionQuality: 0.001) {
                // 데이터 타입으로 변경
                viewModel.imageList.append(imageToData)
            } else {
                print("💛 Error converting image to data.")
            }
        } else {
            print("💛 Error converting image to data.")
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

// MARK: PHPicker 앨범
extension ChattingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let selectedImage = image as? UIImage {
                            // 이미지 배열에 저장
                            self?.images.append(selectedImage)
                            self?.mainView.collectionView.reloadData()
                            if let imageToData = selectedImage.jpegData(compressionQuality: 0.001) {
                                // 데이터 타입으로 변환
                                self?.viewModel.imageList.append(imageToData)
                            } else {
                                print("💛 Error converting image to String type.")
                            }
                        } else {
                            print("💛 Error loading image.")
                        }
                    }
                }
            }
        }
    }
    
}

