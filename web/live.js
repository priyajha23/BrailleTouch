let prev="",curr="";
function fetchFromAPI(){
    const apiUrl = 'https://braille-70ade-default-rtdb.firebaseio.com/Prototype.json';
    
   
    fetch(apiUrl)
      .then(response => response.json())
      .then(data => {
        
        const dataBody = document.getElementById('data');
        dataBody.innerText=data.Data;
        if(curr!==data.Data){
            prev=curr;
        
        curr=data.Data;
        speechCompare(prev,curr);
        }
       
        
      })
      .catch(error => console.error(error));
    
    }



function speechCompare(prev,curr){
    let i=0;
   
    if(prev.length<curr.length){for(i=0;i<prev.length;i++){
        if(prev[i]!==curr[i]){
            break;
        }
    }}
    if(i!==prev.length){
        speak(curr);
    }
    else{
        speak(curr.slice(prev.length));
    }

}

function speak(text){
    
    const utterance=new SpeechSynthesisUtterance(text);
    utterance.voice=speechSynthesis.getVoices()[0];
    speechSynthesis.speak(utterance);

}


    
    $(document).ready(function(){
       
        $("#myBtn").click(function(){
            let pdfData = $("#data").text();

             if(pdfData){
                doc=new jsPDF();
                doc.text(pdfData,10,10);
                doc.save("Your_data.pdf")
        
             }
             else{
                console.log("Empty");
             }
                
            
        });
    });
    
    setInterval(fetchFromAPI,"100");
   
    
    
     
    function downloadDOC(){
        var data=document.querySelector('#data').innerText;
        const blob = new Blob([data], { type:'application/vnd.openxmlformats-officedocument.wordprocessingml.document' });
        const downloadURL = window.URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = downloadURL;
        link.download = 'data.docx';
        link.click();
    }
    
    