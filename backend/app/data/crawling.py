import requests
from bs4 import BeautifulSoup
import pandas as pd

# 데이터 저장용 리스트 초기화
all_data = []

total_pages = 64

# 각 페이지 순회
for page in range(1, total_pages + 1):
    # URL 설정
    url = f"https://www.amc.seoul.kr/asan/healthinfo/disease/diseaseList.do?pageIndex={page}&partId=&diseaseKindId=&searchKeyword="

    # 페이지 요청
    response = requests.get(url)
    response.encoding = "utf-8"

    # BeautifulSoup 객체 생성
    soup = BeautifulSoup(response.text, "html.parser")

    # 질병 항목 선택
    diseases = soup.select(".descBox li")

    for disease in diseases:
        # 제목
        title = disease.select_one(".contTitle a").text.strip()

        # 증상, 관련 질환, 진료과, 동의어 초기화
        symptoms = ""
        related_diseases = ""
        departments = ""
        synonyms = ""

        # <dt> 태그들을 순회
        dt_tags = disease.select("dl dt")
        for dt in dt_tags:
            dd = dt.find_next_sibling("dd")
            if not dd:
                continue
            if dt.text.strip() == "증상":
                symptoms = ", ".join(a.text for a in dd.select("a"))
            elif dt.text.strip() == "관련질환":
                related_diseases = ", ".join(a.text for a in dd.select("a"))
            elif dt.text.strip() == "진료과":
                departments = ", ".join(a.text for a in dd.select("a"))
            elif dt.text.strip() == "동의어":
                synonyms = dd.text.strip()

        # 데이터 저장
        all_data.append(
            {
                "Title": title,
                "Symptoms": symptoms,
                "Related Diseases": related_diseases,
                "Departments": departments,
                "Synonyms": synonyms,
            }
        )

# DataFrame으로 변환
df = pd.DataFrame(all_data)

# 데이터 프레임 출력
print(df)

# 데이터 프레임을 CSV 파일로 저장
df.to_csv("disease_symptoms.csv", index=False, encoding="utf-8-sig")
