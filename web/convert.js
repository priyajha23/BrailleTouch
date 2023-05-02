// selecting all required elements
const dropArea = document.querySelector(".drag-area"),
dragText = dropArea.querySelector("header"),
button = dropArea.querySelector("button"),
input = dropArea.querySelector("input");
let file; //this is a global variable and we'll use it inside multiple functions

button.onclick = ()=>{
  input.click(); //if user click on the button then the input also clicked
}

input.addEventListener("change", function(){
  //getting user select file and [0] this means if user select multiple files then we'll select only the first one
  file = this.files[0];
  dropArea.classList.add("active");
//   showFile(); //calling function
submit(file);
});


// If user Drag File Over DropArea
dropArea.addEventListener("dragover", (event)=>{
  event.preventDefault(); //preventing from default behaviour
  dropArea.classList.add("active");
  dragText.textContent = "Release to Upload File";
});

// If user leave dragged File from DropArea
dropArea.addEventListener("dragleave", ()=>{
  dropArea.classList.remove("active");
  dragText.textContent = "Drag & Drop to Upload File";
});

// //If user drop File on DropArea
dropArea.addEventListener("drop", (event)=>{
  event.preventDefault(); //preventing from default behaviour
  //getting user select file and [0] this means if user select multiple files then we'll select only the first one
  file = event.dataTransfer.files[0];
   //calling function
   submit(file);
});

$(function() {
    $('#pdf-form').submit(function(event) {
        event.preventDefault();

        var formData = new FormData();
        formData.append('pdf_file', $('input[type=file]')[0].files[0]);

        $.ajax({
            url: 'http://shuvconverter23.pythonanywhere.com/convert',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(data) {
                $('#text').text(data.braille_text);
            },
            error: function(xhr, status, error) {
                console.log(xhr.responseText);
            }
        });
    });
}); 

const submit=function(file){
    var formData = new FormData();
    formData.append('pdf_file', file);

    $.ajax({
        url: 'http://shuvconverter23.pythonanywhere.com/convert',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(data) {
            $('#text').text(data.braille_text);
        },
        error: function(xhr, status, error) {
            console.log(xhr.responseText);
        }
    });
}

let fonts=["xx-small", "x-small", "small","medium", "large", "x-large", "xx-large"];
let range=document.getElementById('fontSize');


range.addEventListener("change",(event)=>{
    console.log(range.value);

    document.querySelector('#text').style.fontSize=fonts[range.value-1];
});




