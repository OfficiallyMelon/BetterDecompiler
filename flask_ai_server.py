from flask import Flask, request, jsonify
from g4f.client import Client

app = Flask(__name__)
client = Client()

@app.route('/fix_script', methods=['POST'])
def fix_script():
    # Extract the script from the POST request
    data = request.get_json(force=True)

    if not data or 'script' not in data or not data['script']:
        # Return empty output if no script is provided
        return jsonify({'fixed_script': ''})

    script_content = data['script']

    # Prepare the request to the g4f API
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": "You will be given a luau script (that has been decompiled), you will rename the variables, and functions to sound better. make the script more coherent. add comments to areas of the script. return the fixed script, do not add ``` as we handle that. If no script has been given, do not produce any output. (empty output)"},
            {"role": "user", "content": script_content}
        ]
    )

    # Return the fixed script
    fixed_script = response.choices[0].message.content
    return jsonify({'fixed_script': fixed_script})

if __name__ == '__main__':
    app.run(debug=True)
