import gradio as gr
import openai
import json
import requests
from cgan_inference import inference   


openai.api_key = ""

def generate_brain_mri_image(label: int):
    resp = requests.post("http://127.0.0.1:5000/generate",
                     json={"label": int(label)})
    
    print("label : ", label)
    # img_data = inference(label,"brainGenSeg_v1")
    # print(img_data) 

    if resp.status_code == 200:
        result = resp.json().get('imageUrl')
    else:
        result = {}

    return {"image_url": result}

functions = [
    {
        "name": "generate_brain_mri_image",
        "description": "Use this function to generate brain mri images with and witout tumour. The output will be in JSON format.",
        "parameters": {
            "type": "object",
            "properties": {
                "label": {
                    "type": "integer",
                    "description": "value of 1 if the image is of brain with tumour or 0 if it has no tumour",
                }
            },
            "required": ["label"],
        },
    }
]


def ask_question(question: str):
    
    # First API call
    messages = [{"role": "user", "content": question}]
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo-0125",
        messages=messages,
        functions=functions,
        function_call="auto",
    )

    response_message = response["choices"][0]["message"]
    print(response_message)
    # Figure out which function to call
    function_response =""
    if response_message.get("function_call"):
        print("function was called")
        available_functions = {
            "generate_brain_mri_image": generate_brain_mri_image
        }
        function_name = response_message["function_call"]["name"]
        function_to_call = available_functions[function_name]
        function_args = json.loads(response_message["function_call"]["arguments"])
        # Call the user defined function
        function_response = function_to_call(
            label=function_args.get('label')
        )
        function_response = function_response
        messages.append(response_message)
        # Add the data from the function so chatGPT has that in its history
        messages.append(
            {
                "role": "function",
                "name": function_name,
                "content": str(function_response),
            }
        )
        print(function_response,response_message["function_call"]["arguments"])
        # Second API call to answer the users question based on the data retrieved from the custom function
    second_response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages,
    )
    answer = second_response['choices'][0]['message']['content']
    
    
    return answer,  "E:\OneDrive\SOCR\cGAN_Brain_MRI_sythesis\static\image.jpg"
    # return answer

# def gpt3_function(user_input):
#     # Replace this with your actual GPT-3 logic to get an image URL
#     image_url = "E:\OneDrive\SOCR\cGAN_Brain_MRI_sythesis\static\image.jpg"
#     return image_url

iface = gr.Interface(
    fn=ask_question,
    inputs="text",  # User input as text
    outputs=["text","image"],  # Display the image from the URL
)

iface.launch()
