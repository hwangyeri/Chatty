//
//  AddViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/10.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

enum WorkspaceAction {
    case edit // 워크스페이스 편집하기
    case add // 워크스페이스 추가하기
}

final class AddViewController: BaseViewController {
    
    var workspaceAction: WorkspaceAction = .add
    
    var workspaceData: Workspace?

    private let mainView = AddView()
    
    private let viewModel = AddViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let imageData = PublishRelay<Data>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setWorkspaceData()
        bind()
    }
    
    // 워크스페이스 편집하기 - 데이터 셋팅
    private func setWorkspaceData() {
        if workspaceAction == .edit {
            print("워크스페이스 편집하기 진입")
            mainView.titleLabel.text = "워크스페이스 편집"
            mainView.nameTextField.text = workspaceData?.name
            mainView.explainTextField.text = workspaceData?.description ?? "워크스페이스를 설명하세요 (옵션)"
            
            if let thumbnail = workspaceData?.thumbnail {
                mainView.workspaceImageButton.setImageKF(withURL: thumbnail) { result in
                    switch result {
                    case .success(_):
                        print("🩵 이미지 로드 성공")
                    case .failure(let error):
                        print("💛 이미지 로드 실패: \(error)")
                    }
                }
            } else {
                mainView.workspaceImageButton.setImage(.dummy, for: .normal)
            }
            
            mainView.doneButton.setTitle("저장", for: .normal)
            mainView.doneButton.backgroundColor = .point
            mainView.doneButton.isEnabled = true
        } else {
            print("워크스페이스 추가하기 진입")
        }
    }
    
    // UIImage -> Data 객체로 변환하는 메서드
    private func convertImageToData(_ image: UIImage) -> Data {
        return image.jpegData(compressionQuality: 0.2) ?? Data()
    }
    
    private func bind() {
        
        let input = AddViewModel.Input(
            xButton: mainView.xButton.rx.tap, 
            profileImageButton: mainView.workspaceImageButton.rx.tap, 
            nameTextField: mainView.nameTextField.rx.text.orEmpty,
            explainTextField: mainView.explainTextField.rx.text.orEmpty,
            workspaceImage: imageData,
            doneButton: mainView.doneButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.xButtonTap
            .drive(with: self) { owner, _ in
                switch owner.workspaceAction {
                case .edit:
                    owner.dismiss(animated: true)
                case .add:
                    let vc = SwitchViewController()
                    ChangeRootVCManager.shared.changeRootVC(vc)
                }
            }
            .disposed(by: disposeBag)
        
        // 프로필 버튼 탭
        output.profileImageButtonTap
            .drive(with: self) { owner, _ in
                let actionSheet = UIAlertController(title: "워크스페이스 이미지를 넣어주세요! (필수)", message: nil, preferredStyle: .actionSheet)
                
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
                    configuration.selectionLimit = 1
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
        
        // 생성하기 버튼 활성화
        output.doneButtonValid
            .drive(with: self) { owner, isValid in
                owner.mainView.doneButton.backgroundColor = isValid ? .point : .inactive
                owner.mainView.doneButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        // 이름 유효성 검증 결과 UI 업데이트
        output.isNameValidResult
            .bind(with: self) { owner, isValid in
                print("+++", isValid)
                owner.mainView.nameLabel.textColor = isValid ? .textPrimary : .error
            }
            .disposed(by: disposeBag)
        
        // 워크스페이스 생성 API 결과 UI 업데이트
        output.isDoneButtonValid
            .bind(with: self) { owner, isValid in
                if isValid {
                    // 루트뷰 전환
                    let vc = SwitchViewController()
                    vc.workspaceID = owner.viewModel.workspaceID
                    ChangeRootVCManager.shared.changeRootVC(vc)
                } else {
                    let buttonTopY = owner.mainView.doneButton.frame.origin.y
                    owner.showToast(message: "에러가 발생했어요.\n잠시 후 다시 시도해주세요.", y: buttonTopY)
                }
            }
            .disposed(by: disposeBag)
    }
    

}

// UIImagePicker 카메라
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let imageToData = convertImageToData(image)
            mainView.workspaceImageButton.setImage(UIImage(data: imageToData), for: .normal)
            imageData.accept(imageToData)
        } else {
            print("Error converting image to data.")
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

// PHPicker 앨범
extension AddViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let selectedImage = image as? UIImage {
                            if let imageToData = self?.convertImageToData(selectedImage) {
                                self?.mainView.workspaceImageButton.setImage(UIImage(data: imageToData), for: .normal)
                                self?.imageData.accept(imageToData)
                            } else {
                                print("Error converting image to data.")
                            }
                        } else {
                            print("Error loading image.")
                        }
                    }
                }
            }
        }
    }
    
}
