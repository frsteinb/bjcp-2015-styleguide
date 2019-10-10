
const editor = document.getElementById("editor");
const pell = window.pell;
const pelleditor = document.getElementById("pelleditor");
const original = document.getElementById("original");
const markup = document.getElementById("markup");
const render = document.getElementById("render");
const author = document.getElementById("author");
const editstyleid = document.getElementById("editstyleid");
const editstylename = document.getElementById("editstylename");
const editelemname = document.getElementById("editelemname");
const lastdate = document.getElementById("lastdate");
const lastauthor = document.getElementById("lastauthor");

var edit_id;
var edit_element;
var element_name;

pell.init({
    element: pelleditor,
    defaultParagraphSeparator: "p",
    actions: [
	'bold',
	'italic',
	'underline',
	{
	    name: 'link',
	    result: () => {
		const idref = window.prompt('Enter the target category ID');
		if (idref) {
		    var selection = document.getSelection();
		    if (selection == "") {
			text = window.prompt('Enter visible link text');
			pell.exec('insertHTML', '<a href="#' + idref + '">' + text + '</a>');
		    } else {
			pell.exec('createLink', "#" + idref);
		    }
		}
	    }
	},
	{
	    name: 'save',
	    icon: '<div style="background-color:pink;">save</div>',
	    title: 'save',
	    result: () => {

		text = pelleditor.content.innerHTML;
		text = text.replace(/&nbsp;/g, " ");
		if (element_name != "description") {
		    text = text.replace(/<p>/g, " ");
		    text = text.replace(/<\/p>/g, " ");
		}
		text = text.replace(/<br>/g, " ");
		text = text.replace(/\n/g,"");
		text = text.replace(/  */g, " ");
		text = text.replace(/^ */,"");
		text = text.replace(/ *$/,"");
		
		var xhr = new XMLHttpRequest();
		
		xhr.onreadystatechange = function() {
		    if (xhr.readyState === 4) {
			editor.style.display = "none";
			edit_element.innerHTML = text;
			edit_element.setAttribute("date", "today");
			edit_element.setAttribute("author", "you");
			edit_element.setAttribute("addr", "local");
			edit_element.setAttribute("source", "this-session");
		    }
		}
		
		user = author.value;
		xhr.open('POST', "save.cgi?id=" + edit_id + "&elem=" + element_name + "&user=" + user, true);
		xhr.setRequestHeader('Content-Type','text/xml; charset=UTF-8');
		xhr.responseType = "text";
		xhr.send(text);
	    }
	},
	{
	    name: 'cancel',
	    icon: '<div style="background-color:pink;">cancel</div>',
	    title: 'cancel',
	    result: () => {
		editor.style.display = "none";
	    }
	},
    ],
    onChange: (html) => {
	text = html;
	text = text.replace(/&nbsp;/g, " ");
	if (element_name != "description") {
	    text = text.replace(/<p>/g, " ");
	    text = text.replace(/<\/p>/g, " ");
	}
	text = text.replace(/<br>/g, " ");
	text = text.replace(/  */g, " ");
	text = text.replace(/^ */,"");
	text = text.replace(/ *$/,"");
	if (markup) {
	    markup.innerText = text;
	}
	if (render) {
	    render.innerHTML = text;
	}
    }
})



var styleguide;
var styleuide_orig;
var styleguide_node;



// load styleguide and trigger rendering
var xhr1 = new XMLHttpRequest();
xhr1.onreadystatechange = function() {
    if (xhr1.readyState === 4) {
	styleguide = xhr1.responseXML.querySelector("styleguide");
	renderStyleguide(styleguide);
    }
}
xhr1.open('GET', document.querySelector('link[rel="styleguide"]').href, true);
xhr1.setRequestHeader('Content-Type','text/xml; charset=UTF-8');
xhr1.responseType = "document";
xhr1.send();

