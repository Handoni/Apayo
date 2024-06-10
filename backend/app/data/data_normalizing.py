import pandas as pd

# 기존 데이터를 불러옴
df = pd.read_csv(
    "D:/programming/Apayo/backend/app\disease_symptoms.csv", encoding="utf-8-sig"
)

# 정규화된 데이터 저장용 딕셔너리 초기화
symptom_dict = {}

# 각 질병에 대해 증상을 분리하여 정규화된 데이터 생성
for index, row in df.iterrows():
    symptoms = str(row["Symptoms"]).split(", ") if pd.notna(row["Symptoms"]) else []
    for symptom in symptoms:
        if symptom in symptom_dict:
            symptom_dict[symptom].append(row["Title"])
        else:
            symptom_dict[symptom] = [row["Title"]]

# 딕셔너리를 데이터 프레임으로 변환
normalized_data = [
    {"Symptom": symptom, "Disease": ", ".join(diseases)}
    for symptom, diseases in symptom_dict.items()
]
normalized_df = pd.DataFrame(normalized_data)

# 데이터 프레임 출력
print(normalized_df)

# 정규화된 데이터를 CSV 파일로 저장
normalized_df.to_csv(
    "normalized_symptoms_diseases.csv", index=False, encoding="utf-8-sig"
)
