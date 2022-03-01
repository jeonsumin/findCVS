# findCVS
내 주변 편의점 찾기 


## 기능 상세

- 주변 편의점을 지도에서 확인 할 수 있습니다. 
-  주변 편의점을 리스트로 볼 수 있습니다. 
-  주변 편의점이 없을 경우, 에러가 발생했을 경우 알람이 뜹니다. 

## 활용기술 

- RxSwift
- RxCocoa
- MVVM
- SnapKit

## DEMO

## 배운 내용

### CLLocationManager
> - 사용자의 현재 위치에서 크거나 작은 변화를 추적
> - 나침반에서 방향 변경 추적
> - 사용자 위치 기반 이벤트 생성
> - 근거리 데이터 통신기기(bluetooth Beacon)와 통신 

![스크린샷 2022-02-28 오전 10 20 16](https://user-images.githubusercontent.com/51107183/155909519-fef6aa9b-8e8c-4ce8-8021-4f915c441960.png)

### Unit Test
- 원하는 값이 나오는지 검증 
- 연속되어야 하는 동작이 수행되는지 검증 

#### XcTest 예제
![스크린샷 2022-03-01 오후 5 01 18](https://user-images.githubusercontent.com/51107183/156128813-de860e6b-cdff-4155-8583-0c0fa8c0689a.png)

#### Nimble
- 읽기 쉬운 TestAssertion 표현
- 간편한 비동기 테스트 작성

![스크린샷 2022-03-01 오후 5 03 27](https://user-images.githubusercontent.com/51107183/156129117-061236d9-e570-4c7c-abc6-529c0eeb5af5.png)

#### RxTest

- Observable에 시간 개념을 주입
- 임의의 Observer를 통해 subscribe 여부 관계 없이 검증 가능 

 ![스크린샷 2022-03-01 오후 5 07 07](https://user-images.githubusercontent.com/51107183/156129614-85f8761e-d973-4724-b9c8-169d17cf4b99.png)


#### RxBlocking 
- Observable의 Event 방출을 검증 
- 특정 시간동안 방출된 Observable의 Evnet 검증 

![스크린샷 2022-03-01 오후 5 09 13](https://user-images.githubusercontent.com/51107183/156129918-08ccc29d-61c5-4870-8ac7-c8502490c63c.png)
























