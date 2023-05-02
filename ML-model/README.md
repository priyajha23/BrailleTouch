# Braille

# Machine Learning models

The link to the pre-available datasets is here: https://drive.google.com/drive/folders/1liuwcSf6XtYmFqdYU8bKRE9rAiDfMC1C?usp=sharing
download the dataset paste it on your google collab and then run the notebook. We will later integrate it in pycharm.

So initially we took some pre-available datasets of braille and trained a model based on that. We initially used a very basic model of Logistic Regression as a multiclass classification for the letters of the braille characters.

We found the model was giving us an accuracy percentage of 92.62%.

We then went for a more deeper approach and tried with a deep neural network, and hence we used a convolution neural network with sequential algorithm. We used optimizer as adam and also used cross entropy loss for a perfect evaluation of the model.

The new deep learning model really gave us a more prominenet result and also provided us an accuracy percentage of 99.873 %. The numbers went high because the datasets we used to train the model were collected perfectly using the mobile application only.

![image](https://user-images.githubusercontent.com/101086033/230752212-0c446c62-5687-4c7f-880e-1f3b329afb57.png)

# API

I have made three working APIs hosted online for using it in different platforms. The API_1 is the braille conversion API using logistic regression which had lesser accuracy, but there is another API named (API for deep learning) that uses the state of the art deep learning algorithm.

Then there is another API to take any input pdf and convert the text to braille so that user or the person who is converting can use it to print the text and use ut commercially.

For both the APIs I have used flask. I hosted them on pythonanywhere.com. 

The links of the APIs are: 

1. http://braille23.pythonanywhere.com/upload (for Logistic Regression)

2. http://shuvam23dotrec.pythonanywhere.com/predict (for Deep Learning Neural Network)

3. http://shuvconverter23.pythonanywhere.com/upload (for PDF to Braille conversion)

