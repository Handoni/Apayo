                
def parse_gpt_response(response: dict) -> list:
    # Extract and return the relevant information from the GPT response
    text = response.get("choices", [])[0].get("text", "")
    return text.split(",")
