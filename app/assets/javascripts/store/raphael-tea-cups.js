var selected_teas = [];
var selected_teas_percentages = [34,33,33];
var selected_teas_count = 0;

var process_category = function (category) {
	var div = document.getElementById(category.name.replace(" ","_").toLowerCase()+"_cups");

	var listElement = document.createElement("ul");
	listElement.setAttribute("class", "tea-list");
	for( var tea = 0; tea < category.teas.length; tea++) {
		var listItem = create_listItem(category.teas[tea]);
		listElement.appendChild(listItem);
	}
	div.appendChild(listElement);
	var image = document.createElement("div");
	image.innerHTML =  "<img src = '/assets/" + category.name.replace(" ","") + "Cup.png' width='90' height='90'> <br />";
	div.appendChild(image);

	var categoryName = document.createElement("h2");
	categoryName.innerHTML = category.name+"s";

	div.appendChild(categoryName);

};

var create_listItem = function (tea) {
	var listItem = document.createElement("li");
	listItem.setAttribute("id",tea.tea_name);
	listItem.setAttribute("title",tea.description);
	listItem.setAttribute("style","font-size:16px;");
	listItem.innerHTML = tea.tea_name;

	listItem.onclick = function() {
		if (isSelectedTeasFull() && !isSelected(tea))
			return;

		if (!isSelected(tea)) {
			setListItemSelected(listItem, tea);
			addSelectedTea(tea)
		}
		else {
			listItem.innerHTML = tea.tea_name;
			listItem.className = "";
			removeSelectedTea(tea);
		}
	};

	return listItem;
};

var setListItemSelected = function (listItem, tea) {
	listItem.className = "selected";
	listItem.innerHTML = tea.tea_name + "<div><img src='/assets/delete-icon.png' width='16' height='16'></div>";
}

var isSelectedTeasFull = function () {
	if (selected_teas.length < 3 )
		return false;

	for (var i = 0; i < selected_teas.length; i++) {
		if (selected_teas[i] == null)
			return false;
	}

	return true;
};

var addSelectedTea = function(tea) {
	if (selected_teas_count < 3) {
		enableSlider(selected_teas_count);
		selected_teas[selected_teas_count] = tea;
	}
	else {
		for (var i = 0; i < selected_teas_count; i++) {
			if (selected_teas[i] == null)
			{
				selected_teas[i] = tea;
				break;
			}
		}
	}
	selected_teas_count++;
	updateUI();
};

var removeSelectedTea = function(tea) {
	for (var i = 0; i < selected_teas.length; i++) {
		if (selected_teas[i] == tea) {
			removeAndReshuffle(i);
		}
	}
	selected_teas_count--;
	updateUI();
};

var removeAndReshuffle = function(index) {
	for (var i = 0; i < selected_teas.length; i++) {
		if (i >= index) {
			selected_teas[i] = (i == selected_teas.length-1 ? null : selected_teas[i+1]);
			selected_teas_percentages[i] = (i == selected_teas_percentages.length-1 ? 0 : selected_teas_percentages[i+1]);
		}
	}
}

var isSelected = function(tea) {
	for (var i = 0; i < selected_teas.length; i++) {
		if (selected_teas[i] == tea)
			return true;
	}
	return false;
};

var enableSlider = function (sliderNum) {
	if (sliderNum > 1)
		return;
	var slider = sliderNum == 0? "slider1":"slider2";
	$("#"+slider).slider("option", "disabled", false);
	document.getElementById(slider).style="ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all";
}

var disableSlider = function (sliderNum) {
	if (sliderNum > 1)
		return;
	var slider = sliderNum == 0? "#slider1":"#slider2";
	$(slider).slider("option", "disabled", true);
	document.getElementById(slider).style="ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all ui-slider-disabled ui-disabled";
}

var updateUI = function() {
	updateFlavorInputs();
	updateSliderPercentage("percent1");
	updateSliderPercentage("percent2");
	updateSliderPercentage("percent3");
	update_blend_profile();
}

var updateFlavorInputs = function() {
	for (var i = 0; i < selected_teas.length; i++) {
		var input = document.getElementById("flavor" + (i+1));
		var sku_input = document.getElementById("sku" + (i+1));
		var div = document.getElementById("flavor" + (i+1) + "namediv");

		input.value = selected_teas[i] == null?"":selected_teas[i].tea_name;
		sku_input.value = selected_teas[i] == null?"":selected_teas[i].sku;
		div.innerHTML = selected_teas[i] == null?"Select Above":selected_teas[i].tea_name;
		
		if (selected_teas[i] != null)
			div.className = "active_flavor";
		else
			div.className = "inactive_flavor";
	}
	update_blend_profile();
};

