
	 
var shiftIndex=3;
var k=0;

///////////////////////////////////////////////////////////
// take an array of letter so that we can change the index
// of array to represent different character.
///////////////////////////////////////////////////////////

var letter=new Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
var slet="abcdefghijklmnopqrstuvwxyz";
var clet="ABCDEFGHIJKLMNOPQRSTUVWXYZ";

/////////////////////////////////////////////////////////////////////
// The following function is called if the Decrypt button is clicked
/////////////////////////////////////////////////////////////////////


function decrypt()
{

	// create a variable decString which hold the decrypted string
	
	var decString="";
	
	// get the value of encpt string and make it lowercase
	
	var acVal=document.form3.encpt.value.toLowerCase();
	
	// get current value of num
	
	cipNum=parseInt(document.form1.num.value);
	
	len=acVal.length;
	
	for(i=0;i<len;i++)
	{
		// get character of each position
	
		char=acVal.charAt(i);
		
		// if the character is a blank space then ignore it
	if(isNaN(char)&&char!="("&&char!=")"&&char!="-"&&char!="="&&char!="+"&&char!="_"&&char!="\n"&&char!="£"&&char!="!"&&char!="@"&&char!="#"&&char!="$"&&char!="%"&&char!="^"&&char!="&"&&char!="*"&&char!="{"&&char!="}"&&char!="["&&char!="]"&&char!="|"&&char!="\\"&&char!=":"&&char!=";"&&char!=","&&char!="<"&&char!="."&&char!=">"&&char!="/"&&char!="?"&&char!="'"&&char!="\"")
	{
		if(char!=" ")
		{
		
		
			// get the character's position in slet
		
			pos=slet.indexOf(char);
		
			// get the index of the replacement character
		
			index=pos-cipNum;
		
		
			// if index is greater than 25 then start from the beginning		
		
			if(index<0)
				lindex=26+index;
			else
				lindex=index;
		
			decString+=letter[lindex];
			
		}
		
		if(char==" ")
		{
		
			decString+=" ";
		
		}
	}
	else
		{
	
		decString+=char;
		
		}
	}
	
	document.form3.actual.value=decString.toLowerCase();			
	
}


/////////////////////////////////////////////////////////////////////
// The following function is called if the Encrypt button is clicked
/////////////////////////////////////////////////////////////////////

function callEncrypt()
{

	if(document.form3.typ[1].checked)
	{
	
		encrypt();
	
	}
	else
	{
	
		encryptLetter();
	
	}

}

function encryptLetter()
{

	var encString="";
	
	acVal=document.form3.actual.value.toLowerCase();
	var cipVal=document.form3.encpt.value;
	// get current value of num
	if(cipVal=="")
		k=0;
	cipNum=parseInt(document.form1.num.value);
	
	//i=cipVal.length;
	len=acVal.length;
	
	//for(i=0;i<len;i++)
	if(k<=len)
	{
		// get character of each position
	
		char=acVal.charAt(k);
		if(isNaN(char)&&char!="("&&char!=")"&&char!="-"&&char!="\="&&char!="+"&&char!="_"&&char!="\n"&&char!="£"&&char!="!"&&char!="@"&&char!="#"&&char!="$"&&char!="%"&&char!="^"&&char!="&"&&char!="*"&&char!="{"&&char!="}"&&char!="["&&char!="]"&&char!="|"&&char!="\\"&&char!=":"&&char!=";"&&char!=","&&char!="<"&&char!="."&&char!=">"&&char!="/"&&char!="?"&&char!="'"&&char!="\"")
		// if the character is a blank space then ignore it
		{		
			if(char!=" ")
			{
		
			
				// get the character's position in slet
		
				pos=slet.indexOf(char);
			
				// get the index of the replacement character
			
				index=pos+cipNum;
		
		
				// if index is greater than 25 then start from the beginning		
		
				if(index>25)
					lindex=index-26;
				else
					lindex=index;
		
				encString+=letter[lindex];
			
			}
/*			else if((document.form3.spc.checked==true)&&(char==" "))
			{
		
				encString+=" ";
		
			}*/
		}
		else if(char!=" ")
		{
			encString+=char;
		}
		else if(document.form3.spc.checked==true)
		{
			encString+=" ";
		}
		
	}
	
	document.form3.encpt.value = document.form3.encpt.value + encString;
	k++;
}

