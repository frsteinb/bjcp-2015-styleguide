
const editor = document.getElementById("editor");
const pell = window.pell;
const pelleditor = document.getElementById("pelleditor");
const original = document.getElementById("original");
const markup = document.getElementById("markup");
const render = document.getElementById("render");
const author = document.getElementById("author");

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
    editelem = elem;
    tagname = elem.tagName.toLowerCase();
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

    x = editelem.innerHTML;
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
	    // alert(xhr.response);
	}
    }

    user = author.value;
    xhr.open('POST', "save.cgi?id=" + editid + "&elem=" + tagname + "&user=" + user, true);
    xhr.setRequestHeader('Content-Type','text/xml; charset=UTF-8');
    xhr.send(x);

    editor.style.display = "none";

}