var updateSliderPercentage = function(slider) {
	if (selected_teas_count == 1) {
		selected_teas_percentages[0] = 100;
		selected_teas_percentages[1] = 0;
		selected_teas_percentages[2] = 0;
		$("#slider1").slider("value",selected_teas_percentages[0]);
		$("#slider2").slider("value",selected_teas_percentages[1]);
		$("#slider3").slider("value",selected_teas_percentages[2]);
	}
	else if (selected_teas_count == 2) {
		if (slider == "percent1") {
			selected_teas_percentages[1] = 100 - selected_teas_percentages[0];
			selected_teas_percentages[2] = 0;
		}
		else {
			selected_teas_percentages[0] = 100 - selected_teas_percentages[1];
			selected_teas_percentages[2] = 0;
				$("#slider1").slider("value",selected_teas_percentages[0]);
		}
		$("#slider2").slider("value",selected_teas_percentages[1]);
		$("#slider3").slider("value",selected_teas_percentages[2]);
	}
	else if (selected_teas_count == 3) {
		selected_teas_percentages[2] = 100 - selected_teas_percentages[0] - selected_teas_percentages[1];

		if (selected_teas_percentages[2] < 0) {
			if (slider == "percent1") {
				selected_teas_percentages[1] = 100 - selected_teas_percentages[0];
				$("#slider2").slider("value",selected_teas_percentages[1]);
			}
			else {
				selected_teas_percentages[0] = 100 - selected_teas_percentages[1];
				$("#slider1").slider("value",selected_teas_percentages[0]);
			}
			selected_teas_percentages[2] = 0;
		}

		$("#slider3").slider("value",selected_teas_percentages[2]);
	}

	document.getElementById("percent1").value = selected_teas_percentages[0];
	document.getElementById("flavor1percentdiv").innerHTML = selected_teas_percentages[0] + "%";
	document.getElementById("percent2").value = selected_teas_percentages[1];
	document.getElementById("flavor2percentdiv").innerHTML = selected_teas_percentages[1] + "%";
	document.getElementById("percent3").value = selected_teas_percentages[2] + "";
	document.getElementById("flavor3percentdiv").innerHTML = selected_teas_percentages[2] + "%";

	update_blend_profile();
};

var updateRangePercentages = function(ui) {
	selected_teas_percentages[0] = ui.values[0];
	selected_teas_percentages[1] = ui.values[1] - selected_teas_percentages[0],
	selected_teas_percentages[2] = 100 - selected_teas_percentages[0] - selected_teas_percentages[1];

	document.getElementById("percent1").value = selected_teas_percentages[0];
	document.getElementById("flavor1percentdiv").innerHTML = selected_teas_percentages[0] + "%";
	document.getElementById("percent2").value = selected_teas_percentages[1];
	document.getElementById("flavor2percentdiv").innerHTML = selected_teas_percentages[1] + "%";
	document.getElementById("percent3").value = selected_teas_percentages[2];
	document.getElementById("flavor3percentdiv").innerHTML = selected_teas_percentages[2] + "%";

	update_blend_profile();
};

function update_blend_profile() {
	var profiles = new Object();

	var keys = ["Aroma","Floral","Fruity","Nutty","Spicy","Sweetness","Vegetal","Woody","Strength"];
	for (var i = 0; i < keys.length; i++) {
		profiles[keys[i]] = 0;
	}

	for (var tea = 0; tea < selected_teas.length; tea++) {
		var currTea = selected_teas[tea];

		for (var i = 0; i < keys.length && currTea != null; i++) {
			var strValue = currTea.flavor_profile[keys[i]];
			var value = parseInt(selected_teas[tea].flavor_profile[keys[i]] ) * (selected_teas_percentages[tea] / 100);
			profiles[keys[i]] += value;
		}
	}

	var profile_name_string = "";
	var profile_value_string = "";
	var table = document.getElementById('flavor_profile_table');

	if (table != null) {
		document.getElementById("flavor_profile_row").removeChild(table);
	}

	table = document.createElement('table');
	table.setAttribute('id','flavor_profile_table');
	table.setAttribute('style','width:100%;');
	var tbody = document.createElement('tbody');
	table.appendChild(tbody);

	for(var i = 0; i < keys.length ; i++) {
		// round down using or method
		profiles[keys[i]] = _roundNumber(profiles[keys[i]],1);

		if (profiles[keys[i]] != 0) {
			var row = document.createElement('tr');
			row.setAttribute('style','border:none');
			var nameCell = document.createElement('td');
			nameCell.setAttribute('style','width:20%;');
			var valueCell = document.createElement('td');

			row.appendChild(nameCell);
			row.appendChild(valueCell);

			var name = new String(keys[i]);
			nameCell.innerHTML = keys[i] + ": <br />";
			valueCell.innerHTML =  "<img src = '/assets/store/star_" + (profiles[keys[i]]) + ".png' width='133px' height='20px'> <br />"
				+ "<input type=\"hidden\" readonly=\"readonly\" name=\"custom_product["+name.toLowerCase()+"]\" value=\""+ (profiles[keys[i]]) +"\">";

			tbody.appendChild(row);
		}
	}

	document.getElementById("flavor_profile_row").appendChild(table);
};

function _roundNumber(num,dec) {
	var newNum = 0;
	for ( var val = 0.5; val < num; val += 0.5) {
		newNum = val;
	}
	return newNum;
}
function getTeaByName (name) {
	for (var j = 0; j < json.categories.length; j++) {
		var category = json.categories[j].category;
		for( var tea = 0; tea < category.teas.length; tea++) {
			if (category.teas[tea].tea_name == name)
			 return category.teas[tea];
		}
	}
	return null;
}

