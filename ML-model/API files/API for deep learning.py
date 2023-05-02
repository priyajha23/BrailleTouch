from flask import Flask, request, jsonify
import numpy as np
import cv2
import tensorflow as tf
import os
import base64

app = Flask(__name__)

interpreter = tf.lite.Interpreter(model_path="/home/Shuvam23dotRec/mysite/braille_classifier.tflite")
interpreter.allocate_tensors()

decode = {0:'A', 1:'B',2:'C',3:'D', 4:'E', 5:'E', 6:'F',7:'G', 8:'H', 9:'I', 10:'J', 11:'K'}

def preprocess_image(image):
    img = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
    img = cv2.resize(img, (64, 64))
    img = np.expand_dims(img, axis=-1)
    img = img / 255.0
    return img

@app.route('/')
def main():
    return 'Homepage'

@app.route('/predict', methods=['POST'])
def predict():
    import os
    import base64
    if 'image' not in request.form:
        return jsonify({'message': 'No image data in the request'}), 400

    image_data = request.form['image']
    image = cv2.imdecode(np.fromstring(base64.b64decode(image_data), dtype=np.uint8), cv2.IMREAD_COLOR)

    img = preprocess_image(image)

    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    interpreter.set_tensor(input_details[0]['index'], img.reshape((1, 64, 64, 1)).astype(np.float32))
    interpreter.invoke()

    prediction = interpreter.get_tensor(output_details[0]['index'])
    decoded_prediction = decode[np.argmax(prediction)]

    return jsonify({'class': decoded_prediction})


