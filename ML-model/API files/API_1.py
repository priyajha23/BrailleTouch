
from flask import Flask, json, request, jsonify
import os
from werkzeug.utils import secure_filename
from sklearn.decomposition import PCA
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
import base64

path ="/home/Braille23/braille_1 2/train/"
files = os.listdir(path)[:5]
print(files)
print("1")
classes={'a':0, 'b':1, 'c':2, 'd':3, 'e':4, 'f':5, 'g':6, 'h':7, 'i':8, 'j':9}
pca = PCA(.98)

import cv2
x=[]
y=[]
print("2")

for cl in classes:
  pth = path+cl
  for img_name in os.listdir(pth):
    img = cv2.imread(pth+"/"+img_name,0)
    img = cv2.resize(img, (64, 64))
    x.append(img)
    y.append(classes[cl])


x=np.array(x)
y=np.array(y)
print("successfull")
x_new = x.reshape(len(x),-1)

xtrain, xtest, ytrain, ytest = train_test_split(x_new, y, test_size=0.20, random_state=10)
x_train = xtrain/255
x_test = xtest/255

#print(x_train.shape, x_test.shape)
pca = PCA(.98)
xtrain = pca.fit_transform(x_train)
xtest = pca.transform(x_test)

log = LogisticRegression()
log.fit(xtrain, ytrain)
print("2 successful")
app = Flask(__name__)
print("3 successful")
app.secret_key = "caircocoders-ednalan"

UPLOAD_FOLDER = '/home/Braille23/upload/static'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

print("4 successful")
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/')
def main():
    return 'Homepage'


@app.route('/upload', methods=['POST'])
def upload_file():
    # check if the post request has the file part
    import base64
    import io
    from PIL import Image

    if 'image' not in request.form:
        resp = jsonify({'message': 'No image data in the request'})
        resp.status_code = 400
        return resp

    image_data = request.form['image']
    image_bytes = io.BytesIO(base64.b64decode(image_data))
    image = Image.open(image_bytes)

    # Process the image
    img = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2GRAY)
    img = cv2.resize(img, (64, 64))
    img = pca.transform(img.reshape(1, -1)/255)

    # Make a prediction
    pred = log.predict(img)[0]
    decode = {0: 'A',1: 'B', 2: 'C',3: 'D',4: 'E',5: 'F',6: 'G',7: 'H',8: 'I',9: 'J'}
    pred_class = decode[pred]
    return jsonify({'class': pred_class})




