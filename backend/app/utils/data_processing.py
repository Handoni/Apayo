from openai import ChatCompletion

def parse_gpt_response(response : str) -> list:
    
    responses = response.split("\n")

    symptoms = [_.strip() for _ in responses[1].replace('2.','').split(",")]
    
    diseases = [_.strip() for _ in responses[0].replace('1.','').split(",")]
    
    # Extract the disease-symptom pairs
    temp = []
    for pair in responses[2].split("/"):
        temp.append([_.strip() for _ in pair.replace('3.','').split(",")])
        
    disease_symptom_pairs = {_[0]:_[1:] for _ in temp}
    
    
    return symptoms, diseases, disease_symptom_pairs
