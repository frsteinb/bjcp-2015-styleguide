
const editor = document.getElementById("editor");
const pell = window.pell;
const pelleditor = document.getElementById("pelleditor");
const original = document.getElementById("original");
const auto = document.getElementById("auto");
const undo = document.getElementById("undo");
const markup = document.getElementById("markup");
const render = document.getElementById("render");
const author = document.getElementById("author");
const editstyleid = document.getElementById("editstyleid");
const editstylename = document.getElementById("editstylename");
const editelemname = document.getElementById("editelemname");
const lastdate = document.getElementById("lastdate");
const lastauthor = document.getElementById("lastauthor");
const translated = document.getElementById("translated");
const total = document.getElementById("total");

var edit_id;
var edit_element;
var element_name;

var styleuide_orig;
var styleuide_auto;



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
	    name: 'revert',
	    icon: 'revert',
	    title: 'revert',
	    result: () => {
		pelleditor.content.innerHTML = undo.innerHTML;
	    }
	},
	{
	    name: 'auto-translated',
	    icon: 'auto-translated',
	    title: 'auto-translated',
	    result: () => {
		pelleditor.content.innerHTML = auto.innerHTML;
	    }
	},
	{
	    name: 'save',
	    icon: 'save',
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
		
		user = author.value;
		if (! user) {
		    var r = confirm("Wirklich anonym speicher? (Es wäre nett, wenn Du vor dem Speichern Deinen Nickname oben im umrandeten Kasten eingibst.)");
		    if (r == true) {
	                xhr.onreadystatechange = function() {
	                    if (xhr.readyState === 4) {
	                        editor.style.display = "none";
	                        if (element_name == "name") {
	                            edit_element.innerHTML =  edit_id + ": " + text;
	                        } else {
	                            edit_element.innerHTML = text;
	                        }
	                        edit_element.setAttribute("date", "today");
	                        edit_element.setAttribute("author", "you");
	                        edit_element.setAttribute("addr", "local");
	                        edit_element.setAttribute("source", "this-session");
	                        
	                        recalcTodo();
			    }
			}
                    }
                }
                
		xhr.open('POST', "save.cgi?id=" + edit_id + "&elem=" + element_name + "&user=" + user, true);
		xhr.setRequestHeader('Content-Type','text/xml; charset=UTF-8');
		xhr.responseType = "text";
		xhr.send(text);
	    }
	},
	{
	    name: 'cancel',
	    icon: 'cancel',
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

// load styleguide_auto
var xhr3 = new XMLHttpRequest();
xhr3.onreadystatechange = function() {
    if (xhr3.readyState === 4) {
	styleguide_auto = xhr3.responseXML.querySelector("styleguide");
	// TBD: call initEditor() event driven, when show.js is ready.
	setTimeout(initEditor, 1000);
    }
}
xhr3.open('GET', document.querySelector('link[rel="styleguide-auto"]').href, true);
xhr3.setRequestHeader('Content-Type','text/xml; charset=UTF-8');
xhr3.responseType = "document";
xhr3.send();



function recalcTodo() {
    var parts = styleguide_node.querySelectorAll("category, subcategory");
    for (var i = 0; i < parts.length; i++) {
	var nav = parts[i].getElementsByTagName("nav")[0];
	var originals = parts[i].querySelectorAll('*[source="original"]');
	nav.setAttribute("todo", originals.length);
    }

    var parts = styleguide_node.querySelectorAll("category");
    var sum = 0;
    var trans = 0;
    for (var i = 0; i < parts.length; i++) {
	sum += parts[i].querySelectorAll('*[source]').length;
	trans += parts[i].querySelectorAll('*[source="original"]').length;
    }
    trans = sum - trans;
    if (total) {
	total.childNodes[0].nodeValue = sum;
    }
    if (translated) {
	translated.childNodes[0].nodeValue = trans;
    }
}



function initEditor() {

    var editor = document.querySelector("div[id='editor']");
    //editor.parentNode.insertBefore(styleguide_node, editor);

    var parts = styleguide_node.querySelectorAll("name, description, overall-impression, aroma, appearance, flavor, mouthfeel, comments, history, characteristic-ingredients, style-comparison, entry-instructions, commercial-examples, specs");
    for (var i = 0; i < parts.length; i++) {
	if ((parts[i].tagName == "specs") && (parts[i].querySelectorAll("ibu, og, fg, srm, abv").length >= 1)) {
	    continue;
	}
	parts[i].addEventListener("click", function() {
	    edit_element = this;
	    edit_id = edit_element.parentNode.getAttribute("id");
	    element_name = edit_element.tagName.toLowerCase();
	    orig_record = styleguide_orig.querySelector("*[id='" + edit_id + "']");
	    orig_element = orig_record.querySelector(element_name);
	    orig_record_name = orig_record.querySelector("name").childNodes[0].nodeValue;
	    auto_record = styleguide_auto.querySelector("*[id='" + edit_id + "']");
	    auto_element = auto_record.querySelector(element_name);
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
	    if (element_name == "name") {
		text = text.replace(/^.*: /g, "");
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
	    if (orig_element && original) {
		original.innerHTML = orig_element.innerHTML;
	    }
	    if (auto_element && auto) {
		auto.innerHTML = auto_element.innerHTML;
	    }
	    if (undo) {
		if (element_name == "name") {
		    undo.innerHTML = edit_element.innerHTML.replace(/^.*: /g, "");
		} else {
		    undo.innerHTML = edit_element.innerHTML;
		}
	    }
	    if (markup) {
		markup.innerText = edit_element.innerHTML;
	    }
	    if (render) {
		render.innerHTML = edit_element.innerHTML;
	    }

	    this.parentNode.classList.add("open");
	    this.parentNode.classList.remove("closed");

	    
	    editor.remove();
	    edit_element.parentNode.insertBefore(editor, edit_element.nextSibling);
	    editor.style.display = "block";
	    pelleditor.content.focus();
	    
	});
    }

    recalcTodo();
}



function copy_to_edit(id) {
    pelleditor.content.innerHTML = document.getElementById(id).innerHTML;
}
