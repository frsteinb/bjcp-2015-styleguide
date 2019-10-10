
const body = document.getElementsByTagName("body")[0];
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

var editelem;
var tagname;

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
		dosave();
	    }
	},
	{
	    name: 'cancel',
	    icon: '<div style="background-color:pink;">cancel</div>',
	    title: 'cancel',
	    result: () => {
		docancel();
	    }
	},
    ],
    onChange: (html) => {
	x = html;
	x = x.replace(/&nbsp;/g, " ");
	if (tagname != "description") {
	    x = x.replace(/<p>/g, " ");
	    x = x.replace(/<\/p>/g, " ");
	}
	x = x.replace(/<br>/g, " ");
	x = x.replace(/  */g, " ");
	x = x.replace(/^ */,"");
	x = x.replace(/ *$/,"");
	if (markup) {
	    markup.innerText = x;
	}
	if (render) {
	    render.innerHTML = x;
	}
    }
})

function doedit(elem) {
    editid = elem.parentNode.getAttribute("id");
    editname = elem.parentNode.getElementsByTagName("name")[1].innerText;
    editelem = elem;
    tagname = elem.tagName.toLowerCase();
    editlastdate = elem.getAttribute("date");
    editlastauthor = elem.getAttribute("author");
    t = elem.innerHTML;
    t = t.replace(/^ */,"");
    t = t.replace(/ *$/,"");
    t = t.replace(/  */g, " ");
    if (tagname != "description") {
	t = t.replace(/<p>/g, " ");
	t = t.replace(/<\/p>/g, " ");
    }
    pelleditor.content.innerHTML = t;
    origelem = elem.nextSibling;
    if (lastdate && lastauthor) {
	text = "last updated by " + lastauthor + " on " + lastdate;
    } else {
	text = ""
    }
    editstyleid.innerText = editid ? editid : "-";
    editstylename.innerText = editname ? editname : "-";
    editelemname.innerText = tagname ? tagname : "-";
    lastdate.innerText = editlastdate ? editlastdate : "original";
    lastauthor.innerText = editlastauthor ? editlastauthor : "original";
    if (origelem) {
	original.innerHTML = origelem.innerHTML;
    }
    if (markup) {
	markup.innerText = elem.innerHTML;
    }
    if (render) {
	render.innerHTML = elem.innerHTML;
    }
    editor.style.display = "block";
    pelleditor.content.focus();
    
}

function docancel() {
    editor.style.display = "none";
}

function dosave() {

    x = pelleditor.content.innerHTML;
    x = x.replace(/&nbsp;/g, " ");
    if (tagname != "description") {
	x = x.replace(/<p>/g, " ");
	x = x.replace(/<\/p>/g, " ");
    }
    x = x.replace(/<br>/g, " ");
    x = x.replace(/\n/g,"");
    x = x.replace(/  */g, " ");
    x = x.replace(/^ */,"");
    x = x.replace(/ *$/,"");

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function() {
	if (xhr.readyState === 4) {
	    editor.style.display = "none";
	    editelem.innerHTML = x;
	    editelem.setAttribute("date", "today");
	    editelem.setAttribute("author", "you");
	    editelem.setAttribute("addr", "local");
	    editelem.setAttribute("source", "this-session");
	}
    }

    user = author.value;
    xhr.open('POST', "save.cgi?id=" + editid + "&elem=" + tagname + "&user=" + user, true);
    xhr.setRequestHeader('Content-Type','text/xml; charset=UTF-8');
    xhr.responseType = "text";
    xhr.send(x);

}




var l = document.querySelectorAll("chapter, category, subcategory");
for (var i = 0; i < l.length; i++) {

    nav = document.createElement("nav");
    l[i].insertBefore(nav, l[i].childNodes[0]);
    
    nav.addEventListener("dblclick", function() {
	if (this.parentNode.classList.contains("collapsed")) {
	    var l = document.querySelectorAll("category, subcategory");
	    for (var i = 0; i < l.length; i++) {
		l[i].classList.remove("collapsed");
	    }
	} else {
	    var l = document.querySelectorAll("category, subcategory");
	    for (var i = 0; i < l.length; i++) {
		l[i].classList.add("collapsed");
	    }
	}
    });

    l[i].classList.add("collapsed");

    var o = l[i].querySelectorAll('*[source="original"]');
    nav.setAttribute("todo",o.length);

    nav.addEventListener("click", function() {
	this.parentNode.classList.toggle("collapsed");
    });
}

