import pandas as pd
import csv

def clean(symptom):
    # 증상이 None이거나 NaN인 경우 처리
    if pd.isna(symptom):
        return None
    parts = symptom.split('^')
    cleaned_parts = [part.split('_')[1] if '_' in part else part for part in parts]
    return '^'.join(cleaned_parts)

def process_csv(input_file, output_file):
    try:
        df = pd.read_csv(input_file)
    except FileNotFoundError:
        print(f"파일을 찾을 수 없습니다: {input_file}")
        return

    # 'Disease' 필드에서 UMLS 코드 제거
    df['Disease'] = df['Disease'].apply(clean)

    # 'Symptom' 필드에서 UMLS 코드 제거
    df['Symptom'] = df['Symptom'].apply(clean)

    # 'Count of Disease Occurrence' 열을 Int64로 변환하여 NaN 값이 유지되도록 함
    df['Count of Disease Occurrence'] = df['Count of Disease Occurrence'].astype('Int64')

    # 결과를 새로운 CSV 파일로 저장
    df.to_csv(output_file, index=False, quoting=csv.QUOTE_ALL)

# 파일 경로 설정
input_file = "C:/Users/이상윤/Documents/coding/Apayo/backend/app/data/raw_data_2.csv"
output_file = "C:/Users/이상윤/Documents/coding/Apayo/backend/app/data/output.csv"

# 함수 실행
process_csv(input_file, output_file)
