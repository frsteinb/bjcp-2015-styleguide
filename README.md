# bjcp-2015-styleguide

## Another BJCP styleguide translation project

This is a new approach to achieve two goals:

- tranlating BJCP documents (primarily the beer styleguide 2015) to the German language (in a way that easily allows to add further languages),
- establishing an XML form of the styleguide in order to support a flexible transformation architecture for a variety of destination formats.

## Concept & Roadmap

- Create a consistent XML representation from the original BJCP styleguide docx document.
- Double-check its consitency, which is not implcit, because of potential typos and inconsistencies in the manually crafted original Word document.
- Continuously add and update translated content in the German "de" folder.
- Develop a XSL tranformation to rebuild a (partially) translated XML styleguide.
- Develop XSL / XSL-FO (maybe LaTeX) backends to create PDF, HTML and potentially other destination documents.

## Procedure

- If you are just curious about the current state of this project's results, you make take a look at the so called "[artifacts](https://gitlab.ibr.cs.tu-bs.de/steinb/bjcp-2015-styleguide/-/jobs/artifacts/master/download?job=build)" at the GitLab repository at  which are automatically rebuilt after each commit.

- MacOS systems should have the required tools. On Linux you should install some packages, e.g. on Ubuntu:
  ```
  apt install make curl libxml2-utils xsltproc
  ```
  (Sorry, I have no clue what to do on Windows systems.)
- Download and unarchive this project and enter its directory.
- Simply run
  ```
  make
  ```
  Don't care about lots of warning about missing external entities (files). These are the missing translation snippets that we have to supply step by step.
- You will now find:
  - The original complete styleguide in XML representation: `bjcp-2015-styleguide-orig.xml`
  - The broken-down original content as category, subcategory, and "subsubcategory" snippets in the directory: `orig`
  - A (partially) translated XML styleguide: `bjcp-2015-styleguide-de.xml`
- Now, you can gradually add and update translated content in the directory `de`. The structure should match `orig`. XML elements not present in the translated files will be copied from the `orig` data, when the translated styleguide will be generated. You will probably want to make use of this for the lists of "Commercial Examples", which are plain names of beer brands. Never modify XML element names or the XML structure, just edit the texts within the XML elements. Never change `id` attributes, never add `tags` or `specs` ("Vital Statistics") to the translated files, they will always be taken from the original data.
- To see the results of your translation work, you can re-run `make` at any time.

## Contact

This stuff has been initiated by the German homebrewing community at https://hobbybrauer.de and its [HBCon](https://heimbrauconvention.de) organization team.

Contact:
- Nils Vogel <nils.vogel@gmx.net> (primary HBCon contact)
- Frank Steinberg <frank@familie-steinberg.org> (coding this XML magic)

## TODO

- Add clear words to honor the original BJCP work.
- Care about copyright questions. Add LICENSE file.
- Add Acknowledgements to all contributors.
- Minor: Pay special attention to:
  - specs variants: 25B Saison (standard, pale, dark)
    --> fix/* !!!