// load styleguide_orig
var xhr2 = new XMLHttpRequest();
xhr2.onreadystatechange = function() {
    if (xhr2.readyState === 4) {
	styleguide_orig = xhr2.responseXML.querySelector("styleguide");
    }
}
xhr2.open('GET', document.querySelector('link[rel="styleguide-orig"]').href, true);
xhr2.setRequestHeader('Content-Type','text/xml; charset=UTF-8');
xhr2.responseType = "document";
xhr2.send();


function recalcTodo() {
    var parts = styleguide_node.querySelectorAll("chapter, category, subcategory");
    for (var i = 0; i < parts.length; i++) {
	var nav = parts[i].getElementsByTagName("nav")[0];
	var originals = parts[i].querySelectorAll('*[source="original"]');
	nav.setAttribute("todo", originals.length);
    }
}

function renderStyleguide(styleguide) {

    styleguide_node = document.importNode(styleguide, true);
    var editor = document.querySelector("div[id='editor']");
    editor.parentNode.insertBefore(styleguide_node, editor);

    var parts = styleguide_node.querySelectorAll("name, description, overall-impression, aroma, appearance, flavor, mouthfeel, comments, history, characteristic-ingredients, style-comparison, entry-instructions, commercial-examples");
    for (var i = 0; i < parts.length; i++) {
	parts[i].addEventListener("click", function() {
	    edit_element = this;
	    edit_id = edit_element.parentNode.getAttribute("id");
	    element_name = edit_element.tagName.toLowerCase();
	    orig_record = styleguide_orig.querySelector("*[id='" + edit_id + "']");
	    orig_element = orig_record.querySelector(element_name);
	    orig_record_name = orig_record.querySelector("name").childNodes[0].nodeValue;
	    editlastdate = edit_element.getAttribute("date");
	    editlastauthor = edit_element.getAttribute("author");
	    text = edit_element.innerHTML;
	    text = text.replace(/^ */,"");
	    text = text.replace(/ *$/,"");
	    text = text.replace(/  */g, " ");
	    if (element_name != "description") {
		text = text.replace(/<p>/g, " ");
		text = text.replace(/<\/p>/g, " ");
	    }
	    pelleditor.content.innerHTML = text;
	    if (lastdate && lastauthor) {
		text = "last updated by " + lastauthor + " on " + lastdate;
	    } else {
		text = ""
	    }
	    editstyleid.innerText = edit_id ? edit_id : "-";
	    editstylename.innerText = orig_record_name ? orig_record_name : "-";
	    editelemname.innerText = element_name ? element_name : "-";
	    lastdate.innerText = editlastdate ? editlastdate : "original";
	    lastauthor.innerText = editlastauthor ? editlastauthor : "original";
	    if (orig_element) {
		original.innerHTML = orig_element.innerHTML;
	    }
	    if (markup) {
		markup.innerText = edit_element.innerHTML;
	    }
	    if (render) {
		render.innerHTML = edit_element.innerHTML;
	    }
	    editor.style.display = "block";
	    pelleditor.content.focus();
	});
    }

    var parts = styleguide_node.querySelectorAll("chapter, category, subcategory");
    for (var i = 0; i < parts.length; i++) {

	var nav = document.createElement("nav");
	parts[i].insertBefore(nav, parts[i].childNodes[0]);
    
	nav.addEventListener("dblclick", function() {
	    if (this.parentNode.classList.contains("collapsed")) {
		var parts = document.querySelectorAll("category, subcategory");
		for (var i = 0; i < parts.length; i++) {
		    parts[i].classList.remove("collapsed");
		}
	    } else {
		var parts = document.querySelectorAll("category, subcategory");
		for (var i = 0; i < parts.length; i++) {
		    parts[i].classList.add("collapsed");
		}
	    }
	});

	nav.addEventListener("click", function() {
	    this.parentNode.classList.toggle("collapsed");
	});

	parts[i].classList.add("collapsed");

    }

    recalcTodo();
}

