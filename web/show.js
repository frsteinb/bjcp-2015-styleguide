
var styleguide;
var styleguide_node;

// load styleguide and trigger rendering
var xhr1 = new XMLHttpRequest();
xhr1.onreadystatechange = function() {
    if (xhr1.readyState === 4) {
	styleguide = xhr1.responseXML.querySelector("styleguide");
	renderStyleguide(styleguide);
	if (window.location.href.indexOf("#") > -1) {
	    idref = window.location.href.replace(/^.*#/g, '');
	    var node = document.querySelector("*[id='" + idref + "']");
	    node.classList.remove("closed");
	    node.classList.add("open");
	    if ((node.parentNode.tagName == "subcategory") || (node.parentNode.tagName == "category")) {
		node.parentNode.classList.remove("closed");
		node.parentNode.classList.add("open");
		if (node.parentNode.parentNode.tagName == "category") {
		    node.parentNode.parentNode.classList.remove("closed");
		    node.parentNode.parentNode.classList.add("open");
		}
	    }
	    window.location.href = "#" + idref;
	}
    }
}
xhr1.open('GET', document.querySelector('link[rel="styleguide"]').href, true);
xhr1.setRequestHeader('Content-Type','text/xml; charset=UTF-8');
xhr1.responseType = "document";
xhr1.send();

function renderStyleguide(styleguide) {

    styleguide_node = document.importNode(styleguide, true);
    var div = document.querySelector("div[id='styleguide']");
    div.parentNode.insertBefore(styleguide_node, div);

    var parts = styleguide_node.querySelectorAll("chapter, category, subcategory");
    for (var i = 0; i < parts.length; i++) {

	// add category id to the name element, so that it becomes searchable in browsers
	if ((parts[i].tagName == "category") || (parts[i].tagName == "subcategory")) {
	    var id0 = parts[i].getAttribute("id");
	    var name0 = parts[i].querySelector("name");
	    if (id0 && name0) {
		id0 = id0.replace(/\-.*$/,"");
		name0.textContent = id0 + ": " + name0.textContent;
	    }
	}

	// add navigation element
	var nav = document.createElement("nav");
	parts[i].insertBefore(nav, parts[i].childNodes[0]);
    
	nav.addEventListener("dblclick", function() {
	    if (this.parentNode.classList.contains("closed")) {
		var parts = document.querySelectorAll("category, subcategory");
		for (var i = 0; i < parts.length; i++) {
		    parts[i].classList.remove("closed");
		    parts[i].classList.add("open");
		}
	    } else {
		var parts = document.querySelectorAll("category, subcategory");
		for (var i = 0; i < parts.length; i++) {
		    parts[i].classList.add("closed");
		    parts[i].classList.remove("open");
		}
	    }
	});

	nav.addEventListener("click", function() {
	    if (this.parentNode.classList.contains("closed")) {
		this.parentNode.classList.remove("closed");
		this.parentNode.classList.add("open");
	    } else {
		this.parentNode.classList.add("closed");
		this.parentNode.classList.remove("open");
	    }
	});

	parts[i].classList.add("closed");
	parts[i].classList.remove("open");

    }

}
