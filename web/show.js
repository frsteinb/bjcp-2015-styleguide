
var styleguide;
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

function renderStyleguide(styleguide) {

    styleguide_node = document.importNode(styleguide, true);
    var div = document.querySelector("div[id='styleguide']");
    div.parentNode.insertBefore(styleguide_node, div);

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

}