function encrypt()
{
	// declare a variable which hold the encrypted string
	
	var encString="";
	acVal=document.form3.actual.value.toLowerCase();
	
	// get current value of num
	
	cipNum=parseInt(document.form1.num.value);
	
	
	len=acVal.length;
	
	for(i=0;i<len;i++)
	{
		// get character of each position
	
		char=acVal.charAt(i);
		if(isNaN(char)&&char!="("&&char!=")"&&char!="-"&&char!="\="&&char!="+"&&char!="_"&&char!="\n"&&char!="£"&&char!="!"&&char!="@"&&char!="#"&&char!="$"&&char!="%"&&char!="^"&&char!="&"&&char!="*"&&char!="{"&&char!="}"&&char!="["&&char!="]"&&char!="|"&&char!="\\"&&char!=":"&&char!=";"&&char!=","&&char!="<"&&char!="."&&char!=">"&&char!="/"&&char!="?"&&char!="'"&&char!="\"")
		// if the character is a blank space then ignore it
		{		
			if(char!=" ")
			{
		
			
				// get the character's position in slet
		
				pos=slet.indexOf(char);
			
				// get the index of the replacement character
			
				index=pos+cipNum;
		
		
				// if index is greater than 25 then start from the beginning		
		
				if(index>25)
					lindex=index-26;
				else
					lindex=index;
		
				encString+=letter[lindex];
			
			}
/*			else if((document.form3.spc.checked==true)&&(char==" "))
			{
		
				encString+=" ";
		
			}*/
		}
		else if(char!=" ")
		{
			encString+=char;
		}
		else if(document.form3.spc.checked==true)
		{
			encString+=" ";
		}
	}
	
	document.form3.encpt.value=encString;		
	
}





///////////////////////////////////////////////////////////
// The following function is used for puzzle
///////////////////////////////////////////////////////////


function setText()
{

	alert("See if you can decipher the text by detecting the size of the Caesar Shift used to encipher it");
	document.form3.encpt.value="L FDPH, L VDZ, L FRQTXHUHG";

}



///////////////////////////////////////////////////////////
// The function incNum() and decNum() increase and decrease
// the number of textbox num.
///////////////////////////////////////////////////////////



function changeNum()
{
	var number=parseInt(document.form1.num.value);

	// if the value of the textbox is 25 then set it zero
	
	if(number>=25)
	{
	
		document.form1.num.value=" 0";

	}
	
	number=parseInt(document.form1.num.value);	

	//////////////////////////////////////////////////////////////////////////
	// change the value of 26 text box according to the number of num textbox
	//////////////////////////////////////////////////////////////////////////
	
	 for(i=1;i<=26;i++)
	 {
	 
	 	index=i+number-1;
		
		// if index is greater than 25 then start from the beginning		
		
		if(index>25)
			lindex=index-26;
		else
			lindex=index;
	 
	 	var txt=eval("document.form2.let"+i);
	 	txt.value=letter[lindex];
	 
	 }

}




function incNum()
{
	var number=parseInt(document.form1.num.value);

	// if the value of the textbox is 25 then set it zero
	
	if(number>=25)
	{
	
		document.form1.num.value=" 0";
		number=parseInt(document.form1.num.value);
	
	}
	else
	{
		number++;
		document.form1.num.value=number;
	}
	
	
	//////////////////////////////////////////////////////////////////////////
	// change the value of 26 text box according to the number of num textbox
	//////////////////////////////////////////////////////////////////////////
	
	 for(i=1;i<=26;i++)
	 {
	 
	 	index=i+number-1;
		
		// if index is greater than 25 then start from the beginning		
	
		if(index>25)
			lindex=index-26;
		else
			lindex=index;
	 
	 	var txt=eval("document.form2.let"+i);
	 	txt.value=letter[lindex];
	 
	 }

}


function decNum()
{
	var number=parseInt(document.form1.num.value);

	// if the value of the textbox is 0 then set it 25

	if(number<=0)
	{
	
		document.form1.num.value="25";
		number=parseInt(document.form1.num.value);
	
	}
	else
	{
		number--;
		document.form1.num.value=number;
	}
	
	//////////////////////////////////////////////////////////////////////////
	// change the value of 26 text box according to the number of num textbox
	//////////////////////////////////////////////////////////////////////////
	
	 for(i=1;i<=26;i++)
	 {
	 
	 	index=i+number-1;
		
		// if index is greater than 25 then start from the beginning
		
		if(index>25)
			lindex=index-26;
		else
			lindex=index;
	 
	 	var txt=eval("document.form2.let"+i);
	 	txt.value=letter[lindex];
	 
	 }

}



//////////////////////////////////////////////////////////////////////
// The following function show options for printing cipher.
//////////////////////////////////////////////////////////////////////

function printCipher()
{

	printWin=window.open("optionWin.htm", "winP", "top=40, left=40, width=450, height=300, status=1");

}


function check1(obj)
{
	if(obj.spc.value == 1)
	{
		obj.spc.value = 0;
		obj.spc.checked = false;
	}		
	else
	{
		obj.spc.value = 1;
		obj.spc.checked = true;
	}		
	
}
function ClearBox(obj)
{
	document.form3.actual.value = "";
	document.form3.encpt.value = "";
}

