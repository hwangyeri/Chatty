# Chatty

![chatty_mockup](https://github.com/hwangyeri/Chatty/assets/114602459/9c531a85-0886-4529-95d0-64a84ec5d4b0)

### 어디서든 팀을 모을 수 있는 메신저 앱입니다.
- **회원 관리**: 회원가입 • 소셜 로그인 • 이메일 로그인 • 로그아웃
- **워크스페이스**: 생성 • 조회 • 편집 • 삭제 • 검색 • 퇴장 • 멤버 초대 • 권한 변경
- **채널**: 생성 • 조회 • 편집 • 삭제 • 검색 • 멤버 관리 • 채팅 관리 • 권한 변경
- **DM**: 생성 • 조회 • 채팅 관리
- **프로필**: 내 프로필 정보 조회 • 수정 • 다른 유저 프로필 조회
- **스토어**: 코인 결제 
<br/>

## 1. 개발 환경
- Xcooe 15.0.1
- Deployment Target iOS 16.0
- 가로모드 / 다크모드 미지원
<br/>

## 2. 개인 프로젝트
- **개발 기간** : 2024.01.03 ~ 2024.02.29 (2달)
- **개발 인원** : 1명
<br/>

## 3. 기술 스택
- `UIKit`, `CodeBaseUI`, `RxSwift`, `SPM`
- `MVVM`, `Input-Output`, `Singleton`, `Design System`
- `Alamofire`, `SocketIO`, `Realm`, `Kingfisher`
- `KakaoSDK`, `AuthenticationServices`, `FirebaseMessaging`
- `Snapkit`, `Then`, `SideMenu`, `iamport-ios`
<br/>

### 3.2 Tools
- `Git/Github`, `Confluence`, `Swagger`, `Figma`
<br/>

## 4. 핵심 기능
- `KakaoSDK`, `AuthenticationServices`을 이용한 소셜 로그인 구현
- `filter`, `withLatestFrom` 등 `operator`를 이용한 `RxSwift` 기반의 반응형 UI 구현
- 계층적인 데이터 구조를 이용한 `Expandable TableViewCell`과 다양한 타입의 `Custom Cell` 구성
- `Dispatch Group`과 트리거를 이용한 순서가 보장된 다중 네트워크 비동기 처리 및 제어 구조 구현
- `SocketIO`를 이용한 양방향 통신의 실시간 채팅 기능 구현
- `Realm DB`를 이용한 과거 채팅 내역 관리 및 불필요한 서버 요청 최소화
- `Protocol`과 `Singleton` 패턴을 이용한 네트워크 요청 로직 모듈화 및 추상화
- 아직 작성중
<br/>

## 5. Trouble Shooting
### 트러블 슈팅
- **문제 상황** : -
- **해결 방법** : -
<br/>

## 6. UI
#### 6-1. 회원가입, 로그인
![chatty_UI_01](https://github.com/hwangyeri/Chatty/assets/114602459/ad4fe93c-7852-4f62-86eb-df8bfb5b35de)

#### 6-2. 워크스페이스, 채널, 채팅
![chatty_UI_02](https://github.com/hwangyeri/Chatty/assets/114602459/0f9b1f82-5b84-4623-9ec1-9c400bd69878)

#### 6-3. PG 결제
![chatty_UI_03](https://github.com/hwangyeri/Chatty/assets/114602459/b46f0ca8-dcd7-4cda-b701-dfd55f5a4f36)

<br/>

## 7. 회고
### Keep
- 수정 예정
  
### Problem • Try
- 수정 예정
<br/>

## 8. Commit Convention
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
