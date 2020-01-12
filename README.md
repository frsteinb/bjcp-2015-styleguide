# bjcp-2015-styleguide

## Another BJCP styleguide translation project

The BJCP has put a great deal of hard voluntery work from many contributors into the 2015 beer style guidelines. Besides other derived formats, the primary resulting document is availabe as a PDF and as a Microsoft Word docx file from the [BJCP web pages](https://www.bjcp.org/stylecenter.php).

In this project we want to achieve the following goals:

- establish an XML form of the styleguide derived from the original BJCP Word document,
- tranlate the styleguide to the German language (in a way that easily allows to add further languages),
- transform the XML data to various target formats (HTML, PDF) using XSL and FO techniques.

To derive a consistent XML representation, we rely on the XML format of Word DOCX documents. However, since the original document is handcrafted by humans, we have to use some hacks in situations where the original document is less consistent. This means that our XSL code will not work for future releases of the styleguide.

In some rare cases, it may seem reasonable to apply slight adjustments to the original data. E.g., there is just one style (25B Saison), where the "Vital Statistics" section contains a form of further "subcategorization". We decided to explain this by words in the "Entry Instructions" and keep simple min-max ranges in all specs sections. Note that this "fixing" mechanism should remain a rarely used exception.

For a gradual translation process we use a split representation where each category and subcategory is stored in a single file, this allows to edit them in small pieces and independently by multiple authors.

Finally, XSL stylesheets get applied to create resulting XML and XHTML documents with content in the original english language and others translated into German. Other formats (and maybe other target languages) may follow in the future.

## Acknowledgements

Besides all the contributors to the original BJCP document we would like to thank the authors of translated content that found its way to this project:

- Brausportgruppe e.V. Rhein-Main
- Members from the Forum hobbybrauer.de: Fe2O3, Miicha, T3K, chaosblack, danieldee, toaster, fsb
- other anonymous contributors

## Getting Started

- MacOS systems should have all required tools once the XCode App is installed. On Linux you should install some packages, e.g. on Ubuntu:
  ```
  apt install make curl libxml2-utils xsltproc fop
  ```
  (Sorry, I have no clue what to do on Windows systems.)
- Clone the GitHub repository to your local system:
  ```
  git clone https://github.com/frsteinb/bjcp-2015-styleguide.git
  ```
  or
  ```
  git clone git@github.com:frsteinb/bjcp-2015-styleguide.git
  ```
- ```
  cd bjcp-2015-styleguide
  ```
- Now, in order to fetch the original BJCP document and build various derived and translated variants, simply run
  ```
  make
  ```
- You will now find:
  - The original complete styleguide in XML representation: `bjcp-2015-styleguide-orig.xml`
  - The broken-down original content as category, subcategory, and "subsubcategory" snippets in the directory: `orig`
  - A (partially) translated XML styleguide: `bjcp-2015-styleguide-de.xml`
  - An HTML form of the original styleguide: `bjcp-2015-styleguide-orig.html`
  - An HTML form of the translated styleguide: `bjcp-2015-styleguide-de.html`
- Now, you can gradually add and update translated content:

## Translation Guidelines

- Only add and edit files in the target language directory `de`. Never touch any other files (except by running `make`).
- To start a new translated category or subcategory, copy it from `orig` to `de` and translate its content. (Be sure not to overwrite already present translated files in `de`.)
- If you want to translate only some elements within a file, please remove the non-translated elements comletely (the whole XML element, not just the text bewteen the opening and closing tags). Missing elements will be copied from the english original. This helps to keep track of non-translated elements.
- In this sense, you probably do not want to translate `<commercial-examples>` sections.
- You may also add newly translated elements to already partially translated files or rephrase details, but be sure to always retain the XML structure of the `orig` file.
- Never translate XML element names, just edit the pure texts within the XML elements between the opening and closing XML tags.
- The only valid text decoration elements are `<b>bold</b>`, `<i>italic</i>` and `<u>underline</u>`. Do not nest these elements. Use them just guided by the `orig` data.
- One further exception: You may add references (links) to other categories or subcategories as `<a idref="1">name</a>` or simply `<a idref="1A"/>`. In the first case you specify the visible link text (here "name"). In the second case the link text will be the `<name>` of the referenced category or subcategory.
- All elements within category and subcategory files contain just one text block as a single paragraph. Do not try to add any formatting elements you may know from HTML.
- To see the results of your translation work, you can re-run `make` at any time.
- If some files in `de` are formatted inconsistently (we prefer two-blank-indents and just few line breaks and white space), you may call the following command. It just reformats the `de` files to consistent XML indentation. It will not change the formatting of resulting human-readable documents:
  ```
  make format
  ```
- If you want to see the status of already translated elements, you may run:
  ```
  make status
  ```
- You may check the XML validity of all XML files:
  ```
  make check
  ```
- Note: We aim for a real translation. Even if you are convinced that adding new details or rephrasing sections would make sense, please don't do that! (Maybe, we should establish a way to take notes in such cases. Let's discuss this, if you feel a real need.)
- Take care for a consistent wording of all subject matter specific terms throughout the whole styleguide.
- To supply your work back upstream to the repository server you need write access, please talk to the project maintainers. Then, use Git as usual (we cannot supply a Git tutorial here, but in general do something like):
  ```
  git add de/*.xml
  git commit -a
  git push
  ```

## Web Editor

For an ongoing distributed translation process, it is possible to install this project to a web server and run it as an online web editor that allows many people to contribute translation snippets without the need for Git, make, XML tools, etc. However, the webmaster has to take steps to get things running. Take a look at the "install" target in the Makefile. Once, it is running, the web server will have its own repository getting updated upon user translation contributions by a CGI script. Then on another (non-web) system you may setup the web editor repository as a remote (e.g.):
```
git remote add web ssh://frank@zbox.ibr.cs.tu-bs.de/var/www/bjcp-2015-styleguide
```
and then fetch its updates whenever you want, compare it, merge it, ... (again, this text cannot replace a Git tutorial):
```
git fetch web
git diff master web/master 
git merge web/master
```

## Contact

This stuff has been initiated by the German homebrewing community at https://hobbybrauer.de and its [HBCon](https://heimbrauconvention.de) organization team.

Contact:
- Nils Vogel <nils.vogel@gmx.net> (primary HBCon contact)
- Frank Steinberg <frank@familie-steinberg.org> (coding this XML magic)

## License

See the LICENSE file. Note that this license relates only to the content of this project. The original BJCP styleguide document loaded from the BJCP web site is NOT part of this project.

## TODO

- Add Acknowledgements to futher contributors?
- Improved tags handling (links, grouped lists, translated meaning, ...)
- Appendices
- Artifacts on GitHub?
- Refactor most of the old initial files.
- Title Page.
- Improve I18n.
- Revamp editor, probably no longer as an overlay.
- Maybe, some keyboard control?
- Support editing "p" (not only in "description"), "li", "td".
- Better rendering of specs with text content, e.g. 33A.
- Handling IDs correctly in editor and when saving.
- modifying parts of whole document addressed by getPathTo().
- Navigate by: tags, commercial examples, specs
- Render og, fg, srm in additional units.
