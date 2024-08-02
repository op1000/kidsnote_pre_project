# kidsnote_pre_project

### 프로젝트 실행
terminal 에서 아래 명령 수행 

    $ tuist generate

### 프로젝트 특징
- Google Books Api 구현은 tuist 를 활용해서 pre-kit 타겟으로 모듈화 
- UI 와 UI ViewModel 의 구현은 tuist 를 활용해서 pre-ui 타겟으로 모듈화
- 전반적인 구조는 MVVM 구조 활용
- swiftUI 와 combine 으로 구현
- 검색 결과를 연산하는 과정을 actor 로 구현하여 스레드 경합을 방지 (SearchedList actor)
- 검색 결과 상태 관리를 위해서 state 개념을 활용 (StateData 구조체)
- 이미지를 다운받는 기능은 ImageView 와 ImageViewModel 으로 구현하였으며, 라이브러리 의존 없이 asyc-await 를 활용
- 네트워크 기능은 BooksApi 와 BooksDto 에 구현하였으며, 라이브러리 의존 없이 asyc-await 를 활용
- github issue 를 활용해서 개발 이슈 관리 
    - 충돌 방지를 위해서 커밋을 원자적으로 관리
        - 프로젝트 설정 커밋 별도
        - 파일 추가 커밋 별도
        - 구현 커밋 별도
    - [깃헙 이슈 관리 링크](https://github.com/op1000/kidsnote_pre_project/issues?q=is%3Aissue+is%3Aclosed)

### 앱 기능 설명
- 검색 결과에서 ebook, audio 두가지 카테고리 검색이 요구사항이었으나, audio 구분은 api 에서 명확하게 결과를 필터링할 방법을 찾을 수 없어서 모든 겸색 결과 (all)로 변경하여 구현
    - 첫번째 탭 ebook: 'filter=ebook' 파라미터 활용하여 전자책(ebook)만 fetch
    - 두번째 탭 all: 'filter=ebook' 파라미터를 제거하여 모든 결과 fetch

- 상세 화면의 "무료샘플", "전체 도서 구매하기" 버튼은 api response 중에 적절한 url 이 존재하여 SFSafariViewController 에서 로딩하도록 구현