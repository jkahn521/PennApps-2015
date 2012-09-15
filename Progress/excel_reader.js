function excel_reader(){

    var csv_file = document.getElementById("class_data");

    if(csv_file.value.match(/\.csv$/gi) ==".csv"){
	var arr = readCSV(csv_file.value);

	function classObj(id, status){
	    this.id=id;
	    this.status=status;
	}

	var i;
	var class_data;
	for(i = 0; i < arr.length; i++){
	    var splitResult = arr[i].split(" ");
	    for(i = 0; i < splitResult.length; i++){
		splitResult[i]  = splitResult[i].replace(",","").split(/[,;]+/);  
	    }
	    current_class=new classObj(splitResult[0], splitResult[1]);
	    class_data.push(current_class);
	    document.write(current_class.id + " is " + current_class.status);

	}

    }


}

function readCSV(the_file){
   var req = new XMLHttpRequest();
    req.open("POST",locfile,false);
    req.send("");
    return req.responseText.split(/\n/g);
}
