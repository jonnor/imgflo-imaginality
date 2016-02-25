
## Usecases

* Compare existing imgflo graphs against eachother
* Develop new graphs
* Evaluate effects of rule-changes in generative *use* of imgflo

## Comparison mechanisms

* side-by-side
* Visual diff
* Reveal slider
* Toggle A/B

## Blind review

Blind/double-blind
Generate some experiements
Show various versions (A/B)
Voting: A or B preferred
Voting: isGood / isBad (comment)
Collect the data somehow.... Can be up to user of imaginality

Showing things in-context versus isolated

Original versus processed is particularly interesting> does processing make it get worse or better?

## Working inline

Many evaluations are very hard to do without seeing the images in-context.
Therefor it should be easy to use imaginality embedded into a webpage.

* Some .js library is provided
* Can be included on a page. Possibly dynamically and conditionally (special url params etc)
* Will pick up all the images in page (note: can also be CSS background-image etc)
* If url already is imgflo one, will be deconstructed to extract the input/source
* Need to avoid duplicates wrt to media-queries etc. Only images which are visibile should be changed
* Allows to create/see alternatives of original images in-place.
* Or to 'extract' them into another other presentation format, possibly overlayed on original

Theoretically one could have a browser extension, which allowed to do this for any page there is.

## Existing comparison libs

* Diffing, https://huddle.github.io/Resemble.js/
* Slider-comparison, before/after, http://thenewcode.com/819/A-Before-And-After-Image-Comparison-Slide-Control-in-HTML5
* Similarity value, nothing visual: http://tcorral.github.io/IM.js/examples_and_documents/index.html
* Using Root-Mean-Square to get similarity value, http://stackoverflow.com/questions/9136524/are-there-any-javascript-libs-to-pixel-compare-images-using-html5-canvas-or-any
* Visual diff, http://humblesoftware.github.io/js-imagediff/test.html

