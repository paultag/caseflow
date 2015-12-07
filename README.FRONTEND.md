# Front-end development docs

- [CSS Development Notes](README.FRONTEND.md#devnotes)
    - [Dependencies / External resources](README.FRONTEND.md#css-dependencies)
    - [Naming conventions](README.FRONTEND.md#css-naming)
    - [Overriding Web Design Standards CSS](README.FRONTEND.md#overriding)
- [JS](README.FRONTEND.md#js)
    - [JS Dependencies](README.FRONTEND.md#js-depends)
- [SVG and Icons](README.FRONTEND.md#svg)
    - [Creating SVG icons and images](README.FRONTEND.md#svg-making)
    - [SVG icon guidelines and tips](README.FRONTEND.md#svg-guidelines)

<span id="devnotes"></span>
## CSS Development Notes

- This project uses [SCSS](http://sass-lang.com/).
- It also uses (or will by the time it's done) a naming system that is similar to [BEM](https://en.bem.info/method/naming-convention/)

<span id="css-dependencies"></span>
### Dependencies / External resources
- [U.S. Web Design Standards](https://playbook.cio.gov/designstandards/) project
- [Bourbon.io](http://bourbon.io/) is the mixin library.
- Some patterns are based on [Refills](http://refills.bourbon.io/)
- [normalize.css v3.0.2](https://necolas.github.io/normalize.css/) sets a cross-browser baseline

<span id="css-naming"></span>
### Naming conventions

(Work in progress)

Prefix | Use for
---------------------
`cf-icon` | Icons
`cf-text` | Text layout or formatting-related styles
`cf-table`| Table-related layouts

<span id="overriding"></span>
### Overriding Web Design Standards CSS

- Add an additional class name with a `cf-*` prefix, to override styles using the `usa-*` selector.
- If the problem is one of specificity (e.g., if Web Design Standards uses `form input[type=text]` instead of `[type=text]` ), use a class name, and add `!important` to the declaration.

    .cf-form-input-text {
        border-color: $color-secondary-dark !important;
    }

- _Only use !important to override the specificity of Web Design Standards selectors_. Otherwise, you'll just end up with a series of cascade problems and messy CSS.

<span id="js"></span>
## JavaScript Development Notes
Most JavaScript assets are managed using the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html).

<span id="js-depends"></span>
### Current dependencies
- jQuery v1.11.3
- [clipboard.js](https://zenorocha.github.io/clipboard.js) v1.5.5

<span id="svg"></span>
## Icons and SVG

Use inline SVG for icons rather than an icon font. [Why?](http://blog.cloudfour.com/seriously-dont-use-icon-fonts/)

- Inline SVG can be made accessible using the `title` element.
- Icon fonts potentially have collisions with Unicode (emoji) characters.
- Assistive technology tools try to read the characters
- Inline SVG eliminates the overhead of an HTTP request and will load as long as the page does.  

<span id="svg-making"></span>
### Creating SVG icons and images

Super obvious: create icons using graphics software such as Sketch or Illustrator. Less obvious: most of **our icons use [FontAwesome](http://fontawesome.io/)**, but with the text converted to a shape.

- Download and install FontAwesome as a Desktop font. (Yes, you'll need administrative access in order to install the font.)
- Copy the icon you want from the [FontAwesome cheatsheet](fontawesome.io/cheatsheet/) and paste it into the image document.
   - If your icon looks like a blank rectangle, or a rectangle with an X inside, change the character's font to FontAwesome.
- Convert it from text to outlines or shapes. _Don't need to set a fill or stroke color. Use CSS for that._
- Save / export it as SVG.
- Bonus points if you minimize it using a tool such as [SVGO](https://github.com/svg/svgo)
- Commit the icon to the repo, so that it can be reused and repurposed.

<span id="svg-guidelines"></span>
### SVG icon guidelines and tips

After you create an SVG image, you'll need to tweak it a little bit by hand. It's plain text, so any editor will do. Make these changes.

- **Add a `title` element if the icon is meant to convey information.** For example, the <svg width="10" height="10" class="cf-icon-missing" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 55 55"><title>missing</title><path fill="#c00" d="M52.6 46.9l-6 6c-.8.8-1.9 1.2-3 1.2s-2.2-.4-3-1.2l-13-13-13 13c-.8.8-1.9 1.2-3 1.2s-2.2-.4-3-1.2l-6-6c-.8-.8-1.2-1.9-1.2-3s.4-2.2 1.2-3l13-13-13-13c-.8-.8-1.2-1.9-1.2-3s.4-2.2 1.2-3l6-6c.8-.8 1.9-1.2 3-1.2s2.2.4 3 1.2l13 13 13-13c.8-.8 1.9-1.2 3-1.2s2.2.4 3 1.2l6 6c.8.8 1.2 1.9 1.2 3s-.4 2.2-1.2 3l-13 13 13 13c.8.8 1.2 1.9 1.2 3s-.4 2.2-1.2 3z"/></svg> icon indicates whether or not a document is missing, and should have a `title` element. Place the title within an `svg`, or `g` parent.

    ````
    <svg width="55" height="55" class="cf-icon-missing" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 55 55">
        <title>missing</title>
        <path d="M52.6 46.9l-6 6c-.8.8-1.9 1.2-3 1.2s-2.2-.4-3-1.2l-13-13-13 13c-.8.8-1.9 1.2-3 1.2s-2.2-.4-3-1.2l-6-6c-.8-.8-1.2-1.9-1.2-3s.4-2.2 1.2-3l13-13-13-13c-.8-.8-1.2-1.9-1.2-3s.4-2.2 1.2-3l6-6c.8-.8 1.9-1.2 3-1.2s2.2.4 3 1.2l13 13 13-13c.8-.8 1.9-1.2 3-1.2s2.2.4 3 1.2l6 6c.8.8 1.2 1.9 1.2 3s-.4 2.2-1.2 3l-13 13 13 13c.8.8 1.2 1.9 1.2 3s-.4 2.2-1.2 3z">
    </svg>
    ````

- **Do not add a `title` element if the icon doesn't convey information**. Screen readers announce that text. Don't overwhelm the user.

- **Add `height` and `width` attributes to the opening `svg` element.** Internet Explorer does funky things if you don't. Make the `width` match the third value of the `viewBox` attribute. Make the `height` match the last value.

    ```
    <svg width="60" height="55" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 55">
    ```

- **Add a `.cf-icon-*` class name.** For example, `class="cf-icon-missing"`. Shared styles for all `.cf-icon-*` icons are in `application.css.scss`, (look for the `[class|=cf-icon]` selector). Update the CSS accordingly, setting the `fill` and/or `stroke-color` properties. _Use color variables defined in [U.S. Web Design Standards](https://playbook.cio.gov/designstandards/visual-style/#colors)._ Also note that only [some SVG properties]( http://www.w3.org/TR/SVG/styling.html#SVGStylingProperties) can be changed with CSS.

	```
    .cf-icon-missing {
        fill: $color-secondary-dark;
    }
    ```
