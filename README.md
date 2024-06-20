# OSS team#6 Apayo
![logo](https://github.com/Handoni/Apayo/assets/101948889/3f87c6be-79f3-4842-b8c1-335be0f472c6)

## About The Project
![apayo](https://github.com/Handoni/Apayo/assets/101948889/b8d97aa7-45bb-465d-9cb4-78f27165979b)

**APAYO**는 사용자가 자신이 겪고 있는 증상이 어떤 진료과의 질병인지 모를 때, 혹은 병원을 갈 수 없을 때 자신의 질병과 진료과를 추천받을 수 있는 서비스입니다.<br/>

APAYO is a service designed for users who are unsure about which medical specialty their symptoms fall under or who are unable to visit a hospital. It provides recommendations for possible illnesses and the appropriate medical specialties based on the symptoms described.

<br/>

## 🔗 Service Link
https://apayo.kro.kr/

Deployed with ![EC2](https://img.shields.io/badge/amazon%20ec2-ff9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)




## ⚙️ Tech Stack
### Front-end 

![flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GoogleMaps](https://img.shields.io/badge/Google%20Maps-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white)


### Back-end

![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![mongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white)

![ChatGPT](https://img.shields.io/badge/chatGPT-74aa9c?style=for-the-badge&logo=openai&logoColor=white)
![병원정보](https://img.shields.io/badge/건강보험심사평가원-병원정보%20API-0066CC?style=for-the-badge&logoColor=white)

### IDE
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)

### Coummunication Tool  
![github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)
![notion](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white)   

### OS
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)

<br/>

## ✅ Required environment
### Front-end
Flutter SDK: 3.22.1 or higher

Dart SDK: 2.4.1 or higher

### Back-end
Python 3.11 or higher

<br/>

## ⏩ How to Execute 
 Clone the repository: `git clone https://github.com/Handoni/Apayo.git`
### Front-end
1. Navigate to the project directory: `cd frontend`
2. Install dependencies: `flutter pub get`
3. Run the Flutter app: `flutter run`

Depending on your environment, you might need to:

- Add `assets/config.json`
```json
{
    "googleMapsApiKey": "your-api-key"
}
```
- Change address for api request
```dart
'https://apayo.kro.kr/api/primary_disease_prediction/'
-> 'your-address'
```

### Back-end
1. Navigate to the project direcroty: `cd backend/app`
2. Install dependencies: `pip install -r requirements.txt`
3. Start server: `python main.py`

Depending on your environment, you might need to:

- Add `.env`
``` 
GPT_API_KEY = 'your-api-key'
MONGO_URI = 'your-mongodb-uri'
TOKEN_SECRET = 'your-token-secret'
TOKEN_ALGORITHM = 'HS256'
TOKEN_EXPIRE_MINUTES = 60
HOSPITAL_API_KEY = 'your-hospital-info-api-key'
```

<br/>

## 👍 Key features
- **건강보험심사평가원의 병원정보 API**를 활용한 신뢰 가능하고 정확한 병원 정보 제공<br/>
Provide reliable and accurate hospital information using the **Hospital Information API of HIRA**

- **서울아산병원**의 신뢰 가능한 질병-증상 데이터 셋 임베딩<br/>
Embedded reliable Disease-Symptoms Dataset of **Asan Medical Center**

- **Google Maps API**를 이용한 데이터 시각화<br/>
Data visualization using **Google Maps API**

- **GPT API Function Calling** 기능을 통한 안정적인 입출력<br/>
Stable input/output through GPT API Function Calling

- **간지나는 반응형 ui** 😎 <br/>
Dope responsive ui 😏



<br/>


## Contributors
### Ryu soo jung   
@shu030929

### Lee sang yun    
@Handoni    
@Handoni-CAU

### Hyun so young   
@thdudgus
