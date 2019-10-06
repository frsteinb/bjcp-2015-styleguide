
const editor = document.getElementById("editor");
const pell = window.pell;
const pelleditor = document.getElementById("pelleditor");
const markup = document.getElementById("markup");

pell.init({
  element: pelleditor,
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
            text = window.prompt('Enter link text (optional)');
            pell.exec('insertHTML', '<a href="#' + idref + '">' + text + '</a>');
          } else {
            //pell.exec('insertHTML', '<a idref="#' + idref + '">' + text + '</a>');
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
        editor.style.display = "none";
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
    x = html;
    x = x.replace(/&nbsp;/g, " ");
    x = x.replace(/<div>/g, " ");
    x = x.replace(/<\/div>/g, " ");
    x = x.replace(/<br>/g, " ");
    x = x.replace(/  */g, " ");
    markup.innerText = x;
    render.innerHTML = x;
  }
})

function doedit(elem) {
  pelleditor.content.innerHTML = elem.innerHTML;
  editor.style.display = "block";
  markup.innerText = elem.innerHTML;
  render.innerHTML = elem.innerHTML;
}

