
# bjcp-2015-styleguide

## Another BJCP styleguide translation project

This is a new approach to achieve two goals:

- tranlating BJCP documents (primarily the beer styleguide 2015) to the German language,
- establishing an XML form of the styleguide in order to support a flexible transformation architecture for a variety of destination formats.

## Concept & Roadmap

- Create a consistent XML representation from the original BJCP styleguide docx document.
- Double-check its consitency, which is not implcit, because of potential typos and inconsistencies in the manually crafted original Word document.
- Continuously add and update translated content in the German "de" folder.
- Develop a XSL tranformation to rebuild a (partially) translated XML styleguide.
- Develop XSL / XSL-FO (maybe LaTeX) backends to create PDF, HTML and potentially other destination documents.

## Procedure

- MacOS systems should have the required tools. On Linux you should install some packages, e.g. on Ubuntu:
  ```apt install make curl libxml2-utils xsltproc```
  (Sorry, I have no clue what to do on Windows systems.)
- Download and unarchive this project and enter its directory.
- Simply run
  ```make```
- You will now find:
  - The original complete styleguide in XML representation: `bjcp-2015-styleguide-orig.xml`
  - The broken-down original content as category, subcategory, and "subsubcategory" snippet in directory: `orig`
- Now, you can gradually add and update translated content in directory: `de`. The structure should match that in `orig`. XML elements not present in the translated files will be copied from the `orig` data, when the translated styleguide will be generated. Never change XML element names and the XML structure, never change `id` attributes, never add `tags` or `vital statistics`to the translated files, they will be used from the original data.
- To see the results of your translation work, you can re-run `make` at any time and look at `bjcp-2015-styleguide-de.xml`
- (nicely formated output documents will follow.)

## Contact

This stuff has been initiated by the German homebrewer community at https://hobbybrauer.de and its HBCon organization team.

Contact:
- Nils Vogel <nils.vogel@gmx.net>
- Frank Steinberg <frank@familie-steinberg.org>

## TODO

Pay special attention to:

- specs: Saison (standard, pale, dark, ...)
- specs: Lambic (varies w/ fruit)
- specs: Tropical Stout (missing some numbers)
- specs: Specialty IPA (Strength classification)
