from app.utils.data_processing import parse_gpt_response
def test_data_processing():
    input = "1. 증상1, 증상2 \n 2. 질병1, 질병2 \n 3. 질병1, 증상1, 증상2, 증상3 / 질병2, 증상1, 증상2, 증상3"
    processed_data = parse_gpt_response(input)
    
    expected_output = (["증상1", "증상2"], ["질병1", "질병2"], {"질병1": ["증상1", "증상2", "증상3"], "질병2": ["증상1", "증상2", "증상3"]})
    
    assert processed_data == expected_output