function getListItem(tea_name) {
	return document.getElementById(tea_name);
}

function setFirstFlavor(flavorValue) {
	selected_teas = [];
	var tea = getTeaByName(flavorValue);
	var listItem = getListItem(tea.tea_name);
	setListItemSelected(listItem, tea);
	addSelectedTea(tea);

	$("#slider1").slider("value",selected_teas_percentages[0]);
	$("#slider2").slider("value",selected_teas_percentages[1]);
	$("#slider3").slider("value",selected_teas_percentages[2]);

	document.getElementById("percent1").value = selected_teas_percentages[0];
	document.getElementById("flavor1percentdiv").innerHTML = selected_teas_percentages[0] + "%";
	document.getElementById("percent2").value = selected_teas_percentages[1];
	document.getElementById("flavor2percentdiv").innerHTML = selected_teas_percentages[1] + "%";
	document.getElementById("percent3").value = selected_teas_percentages[2];
	document.getElementById("flavor3percentdiv").innerHTML = selected_teas_percentages[2] + "%";

	update_blend_profile();
};

function setupForEdit(){
	selected_teas = [];
	var temp_percentages = [];

	var width = 950, height = width, font_size = width*0.02;

	for (j = 0; j < json.categories.length; j++) {
		process_category(json.categories[j].category);
	}

    $("#slider1").slider({
		value: 35,
		disabled: true,
		step: 5,
		slide: function (event, ui) {
			selected_teas_percentages[0] = ui.value;
			updateSliderPercentage("percent1");
		}});
    $("#slider2").slider({
		value: 35,
		disabled: true,
		step: 5,
		slide: function (event, ui) {
			selected_teas_percentages[1] = ui.value;
			updateSliderPercentage("percent2");
		}});
    $("#slider3").slider({
		value: 30,
		step: 5,
		disabled: true});

	// set the percentages
	for (j = 0; j < 3; j++) {
		flavorValue = document.getElementById("flavor"+(j+1)+"namediv").innerHTML.trim();

		if (flavorValue != "Select Above") {
			temp_percentages[j] = parseInt(document.getElementById("percent"+(j+1)).value);
		}
	}

	for (var ji = 0; ji < 3; ji++) {
		flavorValue = document.getElementById("flavor"+(ji+1)+"namediv").innerHTML.trim();

		if (flavorValue != "Select Above") {
			var tea = getTeaByName(flavorValue);
			var listItem = getListItem(tea.tea_name);
			setListItemSelected(listItem, tea);
			addSelectedTea(tea);
		}
	}

	// set the percentages again since the addSelectedTea above changes them to defaults
	for (j = 0; j < 3; j++) {
		flavorValue = document.getElementById("flavor"+(j+1)+"namediv").innerHTML.trim();

		if (flavorValue != "Select Above") {
			selected_teas_percentages[j] = temp_percentages[j];
		}
	}

	$("#slider1").slider("value",selected_teas_percentages[0]);
	$("#slider2").slider("value",selected_teas_percentages[1]);
	$("#slider3").slider("value",selected_teas_percentages[2]);

	document.getElementById("percent1").value = selected_teas_percentages[0];
	document.getElementById("flavor1percentdiv").innerHTML = selected_teas_percentages[0] + "%";
	document.getElementById("percent2").value = selected_teas_percentages[1];
	document.getElementById("flavor2percentdiv").innerHTML = selected_teas_percentages[1] + "%";
	document.getElementById("percent3").value = selected_teas_percentages[2];
	document.getElementById("flavor3percentdiv").innerHTML = selected_teas_percentages[2] + "%";

	update_blend_profile();
};


function setup(flavorValue) {

	var width = 950, height = width, font_size = width*0.02;

	for (j = 0; j < json.categories.length; j++) {
		process_category(json.categories[j].category);
	}

    $("#slider1").slider({
		value: 35,
		disabled: true,
		step: 5,
		slide: function (event, ui) {
			selected_teas_percentages[0] = ui.value;
			updateSliderPercentage("percent1");
		}});
    $("#slider2").slider({
		value: 35,
		disabled: true,
		step: 5,
		slide: function (event, ui) {
			selected_teas_percentages[1] = ui.value;
			updateSliderPercentage("percent2");
		}});
    $("#slider3").slider({
		value: 30,
		step: 5,
		disabled: true});

 	selected_teas_percentages = [35,35,30];
	document.getElementById("percent1").value = selected_teas_percentages[0];
	document.getElementById("flavor1percentdiv").innerHTML = selected_teas_percentages[0] + "%";
	document.getElementById("percent2").value = 33;
	document.getElementById("flavor2percentdiv").innerHTML = selected_teas_percentages[1] + "%";
	document.getElementById("percent3").value = 33;
	document.getElementById("flavor3percentdiv").innerHTML = selected_teas_percentages[2] + "%";

	if(flavorValue != "") {
		setFirstFlavor(flavorValue);
	}
};

