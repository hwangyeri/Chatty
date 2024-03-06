# Chatty
<img width="70" alt="스크린샷 2024-03-07 오전 12 24 37" src="https://github.com/hwangyeri/Chatty/assets/114602459/85850016-5ee0-463a-95ef-477476e484e8">

### 어디서든 팀을 모을 수 있는 메신저 앱입니다.

![chatty_mockup](https://github.com/hwangyeri/Chatty/assets/114602459/9c531a85-0886-4529-95d0-64a84ec5d4b0)

## 주요 기능
- 회원가입 • 소셜 로그인 • 이메일 로그인 • 로그아웃 기능
- 워크스페이스 / 채널 / DM 관리 • 검색 • 멤버 초대 • 채팅 관리 • 권한 변경 기능
- 내 프로필 관리 • 코인 결제 • 실시간 채팅 기능
<br/>

## 개발 환경
- **최소 버전** : iOS 16.0
- **개발 인원** : 1명
- **개발 기간** : 2024.01.03 ~ 2024.02.29 (2달)
<br/>

## 기술 스택
- `UIKit`, `CodeBaseUI`, `SPM`
- `MVVM`, `Singleton`, `Input-Output`, `Design System`
- `AutoLayout`, `Snapkit`, `Then`, `SideMenu`
- `RxSwift`, `Alamofire`, `Kingfisher`
- `KakaoSDK`, `AuthenticationServices`, `FCM`
- `SocketIO`, `Realm`, `WebKit`, `iamport-ios`
- `SwiftKeychainWrapper`, `IQKeyboardManagerSwift`
<br/>

### 협업 도구
- `Git/Github`, `Confluence`, `Swagger`, `Figma`
<br/>

## 핵심 기술
- `KakaoSDK`, `AuthenticationServices`을 이용한 소셜 로그인 구현
- `MultipartForm/Data` • `Kingfisher`를 이용한 여러 장의 이미지 업로드 및 캐싱, 다운샘플링 구현
- 계층적인 데이터 구조를 이용한 `Expandable TableViewCell`과 다양한 타입의 `Custom Cell` 구성
- `Dispatch Group`과 트리거를 이용한 순서가 보장된 다중 네트워크 비동기 처리 및 제어 구조 구현
- `SocketIO`를 이용한 양방향 통신의 실시간 채팅 기능 구현
- `Realm DB`를 이용한 과거 채팅 내역 관리 및 불필요한 서버 요청 최소화
- `PG`를 연동하여 영주증 검증 로직 및 `WebView`와 `Deep Link`를 이용한 결제 시스템 구현
- `Protocol`과 `Singleton` 패턴을 이용한 네트워크 요청 로직 모듈화 및 추상화
<br/>

## 구현 기능
### 1. Realm, HTTP, Socket을 조합해서 실시간 채팅 기능 구현
#### 1-1. 채팅 화면 진입 시 초기 데이터 로딩 로직
<img width="700" alt="스크린샷 2024-03-06 오후 4 12 42" src="https://github.com/hwangyeri/Chatty/assets/114602459/8174905a-cdf8-41a0-a937-70d3abdc34a4">


#### 1-2. 실시간 채팅 응답/전송 로직 
<img width="700" alt="스크린샷 2024-03-06 오후 4 12 15" src="https://github.com/hwangyeri/Chatty/assets/114602459/065b051a-90de-426b-8b49-b3907db8cd86">

<br/><br/>

## 문제 해결
### 1. 섹션별 다양한 Cell Type 및 터치 이벤트 처리의 복잡성 해소
- **문제 상황** : Expandable TableViewCell을 구현하는 과정에서 각 섹션마다 다양한 Cell을 구성하고, 터치 이벤트를 처리 하기 위한 메서드에서 복잡한 연산과 if문이 증가하는 문제가 발생함.
- **해결 방법** : ViewModel에서 Enum을 활용하여 각 셀의 타입을 명시적으로 정의하는 계층적인 데이터 구조를 도입함. 이를 통해 데이터 처리를 단순화하고, 셀을 구분해 필요한 데이터를 미리 가공하여 셀에 전달함으로써 중복 코드를 최소화하고 코드의 가독성을 향상시킴.


```swift

// HomeViewModel

  func fetchNumberOfRowsInSection(section: Int) -> Int {
      guard let channelsData = channelsData, let dmData = dmData else {
          print("NumberOfRowsInSection channelsData Error: \(channelsData)")
          print("NumberOfRowsInSection dmData Error: \(dmData)")
          return 0
      }
      
      switch section {
      // 섹션이 열린 경우 => 데이터 개수 + 제목 셀 하나 추가해서 보여주기
      // 섹션이 닫힌 경우 => 제목 셀 하나 보여주기
      case 0:
          // 채널
          return channelsData.isOpened ? channelsData.sectionData.count + 2 : 1 // 플러스 셀 때문에 + 2
      case 1:
          // 다이렉트 메세지
          return dmData.isOpened ? dmData.sectionData.count + 2 : 1
      default:
          // 팀원 추가
          return 1
      }
  }

  enum HomeTableViewCellType {
        case sectionCell
        case channelRowCell
        case dmRowCell
        case plusCell
    }
      
  func cellType(indexPath: IndexPath) -> HomeTableViewCellType {
      guard let channelsData = channelsData, let dmData = dmData else {
          return .sectionCell
      }
      
      switch (indexPath.section, indexPath.row) {
      case (0, 0), (1, 0): 
          return .sectionCell
      case (0, channelsData.sectionData.count + 1), (1, dmData.sectionData.count + 1), (2, 0):
          return .plusCell
      case (0, _): 
          return .channelRowCell
      case (1, _):
          return .dmRowCell
      default:
          return .sectionCell
          
      }
  }

```
<br/>
  
### 2. 순서가 보장되지 않는 비동기 네트워크 동시 호출로 인한 데이터 누락
- **문제 상황** : 여러 네트워크 호출이 동시에 이뤄졌는데 원하는 순서로 보장되지 않아, 모든 비동기 작업이 완료되기 전에 뷰가 나타나서 데이터 누락 문제 발생함.
- **해결 방법** : DispatchGroup을 활용하여 여러 비동기 작업을 그룹화하고, 각 작업이 완료될 때마다 특정 트리거(PublishRelay)를 활용하여 작업 완료 시점을 체크함. 이를 통해 원하는 순서로 작업이 수행되도록 조절하고, DispatchGroup의 notify 클로저 내에서 다음 작업을 실행함으로써 비동기 작업의 순서를 보장하고 데이터 누락 문제를 방지함.


```swift
  // Top UI 데이터 조회
    func fetchTopData() {
        let group = DispatchGroup()
        
        if workspaceID != nil {
            group.enter()
            // 내가 속한 워크스페이스 한 개 조회 API
            NetworkManager.shared.request(
                type: Workspace.self,
                router: .oneWorkspaceRead(id: workspaceID ?? 0),
                completion: { [weak self] result in
                    switch result {
                    case .success(let data):
                        print("🩵 내가 속한 워크스페이스 한 개 조회 API 성공")
                        dump(data)
                        self?.workspaceData = data
                    case .failure(let error):
                        print("💛 내가 속한 워크스페이스 한 개 조회 API 실패: \(error.errorDescription)")
                    }
                    
                    group.leave()
                })
        } else {
            print("워크스페이스 없음")
        }
        
        group.enter()
        // 내 프로필 정보 조회 API
        NetworkManager.shared.request(
            type: MyProfileOutput.self,
            router: .usersMy) { [weak self] result in
            switch result {
            case .success(let data):
                print("🩵 내 프로필 정보 조회 API 성공")
                dump(data)
                self?.myProfile = data
                self?.isCompletedTopUIData.accept(true)
            case .failure(let error):
                print("💛 내 프로필 정보 조회 API 실패: \(error.errorDescription)")
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.fetchHomeData()
        }
    }
```
<br/>

## 고민한 점
#### 1. MVVM 아키텍처 도입으로 TableView 복잡성 해결
- ViewController에서 처리해야 하는 작업이 증가함에 따라 TableView 작업의 복잡성이 높아져, MVVM 아키텍처를 도입하여 이를 해결했습니다.

#### 2. 네임스페이스 및 Enum 활용으로 코드 가독성 향상
- 객체명이나 반복되는 텍스트를 하드코딩 대신 네임스페이스를 설정하고, enum을 활용하여 명명된 상수로 정의하여 코드 가독성을 향상시켰습니다.

#### 3. Result Type 도입으로 네트워크 요청 처리 간결화
- 네트워크 요청 시 발생할 수 있는 다양한 처리를 간결한 형태로 다루기 위해 Result Type을 도입하여 코드의 가독성을 높였습니다.

#### 4. Lazy 변수를 활용한 메모리 효율 개선
- 필수적이지 않은 UI는 lazy 변수로 선언하여 메모리 효율을 높였습니다.

#### 5. 강제 언래핑 대신 nil 처리를 통한 앱 안정성 강화
- 강제 언래핑을 사용하는 대신, 모든 변수에 nil coalescing 또는 if/guard let 바인딩을 통해 앱 크러시를 방지하였습니다.
<br/>

## UI
#### 1. 회원가입, 로그인
![chatty_UI_01](https://github.com/hwangyeri/Chatty/assets/114602459/ad4fe93c-7852-4f62-86eb-df8bfb5b35de)

#### 2. 워크스페이스, 채널, 채팅
![chatty_UI_02](https://github.com/hwangyeri/Chatty/assets/114602459/0f9b1f82-5b84-4623-9ec1-9c400bd69878)

#### 3. PG 결제
![chatty_UI_03](https://github.com/hwangyeri/Chatty/assets/114602459/b46f0ca8-dcd7-4cda-b701-dfd55f5a4f36)

<br/>

## Commit Convention
```
- [Feat] 새로운 기능 구현
- [Style] UI 디자인 변경
- [Fix] 버그, 오류 해결
- [Refactor] 코드 리팩토링
- [Remove] 쓸모 없는 코드 삭제
- [Rename] 파일 이름/위치 변경
- [Chore] 빌드 업무, 패키지 매니저 및 내부 파일 수정
- [Comment] 필요한 주석 추가 및 변경
- [Test] 테스트 코드, 테스트 코드 리펙토링
```

<br/>
