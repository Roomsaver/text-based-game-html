document.onkeypress = keyPress;



function submit()
{
    var userInputBox = document.getElementById('user-input');
    console.log(userInputBox.value);
    document.getElementById('prompt-text').prepend(`\n`);
    document.getElementById('prompt-text').prepend(userInputBox.value);
    userInputBox.value = "";
}



function keyPress(e)
{
    var x = e || window.event;
    var key = (x.keyCode || x.which);
    if(key == 13 || key == 3)
    {
        submit();
    }
}