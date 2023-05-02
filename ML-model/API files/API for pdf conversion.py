from flask import Flask, request, jsonify
import PyPDF2
from werkzeug.utils import secure_filename
from io import StringIO
from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
from pdfminer.converter import TextConverter
from pdfminer.layout import LAParams
from pdfminer.pdfpage import PDFPage
import os
from flask_cors import CORS




#!/usr/bin/env python3
from http.server import HTTPServer, SimpleHTTPRequestHandler, test
import sys

class CORSRequestHandler (SimpleHTTPRequestHandler):
    def end_headers (self):
        self.send_header('Access-Control-Allow-Origin', '*')
        SimpleHTTPRequestHandler.end_headers(self)

if __name__ == '__main__':
    test(CORSRequestHandler, HTTPServer, port=int(sys.argv[1]) if len(sys.argv) > 1 else 8000)

app = Flask(__name__)
CORS(app)
# Dictionary of Braille characters
braille_dict = {
    'a': '⠁', 'b': '⠃', 'c': '⠉', 'd': '⠙', 'e': '⠑',
    'f': '⠋', 'g': '⠛', 'h': '⠓', 'i': '⠊', 'j': '⠚',
    'k': '⠅', 'l': '⠇', 'm': '⠍', 'n': '⠝', 'o': '⠕',
    'p': '⠏', 'q': '⠟', 'r': '⠗', 's': '⠎', 't': '⠞',
    'u': '⠥', 'v': '⠧', 'w': '⠺', 'x': '⠭', 'y': '⠽',
    'z': '⠵', '1': '⠂', '2': '⠆', '3': '⠒', '4': '⠲',
    '5': '⠢', '6': '⠖', '7': '⠶', '8': '⠦', '9': '⠔',
    '0': '⠴', ' ': ' '
}

app.secret_key = "caircocoders-ednalan"

UPLOAD_FOLDER = '/home/ShuvConverter23/upload'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS



# Function to convert a string to Braille
def to_braille(string):
    print("in")
    braille_string = ''
    for char in string.lower():
        if char in braille_dict:
            braille_string += braille_dict[char]
    return braille_string

# Function to read text from a file
def read_text_file(filename):
    with open(filename, 'r') as file:
        text = file.read()
    return text

# Function to read text from a PDF file
def read_pdf_file(filename):
    text = ""

    with open(filename, 'rb') as file:
        from io import StringIO
        from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
        from pdfminer.converter import TextConverter
        from pdfminer.layout import LAParams
        from pdfminer.pdfpage import PDFPage
        resource_manager = PDFResourceManager()
        text_stream = StringIO()
        laparams = LAParams()
        converter = TextConverter(resource_manager, text_stream, laparams=laparams)
        interpreter = PDFPageInterpreter(resource_manager, converter)
        for page in PDFPage.get_pages(file):
            interpreter.process_page(page)
            text += text_stream.getvalue()
            text_stream.seek(0)
            text_stream.truncate()
    return text

@app.route('/')
def main():
    return 'Homepage'

# Route to handle braille conversion request
import base64

@app.route('/upload', methods=['POST'])
def upload_file():
    pdf_base64 = request.form.get('pdf_base64')
    if not pdf_base64:
        resp = jsonify({'message': 'No PDF data in the request'})
        resp.status_code = 400
        return resp

    pdf_data = base64.b64decode(pdf_base64)
    filename = 'uploaded.pdf'
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)

    with open(filepath, 'wb') as f:
        f.write(pdf_data)

    input_text = read_pdf_file(filepath)
    braille_text = to_braille(input_text)
    #os.remove(filepath)

    return jsonify({'braille_text': braille_text})

@app.route('/convert', methods=['POST'])
def convert_to_braille():
    pdf_file = request.files['pdf_file']

    # convert PDF file to base64-encoded string
    pdf_data = pdf_file.read()
    pdf_base64 = base64.b64encode(pdf_data).decode('utf-8')

    pdf_data = base64.b64decode(pdf_base64)
    filename = 'uploaded.pdf'
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)

    with open(filepath, 'wb') as f:
        f.write(pdf_data)

    input_text = read_pdf_file(filepath)
    braille_text = to_braille(input_text)
    #os.remove(filepath)

    return jsonify({'braille_text': braille_text})


